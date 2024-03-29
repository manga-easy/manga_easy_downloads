import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hosts/hosts.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:persistent_database/persistent_database.dart';

class DownloadController extends ChangeNotifier {
  final DownloadRepository repository;
  final ServiceDownload _service;
  final Preference _servicePrefs;
  final GetHostCase _getHostCase;

  DownloadController(
    this._service,
    this._servicePrefs,
    this.repository,
    this._getHostCase,
  );

  bool isPausedAll = false;
  int chaptersContDone = 0;
  List<DownloadEntity> listMangaDownload = [];
  TextEditingController searchController = TextEditingController();

  List<DownloadEntity> get listTodo {
    if (searchController.text.isNotEmpty) {
      return listMangaDownload
          .where(
            (e) =>
                e.status == Status.todo &&
                e.manga.title.toLowerCase().contains(
                      searchController.text.toLowerCase().trim(),
                    ),
          )
          .toList();
    }
    return listMangaDownload.where((e) => e.status == Status.todo).toList();
  }

  List<DownloadEntity> get listDone {
    if (searchController.text.isNotEmpty) {
      return listMangaDownload
          .where(
            (e) =>
                e.status == Status.done &&
                e.manga.title
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase().trim()),
          )
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

  Future<void> init() async {
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

  String chaptersDoneInManga(DownloadEntity downloadEntity) {
    int chapters = downloadEntity.chapters
        .where((e) => e.status == Status.done)
        .toList()
        .length;

    if (chapters > 1) {
      return '$chapters capítulos baixados no total';
    }
    if (chapters == 1) {
      return '$chapters capítulo baixado no total';
    }
    return '';
  }

  String chaptersTodoInManga(DownloadEntity downloadEntity) {
    int chapters = downloadEntity.chapters
        .where((e) => e.status != Status.done)
        .toList()
        .length;

    if (chapters > 1) {
      return '$chapters capítulos em transferência';
    }
    if (chapters == 1) {
      return '$chapters capítulo em transferência';
    }
    return '';
  }

  Future<void> savePauseAllPref() async {
    isPausedAll = !isPausedAll;
    print(isPausedAll);
    if (isPausedAll) {
      for (DownloadEntity manga in listTodo) {
        await _service.pauseMangaDownload(manga.uniqueid);
        print('Continuar manga');
      }
    } else {
      for (DownloadEntity manga in listTodo) {
        print('Pausar manga');
        await _service.continueMangaDownload(manga);
      }
    }
    await _servicePrefs.put(
      keyPreferences: KeyPreferences.downloadPauseAll,
      value: isPausedAll,
    );
  }

  Future<bool> readPauseAllPref() async {
    return await _servicePrefs.get<bool>(
      keyPreferences: KeyPreferences.downloadPauseAll,
    );
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

  String calculateFolderSize(List<ChapterStatus> chapters) {
    int totalSize = 0;
    try {
      for (var chapter in chapters) {
        if (chapter.status == Status.done || chapter.status == Status.done) {
          var dir = Directory(chapter.path!);
          if (dir.existsSync()) {
            dir
                .listSync(recursive: true, followLinks: false)
                .forEach((FileSystemEntity entity) {
              if (entity is File) {
                totalSize += entity.lengthSync();
              }
            });
          }
        }
      }
    } catch (e) {
      return 'N/A';
    }
    var totalKbytes = (totalSize / 1024).floor();
    var totalMegaByte = (totalSize / (1024 * 1024)).floor();
    var totalGigaByte = (totalSize / (1024 * 1024 * 1024)).toStringAsFixed(1);

    if (totalKbytes < 1000) {
      return '$totalKbytes kB';
    }
    if (totalKbytes > 1000 && totalMegaByte < 1000) {
      return '$totalMegaByte MB';
    }
    return '$totalGigaByte GB';
  }

  double get progressDownload => _service.downloadProgress;

  double progress(DownloadEntity downloadEntity) {
    chaptersContDone = downloadEntity.chapters
        .where((e) => e.status == Status.done)
        .toList()
        .length;
    double valueProgress = chaptersContDone / downloadEntity.chapters.length;
    return valueProgress;
  }

  Future<void> deleteAllDownload() async {
    for (var downloadMangas in listMangaDownload) {
      for (var chapter in downloadMangas.chapters) {
        await _service.deleteChapter(chapter.chapter, chapter.uniqueid);
      }
    }
    notifyListeners();
  }

  Future<String> getNameHost(DownloadEntity downloadEntity) async {
    final result = await _getHostCase.call(downloadEntity.manga.idHost);
    return result.name;
  }
}
