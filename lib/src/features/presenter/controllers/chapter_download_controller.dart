import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';

class ChapterDownloadController extends ChangeNotifier {
  final DownloadRepository repository;

  ChapterDownloadController(this.repository);

  DownloadEntity? mangaDownload;

  init(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    mangaDownload = arguments as DownloadEntity;
    notifyListeners();
  }

  void deleteAllChapter({required DownloadEntity downloadEntity}) async {
    await repository.delete(uniqueid: downloadEntity.uniqueid);
    final file = Directory(
        '${downloadEntity.folder}/manga-easy/${downloadEntity.uniqueid}');
    if (await file.exists()) {
      file.deleteSync(recursive: true);
      print('Pasta excluída com sucesso');
    } else {
      print('A pasta não existe');
    }
    //TODO listDownload();
    notifyListeners();
  }

  void deleteOneChapter() async {}
}
