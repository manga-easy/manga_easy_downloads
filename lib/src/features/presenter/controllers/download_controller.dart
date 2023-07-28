import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
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

  void init() async {
    listDownload();
    isPausedAll = await readPauseAllPref();
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

  List<DownloadEntity> listTodo = [];
  List<DownloadEntity> listDone = [];
  List<DownloadEntity> listMangaDownloadTemp = [];

  void listDownload() async {
    listMangaDownloadTemp = await repository.list();
    print('listMangaDownloadTemp $listMangaDownloadTemp');
    print('Lista toda $listMangaDownloadTemp');
    listTodo =
        listMangaDownloadTemp.where((e) => e.status == Status.todo).toList();
    print('listTodo: $listTodo');
    listDone =
        listMangaDownloadTemp.where((e) => e.status == Status.done).toList();
    print('listDone: $listDone');
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

  void downloadFile() async {
    try {
      listDownload();

      print(listTodo.map((e) => e.chapters).map((e) => e.map((e) => e.status)));

      print('listTodo $listTodo');
      print('list done ${listDone.map((e) => e.manga.title).toList()}');
      var listBanco = await repository.list();
      print(
          'list do banco $listBanco, ${listBanco[0].chapters}, ${listBanco[1].chapters}');

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void downloadManga(DownloadEntity downloadEntity) {
    // Conferir se o manga ja tem algum existente criado pra adicionar na lista de chapter

    if (listMangaDownloadTemp
        .any((e) => e.uniqueid == downloadEntity.uniqueid)) {
      for (var chapter in downloadEntity.chapters) {
        // sera que vai ter um mesmo manga adicionado ? tipo no caso eu baixei 3 mangas e depois clico em baixar todos mangas

        listMangaDownloadTemp
            .firstWhere((e) => e.uniqueid == downloadEntity.uniqueid)
            .chapters
            .add(chapter);
        //botar em um update isso ai pra atualizar tambem no canco local
      }
      //     update
      // download.chapters.add
    } else {
      listMangaDownloadTemp.add(downloadEntity);
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

  void deleteAllDownload() async {
    await repository.deleteAll();
    for (var downloadTransfer in listTodo) {
      final folder = Directory(
          '${downloadTransfer.folder}/manga-easy/${downloadTransfer.uniqueid}');

      if (await folder.exists()) {
        folder.deleteSync(recursive: true);
      } else {
        print('A pasta não existe');
      }
    }

    for (var download in listDone) {
      final folder =
          Directory('${download.folder}/manga-easy/${download.uniqueid}');
      await repository.delete(uniqueid: download.uniqueid);
      if (await folder.exists()) {
        folder.deleteSync(recursive: true);
        print('Pasta excluída com sucesso');
      } else {
        print('A pasta não existe');
      }
    }

    listDownload();
    notifyListeners();
  }
}
