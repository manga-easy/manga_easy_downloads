import 'dart:async';
import 'dart:io';
import 'package:client_driver/client_driver.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hosts/hosts.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:persistent_database/persistent_database.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

class ServiceDownload extends ChangeNotifier {
  final Preference _preference;
  final DownloadRepository _downloadRepository;
  final ClientRequest _clientRequest;
  final MangaRepository _mangaRepository;

  ServiceDownload(
    this._preference,
    this._downloadRepository,
    this._clientRequest,
    this._mangaRepository,
  );

  final _downloadQueue = <ChapterStatus>[];
  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? path;

  ChapterStatus? _currentChapter;

  bool isCurrentChapter(Chapter chapter, String uniqueid) {
    final current = _currentChapter;
    if (current == null) {
      return false;
    }
    if (current.uniqueid != uniqueid) {
      return false;
    }
    return current.chapter.title == chapter.title;
  }

  bool isChapterInQueue(Chapter chapter, String uniqueid) {
    if (_downloadQueue.isEmpty) {
      return false;
    }
    final index = _downloadQueue.indexWhere(
      (element) =>
          element.uniqueid == uniqueid &&
          element.chapter.title == chapter.title,
    );

    return index != -1;
  }

  // Adiciona um URL à fila de downloads
  Future<void> enqueueDownload(Chapter chapter, String uniqueid) async {
    if (path == null) {
      path = await FilePicker.platform.getDirectoryPath();
      await _preference.put(
        keyPreferences: KeyPreferences.downloadFolder,
        value: path,
      );
    }
    if (!isChapterInQueue(chapter, uniqueid)) {
      final chapterStatus = ChapterStatus(
        chapter: chapter,
        status: Status.todo,
        uniqueid: uniqueid,
        path: path!,
      );
      _downloadQueue.add(chapterStatus);
      _downloadNext();
    }
    notifyListeners();
  }

  void removeChapter(Chapter chapter, String uniqueid) {
    _downloadQueue.removeWhere(
      (element) =>
          element.uniqueid == uniqueid &&
          element.chapter.title == chapter.title,
    );
    notifyListeners();
  }

  // Realiza o download do próximo item na fila
  void _downloadNext() {
    if (isDownloading || _downloadQueue.isEmpty) return;
    isDownloading = true;
    _downloadChapter(_downloadQueue.first).then((_) {
      isDownloading = false;
      _downloadNext();
    });
    notifyListeners();
  }

  double getDownloadProgress(int totalImages, int completedImages) {
    return totalImages > 0 ? completedImages / totalImages : 0.0;
  }

  void _progress(int totalImages, int completedImages) {
    downloadProgress = getDownloadProgress(totalImages, completedImages);
    notifyListeners();
  }

  Future<void> _downloadChapter(ChapterStatus chapterStatus) async {
    List<ImageChapter> auxImage = [];
    final pathChapter = '$path/manga-easy/${chapterStatus.uniqueid}/'
        '${chapterStatus.chapter.number}';
    final images = await _mangaRepository.getContentChapter(
      manga: chapterStatus.chapter.href,
      idHost: await _idHostByChapter(chapterStatus.uniqueid),
    );
    final chapterImage = chapterStatus.chapter.copyWith(imagens: images);
    await _saveChapter(
      chapter: chapterStatus.copyWith(
        status: Status.doing,
        chapter: chapterImage,
      ),
    );
    try {
      _currentChapter = chapterStatus;
      path = await _preference.get(
        keyPreferences: KeyPreferences.downloadFolder,
      );

      var directory = Directory(
        pathChapter,
      );

      if (!directory.existsSync()) {
        var status = await handler.Permission.storage.request();
        await directory.create(recursive: true);
        //  if (status.isGranted) {}
      }
      var totalDone = 0;
      for (var image in images) {
        try {
          _progress(images.length, totalDone);
          totalDone += 1;
          final file = File('${directory.path}/${image.src.split('/').last}');
          image.path = file.path;
          if (file.existsSync()) {
            auxImage.add(image);
            continue;
          }

          final response = await Dio().get(
            image.src,
            options: Options(
              headers: Global.header,
              responseType: ResponseType.bytes,
            ),
          );

          var compressImage = await FlutterImageCompress.compressWithList(
            response.data,
            quality: 20,
          );
          //quando quebrar o bovinão arruma
          await file.writeAsBytes(compressImage);
          auxImage.add(image);
        } catch (e) {
          Helps.log(e);
        }
      }
    } catch (e) {
      await _saveChapter(
        chapter: chapterStatus.copyWith(
          status: Status.error,
          path: pathChapter,
        ),
      );

      Helps.log(e);
    }
    final chapter = chapterStatus.chapter.copyWith(imagens: auxImage);
    _currentChapter = null;
    isDownloading = false;
    await _saveChapter(
      chapter: chapterStatus.copyWith(
        status: Status.done,
        chapter: chapter,
        path: pathChapter,
      ),
    );
    removeChapter(chapter, chapterStatus.uniqueid);
  }

  void pauseDownload() {
    //cancelToken.cancel();
  }

  Future<void> _saveChapter({
    required ChapterStatus chapter,
  }) async {
    final download = await _downloadRepository.get(uniqueid: chapter.uniqueid);
    download!.chapters.removeWhere(
      (element) => element.chapter.title == chapter.chapter.title,
    );

    download.chapters.add(
      chapter,
    );

    await _downloadRepository.update(
      data: download,
      uniqueid: chapter.uniqueid,
    );
  }

  Future<void> deleteChapter(Chapter chapter, String uniqueid) async {
    path = await _preference.get(
      keyPreferences: KeyPreferences.downloadFolder,
    );
    final result = await _downloadRepository.get(
      uniqueid: uniqueid,
    );
    if (result != null) {
      final index = result.chapters.indexWhere(
        (element) => element.chapter.title == chapter.title,
      );
      final chapterStatus = result.chapters.elementAt(index);
      try {
        final dir = Directory(
          chapterStatus.path,
        );
        await dir.delete(recursive: true);
      } on Exception catch (e) {
        Helps.log(e);
      }
      //remove o capitulo dos downloads
      result.chapters.removeAt(index);
      //se não tiver mais capitulos depois que removeu limpa o download entity tbm
      if (result.chapters.isEmpty) {
        await _downloadRepository.delete(uniqueid: result.uniqueid);
      } else {
        await _downloadRepository.update(
          data: result,
          uniqueid: result.uniqueid,
        );
      }
    }
    notifyListeners();
  }

  Future<int> _idHostByChapter(String uniqueid) async {
    final result = await _downloadRepository.get(
      uniqueid: uniqueid,
    );
    return result!.manga.idHost;
  }
}
