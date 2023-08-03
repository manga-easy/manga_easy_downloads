import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:persistent_database/persistent_database.dart';

class DownloadController extends ChangeNotifier {
  final DownloadRepository repository;
  final ServiceDownload _service;
  final Preference _servicePrefs;

  DownloadController(
    this._service,
    this._servicePrefs,
    this.repository,
  );

  bool isPausedAll = false;
  bool isPaused = false;

  List<DownloadEntity> listMangaDownload = [];
  TextEditingController searchController = TextEditingController();

  List<DownloadEntity> get listTodo {
    if (searchController.text.isNotEmpty) {
      return listMangaDownload
          .where((e) =>
              e.status == Status.todo &&
              e.manga.title
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase().trim()))
          .toList();
    }
    return listMangaDownload.where((e) => e.status == Status.todo).toList();
  }

  List<DownloadEntity> get listDone {
    if (searchController.text.isNotEmpty) {
      return listMangaDownload
          .where((e) =>
              e.status == Status.done &&
              e.manga.title
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase().trim()))
          .toList();
    }
    return listMangaDownload.where((e) => e.status == Status.done).toList();
  }

  String get chaptersTodo {
    int chapters = 0;
    for (var todo in listTodo) {
      List<ChapterStatus> listChaptersTodo =
          todo.chapters.where((e) => e.status != Status.done).toList();
      chapters += listChaptersTodo.length;
    }
    if (chapters <= 1) {
      return '$chapters capítulo em transferência';
    }
    return '$chapters capítulos em transferência';
  }

  String get chaptersDone {
    int chapters = 0;
    for (var done in listTodo) {
      List<ChapterStatus> listChaptersDone =
          done.chapters.where((e) => e.status == Status.done).toList();
      chapters += listChaptersDone.length;
    }
    for (var done in listDone) {
      List<ChapterStatus> listChaptersDone =
          done.chapters.where((e) => e.status == Status.done).toList();
      chapters += listChaptersDone.length;
    }
    if (chapters <= 1) {
      return '$chapters capítulo baixado no total';
    }

    return '$chapters capítulos baixados no total';
  }

  void init() async {
    listDownload();
    isPausedAll = await readPauseAllPref();
    _service.addListener(listDownload);
    notifyListeners();
  }

  @override
  void dispose() {
    _service.removeListener(listDownload);
    super.dispose();
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

  void filterList(String filter) {
    notifyListeners();
  }

  void cleanFilter() {
    searchController.clear();
    notifyListeners();
  }

  Future<void> listDownload() async {
    listMangaDownload = await repository.list();

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

// int progress () {

// }

  void deleteAllDownload() async {
    await repository.deleteAll();
    await listDownload();
    for (var downloadTransfer in listMangaDownload) {
      final folder = Directory('${downloadTransfer.folder}/manga-easy');

      if (await folder.exists()) {
        folder.deleteSync(recursive: true);
      } else {
        print('A pasta não existe');
      }
    }
    notifyListeners();
  }
}
