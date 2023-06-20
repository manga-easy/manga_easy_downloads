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

  var listTodo = [];

  void downloadFile() async {
    try {
      listTodo =
          listMangaDownload.where((e) => e.status == Status.todo).toList();
      for (var todo in listTodo) {
        await service.downloadFile(todo);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> calculateFolderSize(String folderPath) async {
    try {
      final folder = Directory(folderPath);
      int totalSize = 0;

      if (await folder.exists()) {
        await for (var entity in folder.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
      notifyListeners();
      return '$totalSize';
    } catch (e) {
     return 'N/A';
    }
  }
}
