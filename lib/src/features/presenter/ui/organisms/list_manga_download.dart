import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_manga_download.dart';

class ListMangaDownload extends StatelessWidget {
  final String title;
  final DownloadController ct;
  const ListMangaDownload({super.key, required this.title, required this.ct});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          CoffeeText(
            text: title,
            typography: CoffeeTypography.title,
          ),
          ListView.builder(
            itemCount: ct.listDone.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, idx) {
              var mangaDownload = ct.listDone[idx];
              var chapterStatusDone = mangaDownload.chapters
                  .where((element) => element.status == Status.done)
                  .toList();
              var chapterStatusTodo = mangaDownload.chapters
                  .where((element) => element.status == Status.todo)
                  .toList();
              return ContainerMangaDownload(
                listChapterDone: chapterStatusDone,
                listChapterTodo: chapterStatusTodo,
                ct: ct,
                isPaused: ct.isPaused,
                name: mangaDownload.manga.title,
                host: 'Manga easy Originals',
                chaptersDownload: '${mangaDownload.chapters.length}',
                imageManga: mangaDownload.manga.capa,
                megaByte: ct.calculateFolderSize(
                    '${mangaDownload.folder}/${mangaDownload.uniqueid}'),
                pages: '${mangaDownload.chapters[idx].chapter.imagens.length}',
              );
            },
          )
        ],
      ),
    );
  }
}
