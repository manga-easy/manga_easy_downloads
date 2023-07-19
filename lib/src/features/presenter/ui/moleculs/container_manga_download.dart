import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/pages/chapters_download_page.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class ContainerMangaDownload extends StatelessWidget {
  final String megaByte;
  final String pages;
  final double downloadProgress;
  final DownloadController ct;
  final bool isDownload;
  final bool isPaused;
  final List<ChapterStatus> listChapterTodo;
  final List<ChapterStatus> listChapterDone;
  final DownloadEntity mangaDownload;
  const ContainerMangaDownload({
    super.key,
    required this.ct,
    required this.megaByte,
    required this.pages,
    required this.isPaused,
    required this.listChapterTodo,
    required this.listChapterDone,
    this.isDownload = false,
    this.downloadProgress = 0.0,
    required this.mangaDownload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterDownloadPage(
            ct: ct,
            pages: pages,
            listChapterTodo: listChapterTodo,
            mangaDownload: mangaDownload,
            listChapterDone: listChapterDone,
          ),
        ),
      ),
      child: CoffeeContainer(
        child: SizedBox(
          height: 200,
          child: Row(
            children: [
              CoffeeMangaCover(
                cover: mangaDownload.manga.capa,
                width: 125,
                filtraImg: true,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CoffeeText(
                          text: mangaDownload.manga.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          typography: CoffeeTypography.title,
                        ),
                        '${mangaDownload.chapters.length}' == '1'
                            ? CoffeeText(
                                text:
                                    '${mangaDownload.chapters.length} capítulo baixado')
                            : CoffeeText(
                                text:
                                    '${mangaDownload.chapters.length} capítulos baixados'),
                        CoffeeText(
                          
                          text: 'Host a modificar no container manga',
                          color:
                              ThemeService.of.backgroundText.withOpacity(0.5),
                        ),
                        CoffeeText(
                          text: megaByte,
                          color:
                              ThemeService.of.backgroundText.withOpacity(0.5),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isDownload,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CoffeeText(
                                  text: 'Em transferência',
                                ),
                                const SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: LinearProgressIndicator(
                                    color: ThemeService.of.primaryColor,
                                    backgroundColor:
                                        ThemeService.of.selectColor,
                                    minHeight: 6,
                                    value: downloadProgress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isPaused
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.pause_circle_filled,
                                    size: 30,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {},
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.play_circle,
                                    size: 30,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {},
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
