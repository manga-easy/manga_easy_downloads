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

  ServiceDownload(
    this._preference,
    this._downloadRepository,
    this._clientRequest,
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
  void enqueueDownload(Chapter chapter, String uniqueid) {
    if (!isChapterInQueue(chapter, uniqueid)) {
      _downloadQueue.add(ChapterStatus(chapter, Status.doing, uniqueid));
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

  void progress(int totalImages, int completedImages) {
    downloadProgress = getDownloadProgress(totalImages, completedImages);
    notifyListeners();
  }

  Future<void> _downloadChapter(ChapterStatus chapterStatus) async {
    List<ImageChapter> auxImage = [];
    try {
      _currentChapter = chapterStatus;
      path = await _preference.get(
        keyPreferences: KeyPreferences.downloadFolder,
      );
      if (path == null) {
        path = await FilePicker.platform.getDirectoryPath();
        await _preference.put(
          keyPreferences: KeyPreferences.downloadFolder,
          value: path,
        );
      }

      var directory = Directory(
        '$path/manga-easy/${chapterStatus.uniqueid}/${chapterStatus.chapter.number}',
      );

      if (!directory.existsSync()) {
        var status = await handler.Permission.storage.request();
        if (status.isGranted) {
          await directory.create(recursive: true);
        }
      }
      final host = ApiManga.getByID(
        host: HostModel.empty()..host = 'http://api.lucas-cm.com.br',
        headers: Global.header,
      );
      final images = await host.getConteudoChapter(
        manga: chapterStatus.chapter.href,
      );
      var totalDone = 0;
      for (var image in images) {
        try {
          progress(images.length, totalDone);
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
          await file.writeAsBytes(compressImage, mode: FileMode.write);
          auxImage.add(image);
        } catch (e) {
          Helps.log(e);
        }
      }
      chapterStatus.status = Status.done;
    } catch (e) {
      chapterStatus.status = Status.error;
      Helps.log(e);
    }
    final chapter = chapterStatus.chapter.copyWith(imagens: auxImage);
    _currentChapter = null;
    isDownloading = false;
    await saveChapter(chapter, chapterStatus.uniqueid);
    removeChapter(chapter, chapterStatus.uniqueid);
  }

  void pauseDownload() {
    //cancelToken.cancel();
  }

  Future<void> saveChapter(Chapter chapter, String uniqueid) async {
    final download = await _downloadRepository.get(uniqueid: uniqueid);
    download!.chapters.removeWhere(
      (element) => element.chapter.title == chapter.title,
    );
    download.chapters.add(ChapterStatus(chapter, Status.done, uniqueid));
    await _downloadRepository.update(
      data: download,
      uniqueid: uniqueid,
    );
  }

  Future<void> deleteChapter(Chapter chapter, String uniqueid) async {
    path = await _preference.get(
      keyPreferences: KeyPreferences.downloadFolder,
    );
    try {
      final dir = Directory(
        '$path/manga-easy/$uniqueid/${chapter.number}',
      );
      await dir.delete(recursive: true);
    } on Exception catch (e) {
      Helps.log(e);
    }
    final result = await _downloadRepository.get(
      uniqueid: uniqueid,
    );
    if (result != null) {
      //remove o capitulo dos downloads
      result.chapters.removeWhere(
        (element) => element.chapter.title == chapter.title,
      );
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
}
