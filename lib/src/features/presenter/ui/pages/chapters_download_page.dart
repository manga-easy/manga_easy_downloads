import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/atoms/custom_app_bar.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/organisms/list_chapter_download.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ChapterDownloadPage extends StatelessWidget {
  final DownloadController ct;
  final String name;
  final String pages;
  final List<ChapterStatus> listChapterTodo;
  final List<ChapterStatus> listChapterDone;

  const ChapterDownloadPage({
    super.key,
    required this.ct,
    required this.name,
    required this.pages,
    required this.listChapterTodo,
    required this.listChapterDone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: CustomAppBar(
          title: name,
          ct: ct,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Material(
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
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
              visible: listChapterTodo.isNotEmpty,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CoffeeText(
                      text: 'Em transferência',
                      typography: CoffeeTypography.title,
                    ),
                    ListChapterDownload(
                      pages: pages,
                      listChapter: listChapterTodo,
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
                    listChapter: listChapterDone,
                    pages: pages,
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
