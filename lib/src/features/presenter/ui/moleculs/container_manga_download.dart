import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
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
  const ContainerMangaDownload(
      {super.key,
      required this.ct,
      required this.imageManga,
      required this.name,
      required this.chaptersDownload,
      required this.host,
      required this.megaByte,
      required this.chapters,
      required this.pages,
      this.isDownload = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChapterDownloadPage(
              ct: ct,
              name: name,
              chapters: chapters,
              pages: pages,
            ),
          ),
        ),
        child: CoffeeContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoffeeMangaCover(
                cover: imageManga,
                height: 200,
                width: 125,
                filtraImg: true,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CoffeeText(
                          text: name,
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
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CoffeeText(
                                text: 'Em transferência',
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: LinearProgressIndicator(
                                    color: ThemeService.of.primaryColor,
                                    backgroundColor:
                                        ThemeService.of.selectColor,
                                    minHeight: 6,
                                    value: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 5),
                          true
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
