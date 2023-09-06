import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/chapter_download_controller.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

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
    return CoffeeIconButton(
      icon: Icons.error,
      onTap: () => CoffeeSheetBottom(
        button: CoffeeButton(label: 'voltar'),
        title: CoffeeText(
          text: 'Gerenciar download',
          typography: CoffeeTypography.title,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoffeeButtonText(
              text: 'Tentar novamente',
              color: ThemeService.of.primaryColor,
              prefix: Icons.refresh,
              onPressed: () {
                ct.downloadChapter(chapter, uniqueid);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 5),
            CoffeeButtonText(
              text: 'Excluir capítulo',
              color: ThemeService.of.primaryColor,
              prefix: Icons.delete,
              onPressed: () {
                ct.deleteOneChapter(chapter: chapter, uniqueId: uniqueid);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
