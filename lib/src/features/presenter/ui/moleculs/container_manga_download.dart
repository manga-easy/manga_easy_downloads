import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/pages/chapters_download_page.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class ContainerMangaDownload extends StatelessWidget {
  // final String imageManga;
  // final String name;
  // final String chaptersDownload;
  // final String host;
  // final String megaByte;
  const ContainerMangaDownload({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChapterDownloadPage(),
          ),
        ),
        child: CoffeeContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CoffeeMangaCover(
                cover:
                    'https://th.bing.com/th/id/OIP.TrL-voc2lnUUIXOGf3l2MAHaLc?pid=ImgDet&rs=1',
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
                        const CoffeeText(
                          text:
                              'One piece',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          typography: CoffeeTypography.title,
                        ),
                        const CoffeeText(text: '2 capítulos baixados'),
                        CoffeeText(
                          text: 'Mangá Host',
                          color:
                              ThemeService.of.backgroundText.withOpacity(0.5),
                        ),
                        CoffeeText(
                          text: '23 MB',
                          color:
                              ThemeService.of.backgroundText.withOpacity(0.5),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CoffeeText(
                              text: 'Em transferência',
                            ),
                           const  SizedBox(height: 5),
                            SizedBox(
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  color: ThemeService.of.primaryColor,
                                  backgroundColor: ThemeService.of.selectColor,
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
