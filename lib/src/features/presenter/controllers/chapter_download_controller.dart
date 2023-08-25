import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/manga_easy_downloads.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ChapterDownloadController extends ChangeNotifier {
  final DownloadRepository repository;
  final ServiceDownload _serviceDownload;

  ChapterDownloadController(this.repository, this._serviceDownload);

  DownloadEntity? mangaDownload;

  TextEditingController searchChapterController = TextEditingController();

  List<ChapterStatus> get listChaptersTodo {
    if (searchChapterController.text.isNotEmpty) {
      return mangaDownload!.chapters
          .where(
            (e) =>
                e.status != Status.done &&
                e.chapter.title.contains(
                  searchChapterController.text.trim(),
                ),
          )
          .toList();
    }

    return mangaDownload!.chapters
        .where((e) => e.status != Status.done)
        .toList();
  }

  List<ChapterStatus> get listChaptersDone {
    if (searchChapterController.text.isNotEmpty) {
      return mangaDownload!.chapters
          .where(
            (e) =>
                e.status == Status.done &&
                e.chapter.title.contains(
                  searchChapterController.text.trim().length >= 2 &&
                          searchChapterController.text.trim()[0] == '0'
                      ? searchChapterController.text.substring(1).trim()
                      : searchChapterController.text.trim(),
                ),
          )
          .toList()
        ..sort(
          (a, b) => int.parse(a.chapter.title).compareTo(
            int.parse(b.chapter.title),
          ),
        );
    }

    return mangaDownload!.chapters
        .where((e) => e.status == Status.done)
        .toList();
  }

  void init(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    mangaDownload = arguments as DownloadEntity;
    _serviceDownload.addListener(list);
    notifyListeners();
  }

  @override
  void dispose() {
    _serviceDownload.removeListener(list);
    super.dispose();
  }

  Future<void> list() async {
    mangaDownload = await repository.get(uniqueid: mangaDownload!.uniqueid);
    notifyListeners();
  }

  void filterList(String filter) {
    notifyListeners();
  }

  void cleanFilter() {
    searchChapterController.clear();
    notifyListeners();
  }

  Future<void> deleteAllChapter({
    required List<ChapterStatus> chapters,
  }) async {
    for (var chapter in chapters) {
       _serviceDownload.deleteChapter(
        chapter.chapter,
        chapter.uniqueid,
      );
    }
    notifyListeners();
  }

  Future<void> deleteOneChapter({
    required Chapter chapter,
    required String uniqueId,
  }) async {
    await _serviceDownload.deleteChapter(
      chapter,
      uniqueId,
    );

    notifyListeners();
  }

  void removeChapterQueue(Chapter chapter) {
    _serviceDownload.removeChapter(chapter, mangaDownload!.uniqueid);
  }

  double get progressDownload => _serviceDownload.downloadProgress;

  bool currentChapterDownload(Chapter chapter) =>
      _serviceDownload.isCurrentChapter(chapter, mangaDownload!.uniqueid);

  bool isChapterInQueue(Chapter chapter) =>
      _serviceDownload.isChapterInQueue(chapter, mangaDownload!.uniqueid);
}
