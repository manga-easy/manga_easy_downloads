import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_manga_download.dart';

class ListMangaDownload extends StatelessWidget {
  final DownloadController ct;
  const ListMangaDownload({super.key, required this.ct});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const CoffeeText(
            text: 'Baixados',
            typography: CoffeeTypography.title,
          ),
          const SizedBox(height: 10),
          ListView.builder(
            itemCount: ct.listDone.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, idx) {
              var mangaDownload = ct.listDone[idx];
              return ContainerMangaDownload(
                mangaDownload: mangaDownload,
                ct: ct,
                isPaused: ct.isPaused,
              );
            },
          ),
        ],
      ),
    );
  }
}
