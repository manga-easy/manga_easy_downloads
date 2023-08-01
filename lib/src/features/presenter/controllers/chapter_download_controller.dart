import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ChapterDownloadController extends ChangeNotifier {
  final DownloadRepository repository;

  ChapterDownloadController(this.repository);

  DownloadEntity? mangaDownload;

  List<ChapterStatus> listMangaDownload = [];
  List<ChapterStatus> listFilterDownload = [];
  List<ChapterStatus> listMangaTodo = [];
  List<ChapterStatus> listFilterTodo = [];

  TextEditingController searchChapterController = TextEditingController();

  init(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    mangaDownload = arguments as DownloadEntity;
    listMangaDownload = mangaDownload!.chapters
        .where((element) => element.status == Status.done)
        .toList()
      ..sort((a, b) =>
          int.parse(a.chapter.title).compareTo(int.parse(b.chapter.title)));
    listMangaTodo = mangaDownload!.chapters
        .where((element) => element.status == Status.todo)
        .toList();
    listFilterDownload = List.from(listMangaDownload);
    listFilterTodo = List.from(listMangaTodo);
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

  void filterList(String filter) {
    var newFilter = filter;
    if (filter.length >= 2 && filter[0] == '0') {
      newFilter = filter.substring(1);
    }
    if (newFilter.isNotEmpty) {
      listFilterDownload = listMangaDownload
          .where((item) => item.chapter.title.contains(newFilter))
          .toList();
      listFilterTodo = listMangaDownload
          .where((item) => item.chapter.title.contains(newFilter))
          .toList();
    } else {
      listFilterDownload = List.from(listMangaDownload);
      listFilterTodo = List.from(listMangaTodo);
    }
    notifyListeners();
  }
}
