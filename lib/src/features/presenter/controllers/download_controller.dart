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

  bool isPausedAll = false;
  bool isPaused = false;

  void init() async {
    listDownload();
    isPausedAll = await readPauseAllPref();
    _service.downloadProgress.addListener(
      () {
        // listDownload();
        downloadProgress = _service.downloadProgress.value;
        print('Progress: $downloadProgress');
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void savePauseAllPref() async {
    isPausedAll = !isPausedAll;
    await _servicePrefs.put(
      keyPreferences: KeyPreferences.downloadPauseAll,
      value: isPausedAll,
    );
  }

  Future<bool> readPauseAllPref() async {
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
  double downloadProgress = 0.0;
  void downloadFile() async {
    try {
      print(listTodo);
      listTodo = listMangaDownload
          .where(
              (element) => element.chapters.any((e) => e.status == Status.todo))
          .toList();
      print(listTodo);
      if (listTodo.isNotEmpty) {
        for (var todo in listTodo) {
          await _service.downloadFile(todo);
          // Atualiza listTodo após o download de cada elemento
          listTodo = listMangaDownload
              .where((element) =>
                  element.chapters.any((e) => e.status == Status.todo))
              .toList();
          // Atualiza listDone após o download de cada elemento
          listDone = listMangaDownload
              .where((element) => element.chapters
                  .any((element) => element.status == Status.done))
              .toList();
          notifyListeners();
        }
      }
      listDownload();

      print(listTodo.map((e) => e.chapters).map((e) => e.map((e) => e.status)));
      listDone = listMangaDownload
          .where((element) =>
              element.chapters.any((element) => element.status == Status.done))
          .toList();

      print('listTodo $listTodo');
      print('list done ${listDone.map((e) => e.manga.title).toList()}');

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
