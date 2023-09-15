import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_manga_download.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ListMangas extends StatelessWidget {
  final String title;
  final List<DownloadEntity> listManga;
  final DownloadController ct;
  final bool isDownload;
  const ListMangas({
    super.key,
    required this.title,
    required this.listManga,
    required this.ct,
    this.isDownload = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        CoffeeText(
          text: title,
          typography: CoffeeTypography.title,
        ),
        const SizedBox(height: 10),
        ListView.builder(
          itemCount: listManga.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            var mangaDownload = listManga[idx];
            return ContainerMangaDownload(
              mangaDownload: mangaDownload,
              isDownload: isDownload,
              ct: ct,
            );
          },
        ),
      ],
    );
  }
}
