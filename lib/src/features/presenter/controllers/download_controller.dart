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
  List<DownloadEntity> listTodo = [];
  List<DownloadEntity> listDone = [];
  List<DownloadEntity> listMangaDownloadTemp = [];
  List<DownloadEntity> listFilterDownload = [];
  List<DownloadEntity> listFilterTodo = [];
  TextEditingController searchController = TextEditingController();

  void init() async {
    listDownload();
    isPausedAll = await readPauseAllPref();
    listFilterDownload = List.from(listDone);
    listFilterTodo = List.from(listTodo);
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
    if (filter.isNotEmpty) {
      listFilterDownload = listDone
          .where((item) =>
              item.manga.title.toLowerCase().contains(filter.toLowerCase()))
          .toList();
      listFilterTodo = listTodo
          .where((item) =>
              item.manga.title.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      listFilterDownload = List.from(listDone);
      listFilterTodo = List.from(listTodo);
    }
    print('aaaaaaaaaaaaaaaaaaa');
    notifyListeners();
  }

  void cleanFilter() {
    listFilterDownload = List.from(listDone);
    listFilterTodo = List.from(listTodo);
    searchController.clear();
    notifyListeners();
  }

  void listDownload() async {
    print('BBBBBBBBBBBBBBBBBBBBB');
    listMangaDownloadTemp = await repository.list();

    listTodo =
        listMangaDownloadTemp.where((e) => e.status == Status.todo).toList();

    listDone =
        listMangaDownloadTemp.where((e) => e.status == Status.done).toList();

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

  double downloadProgress = 0.0;

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

  void deleteAllDownload() async {
    await repository.deleteAll();
    listDownload();
    for (var downloadTransfer in listMangaDownloadTemp) {
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
