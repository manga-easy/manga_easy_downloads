// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/atoms/custom_app_bar.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/organisms/list_chapter_download.dart';

class ChapterDownloadPage extends StatefulWidget {
  final DownloadController ct;
  final String pages;
  final DownloadEntity mangaDownload;
  final List<ChapterStatus> listChapterTodo;
  final List<ChapterStatus> listChapterDone;
  const ChapterDownloadPage({
    Key? key,
    required this.ct,
    required this.pages,
    required this.listChapterTodo,
    required this.listChapterDone, required this.mangaDownload,
  }) : super(key: key);

  @override
  State<ChapterDownloadPage> createState() => _ChapterDownloadPageState();
}

class _ChapterDownloadPageState extends State<ChapterDownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: CustomAppBar(
          title: widget.mangaDownload.manga.title,
          ct: widget.ct,
          onClean: () {
            setState(() {
              widget.ct.deleteAllChapter(downloadEntity: widget.mangaDownload);
            });
          },
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
              visible: widget.listChapterTodo.isNotEmpty,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CoffeeText(
                      text: 'Em transferência',
                      typography: CoffeeTypography.title,
                    ),
                    ListChapterDownload(
                      pages: widget.pages,
                      listChapter: widget.listChapterTodo,
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
                    listChapter: widget.listChapterDone,
                    pages: widget.pages,
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
