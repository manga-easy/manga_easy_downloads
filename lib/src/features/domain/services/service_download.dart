import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hosts/hosts.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:persistent_database/persistent_database.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

class ServiceDownload extends ChangeNotifier {
  final Preference _preference;

  ServiceDownload(
    this._preference,
  );

  final _downloadQueue = <ChapterStatusEntity>[];
  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? path;

  ChapterStatusEntity? _currentChapter;

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
    _downloadQueue.add(ChapterStatusEntity(chapter, Status.doing, uniqueid));
    _downloadNext();
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

    final chapter = _downloadQueue.first;
    _downloadChapter(chapter).then((_) {
      isDownloading = false;
      _downloadNext();
    });
    isDownloading = true;
    notifyListeners();
  }

  CancelToken cancelToken = CancelToken();

  double getDownloadProgress(int totalImages, int completedImages) {
    return totalImages > 0 ? completedImages / totalImages : 0.0;
  }

  void progress(int totalImages, int completedImages) {
    downloadProgress = getDownloadProgress(totalImages, completedImages);
    Helps.log('Progress idication $downloadProgress');
    notifyListeners();
  }

  Future<void> _downloadChapter(ChapterStatusEntity chapter) async {
    try {
      _currentChapter = chapter;
      path ??= await FilePicker.platform.getDirectoryPath();

      var directory = Directory(
        '$path/manga-easy/${chapter.uniqueid}/${chapter.chapter.number}',
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
      final images = await host.getConteudoChapter(manga: chapter.chapter.href);
      var totalDone = 0;
      for (var image in images) {
        try {
          progress(images.length, totalDone);
          totalDone += 1;
          final file = File('${directory.path}/${image.src.split('/').last}');
          if (file.existsSync()) {
            continue;
          }

          final response = await Dio().get(
            image.src,
            options: Options(
              headers: Global.header,
              responseType: ResponseType.bytes,
            ),
            cancelToken: cancelToken,
          );

          final fileBytes = response.data;
          var compressImage = await FlutterImageCompress.compressWithList(
            fileBytes,
            quality: 20,
          );
          //quando quebrar o bovinão arruma
          await file.writeAsBytes(compressImage, mode: FileMode.write);
        } catch (e) {
          print('Deu erro no download: $e');
        }
      }
      notifyListeners();
      chapter.status = Status.done;
      _currentChapter = null;
      _downloadQueue.remove(chapter);
    } catch (e) {
      chapter.status = Status.error;
      _downloadQueue.remove(chapter);
      isDownloading = false;
      Helps.log(e);
    }
  }

  void pauseDownload() {
    cancelToken.cancel();
  }
}
