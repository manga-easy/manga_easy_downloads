import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_chapter_download.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class ChapterDownloadPage extends StatelessWidget {
  const ChapterDownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: ThemeService.of.backgroundColor,
        elevation: 0,
        leading: CoffeeIconButton(
          onTap: () {
            Navigator.pop(context);
          },
          icon: Icons.arrow_back_ios_new_outlined,
        ),
        title: const CoffeeText(
          text: 'One piece',
          typography: CoffeeTypography.title,
        ),
        actions: [
          CoffeeIconButton(
            icon: Icons.search,
            size: 30,
            onTap: () {},
          ),
          CoffeeIconButton(
            onTap: () {},
            icon: Icons.list,
            size: 30,
          ),
        ],
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
              visible: true,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CoffeeText(
                      text: 'Em transferência',
                      typography: CoffeeTypography.title,
                    ),
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ContainerChapterDownload(
                          chapter: 5,
                          page: 100,
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
                        );
                      },
                    )
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
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ContainerChapterDownload(
                        chapter: 5,
                        page: 2,
                        icons: [
                          CoffeeIconButton(
                            onTap: () {},
                            icon: Icons.delete_outline_sharp,
                          ),
                        ],
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
            )
          ],
        ),
      ),
    );
  }
}
