import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';

class DownloadController extends ChangeNotifier {
  final CreateUsecase createCase;
  final UpdateUsecase updateCase;
  final DeleteUsecase deleteCase;
  final DeleteAllUsecase deleteAllCase;
  final GetUsecase getCase;
  final ListUsecase listCase;
  final ServiceDownload service;

  DownloadController(
    this.createCase,
    this.updateCase,
    this.deleteCase,
    this.deleteAllCase,
    this.getCase,
    this.listCase,
    this.service,
  );

  void init() {
    listDownload();
    service.addListener(
      () => listDownload(),
    );
    notifyListeners();
  }

  List<DownloadEntity> listMangaDownload = [];
  void listDownload() async {
    listMangaDownload = await listCase.list();
    notifyListeners();
  }

  var folder = '/storage/emulated/0/Downloads';

  Future<String> pickDirectory() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      // O usuário selecionou uma pasta
      print('Pasta selecionada: $directoryPath');
      return folder = directoryPath;
      // ou fazer outras operações.
    }
    if (directoryPath == null) {
      // O usuário cancelou a seleção da pasta.
      print('Seleção de pasta cancelada.');
      return '';
    }

    return '/storage/emulated/0/Downloads';
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
        await service.downloadFile(todo);
      }
      listDownload();
      listTodo = listMangaDownload
          .where(
              (element) => element.chapters.any((e) => e.status == Status.todo))
          .toList();

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
    int fileNum = 0;
    int totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
    var totalMegaByte = (totalSize / (1024 * 1024)).floor();
    return '$totalMegaByte';
  }
}
