import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/pages/chapters_download_page.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class ContainerMangaDownload extends StatelessWidget {
  final String imageManga;
  final String name;
  final String chaptersDownload;
  final String host;
  final String megaByte;
  final String chapters;
  final String pages;
  final DownloadController ct;
  final bool isDownload;
  final bool isPaused;
  final List<ChapterStatus> listChapterTodo;
  final List<ChapterStatus> listChapterDone;
  const ContainerMangaDownload({
    super.key,
    required this.ct,
    required this.imageManga,
    required this.name,
    required this.chaptersDownload,
    required this.host,
    required this.megaByte,
    required this.chapters,
    required this.pages,
    this.isDownload = false,
    this.isPaused = false,
    required this.listChapterTodo,
    required this.listChapterDone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterDownloadPage(
            ct: ct,
            name: name,
            chapters: chapters,
            pages: pages,
            listChapterDone: listChapterDone,
            listChapterTodo: listChapterTodo,
          ),
        ),
      ),
      child: CoffeeContainer(
        child: SizedBox(
          height: 200,
          child: Row(
            children: [
              CoffeeMangaCover(
                cover: imageManga,
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
                          text: '$name teste texto longo quebra linha',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          typography: CoffeeTypography.title,
                        ),
                        chaptersDownload == '1'
                            ? CoffeeText(
                                text: '$chaptersDownload capítulo baixado')
                            : CoffeeText(
                                text: '$chaptersDownload capítulos baixados'),
                        CoffeeText(
                          text: host,
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
                                    value: 0.5,
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
