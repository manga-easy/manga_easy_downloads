import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/chapter_download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/atoms/custom_app_bar.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/organisms/list_chapter_download.dart';

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
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ct.mangaDownload == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: CustomAppBar(
          title: ct.mangaDownload!.manga.title,
          listPopMenu: [
            PopupMenuItem(
              onTap: () {
                setState(() {
                  ct.deleteAllChapter(downloadEntity: ct.mangaDownload!);
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
              const Expanded(
                child: CoffeeButton(
                  label: 'Baixar mais capítulos',
                ),
              ),
              true
                  ? CoffeeIconButton(
                      onTap: () {},
                      icon: Icons.pause_circle,
                      size: 50,
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverVisibility(
              visible: ct.mangaDownload!.chapters
                  .where((element) => element.status == Status.todo)
                  .toList()
                  .isNotEmpty,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CoffeeText(
                      text: 'Em transferência',
                      typography: CoffeeTypography.title,
                    ),
                    ListChapterDownload(
                      listChapter: ct.mangaDownload!.chapters
                          .where((element) => element.status == Status.todo)
                          .toList(),
                      icons: [
                        CoffeeIconButton(
                          onTap: () {},
                          icon: Icons.download,
                        ),
                        CoffeeIconButton(
                          onTap: () {},
                          icon: Icons.cancel_outlined,
                        ),
                      ],
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
                  ListChapterDownload(
                    listChapter: ct.mangaDownload!.chapters
                        .where((element) => element.status == Status.done)
                        .toList(),
                    icons: [
                      CoffeeIconButton(
                        onTap: () {},
                        icon: Icons.delete_outline_sharp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
              ),
            )
          ],
        ),
      ),
    );
  }
}
