import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';
import 'package:persistent_database/persistent_database.dart';

class DownloadController extends ChangeNotifier {
  final CreateUsecase createCase;
  final UpdateUsecase updateCase;
  final DeleteUsecase deleteCase;
  final DeleteAllUsecase deleteAllCase;
  final GetUsecase getCase;
  final ListUsecase listCase;
  final ServiceDownload _service;
  final Preference _servicePrefs;

  DownloadController(
    this.createCase,
    this.updateCase,
    this.deleteCase,
    this.deleteAllCase,
    this.getCase,
    this.listCase,
    this._service,
    this._servicePrefs,
  );

  bool isPause = false;

  void init() async {
    listDownload();
    isPause = await readPausePref();
    _service.addListener(
      () => listDownload(),
    );
    notifyListeners();
  }

  void savePausePref() async {
    isPause = !isPause;
    await _servicePrefs.put(
      keyPreferences: KeyPreferences.downloadPauseAll,
      value: isPause,
    );
  }

  Future<bool> readPausePref() async {
    return await _servicePrefs.get<bool>(
        keyPreferences: KeyPreferences.downloadPauseAll);
  }

  List<DownloadEntity> listMangaDownload = [];
  void listDownload() async {
    listMangaDownload = await listCase.list();
    notifyListeners();
  }

  Future<void> pickDirectory() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      // O usuário selecionou uma pasta
      print('Pasta selecionada: $directoryPath');
      Preference(GetIt.instance()).put(
        keyPreferences: KeyPreferences.downloadFolder,
        value: directoryPath,
      );
    }
    return;
  }

  List<DownloadEntity> listTodo = [];
  List<DownloadEntity> listDone = [];

  void downloadFile() async {
    try {
      listTodo = listMangaDownload
          .where(
              (element) => element.chapters.any((e) => e.status == Status.todo))
          .toList();

      for (var todo in listTodo) {
        await _service.downloadFile(todo);
      }
      listDownload();
      listTodo = listMangaDownload
          .where(
              (element) => element.chapters.any((e) => e.status == Status.todo))
          .toList();
      print(listMangaDownload
          .map((e) => e.chapters)
          .map((e) => e.map((e) => e.status)));

      print(listTodo);
      listDone = listMangaDownload
          .where(
              (element) => element.chapters.any((e) => e.status == Status.done))
          .toList();
      print(listDone);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  String calculateFolderSize(String dirPath) {
    var dir = Directory(dirPath);
    int totalSize = 0;
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      return 'N/A';
    }
    var totalKbytes = (totalSize / 1024).floor();
    var totalMegaByte = (totalSize / (1024 * 1024)).floor();

    return totalKbytes > 1000 ? '$totalMegaByte MB' : '$totalKbytes kB';
  }

  void progress(receivedBytes, totalBytes) {
    if (totalBytes != -1) {
      final progress = (receivedBytes / totalBytes * 100).toStringAsFixed(0);
      // print('Progresso do download: $progress%');
    }
  }
}
