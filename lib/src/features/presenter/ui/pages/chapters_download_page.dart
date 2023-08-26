import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/chapter_download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/atoms/chapter_download_status.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/atoms/custom_app_bar.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_chapter_download.dart';

class ChapterDownloadPage extends StatefulWidget {
  static const route = '/chapters-download';

  const ChapterDownloadPage({
    super.key,
  });

  @override
  State<ChapterDownloadPage> createState() => _ChapterDownloadPageState();
}

class _ChapterDownloadPageState extends State<ChapterDownloadPage> {
  ChapterDownloadController ct = GetIt.I();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    ct.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    ct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ct.mangaDownload == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: CustomAppBar(
          title: ct.mangaDownload!.manga.title,
          textController: ct.searchChapterController,
          cleanSearch: () => ct.cleanFilter(),
          keyboardType: TextInputType.number,
          onChanged: ct.filterList,
          listPopMenu: [
            PopupMenuItem(
              onTap: () {
                setState(() {
                  ct.deleteAllChapter(
                    chapters: ct.mangaDownload!.chapters,
                  );
                });
              },
              child: const CoffeeText(text: 'Limpar todos os downloads'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Material(
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.only(bottom: 10, left: 16, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CoffeeButton(
                  label: 'Baixar mais capítulos',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/manga',
                      arguments: {'manga': ct.mangaDownload!.manga},
                    );
                  },
                ),
              ),
              // true
              //     ? CoffeeIconButton(
              //         onTap: () {},
              //         icon: Icons.pause_circle,
              //         size: 50,
              //       )
              //     : SizedBox.shrink()
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverVisibility(
              visible: ct.listChaptersTodo.isNotEmpty,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CoffeeText(
                      text: 'Em transferência',
                      typography: CoffeeTypography.title,
                    ),
                    ListView.builder(
                      itemCount: ct.listChaptersTodo.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, idx) {
                        var chapter = ct.listChaptersTodo[idx];
                        return ContainerChapterDownload(
                          chapters: chapter.chapter.title,
                          pages: '${chapter.chapter.imagens.length}',
                          icons: [
                            ChapterDownloadStatus(
                              chapter: chapter.chapter,
                              uniqueid: chapter.uniqueid,
                              ct: ct,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const CoffeeText(
                    text: 'Baixados',
                    typography: CoffeeTypography.title,
                  ),
                  ListView.builder(
                    itemCount: ct.listChaptersDone.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, idx) {
                      var chapter = ct.listChaptersDone[idx].chapter;
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/chapter',
                            arguments: {
                              'manga': ct.mangaDownload!.manga,
                              'chapter': chapter,
                            },
                          );
                        },
                        child: ContainerChapterDownload(
                          chapters: chapter.title,
                          pages: '${chapter.imagens.length}',
                          icons: [
                            CoffeeIconButton(
                              onTap: () {
                                ct.deleteOneChapter(
                                  chapter: ct.listChaptersDone[idx].chapter,
                                  uniqueId: ct.listChaptersDone[idx].uniqueid,
                                );
                              },
                              icon: Icons.delete_outline_sharp,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
