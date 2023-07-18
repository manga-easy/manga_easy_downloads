import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/atoms/custom_app_bar.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_manga_download.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/organisms/list_manga_download.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';
import 'package:reorderables/reorderables.dart';

class DownloadPage extends StatefulWidget {
  static const route = '/downloads';
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  DownloadController ct = GetIt.I();

  @override
  void initState() {
    ct.init();
    ct.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: CustomAppBar(
          title: 'Downloads',
          ct: ct,
          onClean: () {
            setState(() {
              ct.deleteAllDownload();
            });
          },
        ),
      ),
      bottomNavigationBar: FloatingActionButton(
        onPressed: () {
          setState(() {
            ct.create();
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeService.of.backgroundIcon,
        onPressed: () {
          setState(() {
            ct.savePauseAllPref();
          });
          ct.downloadFile();
        },
        child: ct.isPausedAll
            ? const Icon(
                Icons.play_arrow,
                size: 30,
              )
            : const Icon(
                Icons.pause,
                size: 30,
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ct.listTodo.length > 1
                          ? CoffeeText(
                              text:
                                  '${ct.listDone.length} capítulos em transferência')
                          : CoffeeText(
                              text:
                                  '${ct.listTodo.length} capítulo em transferência'),
                      ct.listDone.length > 1
                          ? CoffeeText(
                              text:
                                  '${ct.listDone.length} capítulos baixados no total')
                          : CoffeeText(
                              text:
                                  '${ct.listDone.length} capítulo baixado no total'),
                    ],
                  ),
                ],
              ),
            ),
            SliverVisibility(
              visible: ct.listTodo.isNotEmpty,
              sliver: const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: CoffeeText(
                    text: 'Em Transferência',
                    typography: CoffeeTypography.title,
                  ),
                ),
              ),
            ),
            SliverVisibility(
              visible: ct.listTodo.isNotEmpty,
              sliver: ReorderableSliverList(
                delegate: ReorderableSliverChildBuilderDelegate(
                  childCount: ct.listTodo.length,
                  (context, idx) {
                    var mangaDownload = ct.listTodo[idx];
                    var chapterStatusDone = mangaDownload.chapters
                        .where((element) => element.status == Status.done)
                        .toList();
                    var chapterStatusTodo = mangaDownload.chapters
                        .where((element) => element.status == Status.todo)
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ContainerMangaDownload(
                        listChapterDone: chapterStatusDone,
                        listChapterTodo: chapterStatusTodo,
                        isDownload: true,
                        downloadProgress: ct.downloadProgress,
                        ct: ct,
                        name: mangaDownload.manga.title,
                        host: 'Manga easy Originals',
                        isPaused: ct.isPaused,
                        chaptersDownload: '${mangaDownload.chapters.length}',
                        imageManga: mangaDownload.manga.capa,
                        megaByte: ct.calculateFolderSize(
                            '${mangaDownload.folder}/Manga Easy/${mangaDownload.uniqueid}'),
                        pages:
                            '${mangaDownload.chapters[idx].chapter.imagens.length}',
                        folder: mangaDownload.folder,
                        uniqueid: mangaDownload.uniqueid,
                      ),
                    );
                  },
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = ct.listTodo.removeAt(oldIndex);
                    ct.listTodo.insert(newIndex, item);
                  });
                },
              ),
            ),
            ListMangaDownload(title: 'Baixados', ct: ct),
          ],
        ),
      ),
    );
  }
}
