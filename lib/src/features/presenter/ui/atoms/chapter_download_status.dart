import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/chapter_download_controller.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ChapterDownloadStatus extends StatelessWidget {
  final ChapterDownloadController ct;
  final Chapter chapter;
  final String uniqueid;

  const ChapterDownloadStatus({
    super.key,
    required this.ct,
    required this.chapter,
    required this.uniqueid,
  });

  @override
  Widget build(BuildContext context) {
    if (ct.currentChapterDownload(chapter)) {
      return CircularProgressIndicator(
        value: ct.progressDownload,
      );
    }
    if (ct.isChapterInQueue(chapter)) {
      return CoffeeIconButton(
        onTap: () {
          ct.deleteOneChapter(
            chapter: chapter,
            uniqueId: uniqueid,
          );
          ct.removeChapterQueue(chapter);
        },
        icon: Icons.stop_circle_outlined,
      );
    }
    return Icon(Icons.error);
    //TODO AJEITAR ISSO AI PRA ERRO
  }
}
