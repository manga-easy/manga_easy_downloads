import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_chapter_download.dart';

class ListChapterDownload extends StatelessWidget {
  final String chapters;
  final String pages;
  final List<ChapterStatus> listChapter;
  final List<Widget> icons;

  const ListChapterDownload(
      {super.key,
      required this.icons,
      required this.chapters,
      required this.pages, required this.listChapter});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listChapter.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ContainerChapterDownload(
          chapters: chapters,
          pages: pages,
          icons: icons,
        );
      },
    );
  }
}