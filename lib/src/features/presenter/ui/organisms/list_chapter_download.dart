import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_chapter_download.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ListChapterDownload extends StatelessWidget {
  final List<ChapterStatus> listChapter;
  final List<Widget> icons;
  const ListChapterDownload(
      {super.key, required this.icons, required this.listChapter});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listChapter.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, idx) {
        return ContainerChapterDownload(
          chapters: listChapter[idx].chapter.title,
          pages: '${listChapter[idx].chapter.imagens.length}',
          icons: icons,
        );
      },
    );
  }
}
