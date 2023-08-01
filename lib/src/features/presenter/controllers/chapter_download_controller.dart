import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ChapterDownloadController extends ChangeNotifier {
  final DownloadRepository repository;

  ChapterDownloadController(this.repository);

  DownloadEntity? mangaDownload;

  init(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    mangaDownload = arguments as DownloadEntity;
    notifyListeners();
  }

  void deleteAllChapter(
      {required String uniqueid, required String folder}) async {
    await repository.delete(uniqueid: uniqueid);
    final file = Directory('$folder/manga-easy/$uniqueid}');
    if (await file.exists()) {
      file.deleteSync(recursive: true);
      print('Pasta excluída com sucesso');
    } else {
      print('A pasta não existe');
    }
    //TODO listDownload();
    notifyListeners();
  }

  void deleteOneChapter(
      {required DownloadEntity mangaDownload,
      required ChapterStatus removeChapter}) async {
    if (mangaDownload.chapters.length == 1) {
      deleteAllChapter(
          uniqueid: mangaDownload.uniqueid, folder: mangaDownload.folder);
    } else {
      mangaDownload.chapters.removeWhere((e) => e == removeChapter);
      repository.update(data: mangaDownload, uniqueid: mangaDownload.uniqueid);
    }
    final file = Directory(
        '${mangaDownload.folder}/manga-easy/${mangaDownload.uniqueid}/${removeChapter.chapter.number}');
    if (await file.exists()) {
      file.deleteSync(recursive: true);
      print('Pasta excluída com sucesso');
    } else {
      print('A pasta não existe');
    }
    //TODO listDownload();
    notifyListeners();
  }
}
