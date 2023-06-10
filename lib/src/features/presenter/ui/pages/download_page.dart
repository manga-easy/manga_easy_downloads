import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/organisms/list_manga_download.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class DownloadPage extends StatefulWidget {
  static const route = '/downloads';
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeService.of.backgroundColor,
        elevation: 0,
        leading: CoffeeIconButton(
          icon: Icons.arrow_back_ios_new_outlined,
          onTap: () => Navigator.pop(context),
        ),
        title: isSearch
            ? CoffeeSearchField(
                suffixIcon: CoffeeIconButton(
                  icon: Icons.close,
                  onTap: () {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                ),
              )
            : const CoffeeText(
                text: 'Downloads',
                typography: CoffeeTypography.title,
              ),
        actions: [
          isSearch
              ? const SizedBox.shrink()
              : CoffeeIconButton(
                  icon: Icons.search,
                  size: 30,
                  onTap: () {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                ),
          CoffeeIconButton(
            icon: Icons.list,
            size: 30,
            onTap: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeService.of.backgroundIcon,
        onPressed: () {},
        child: false
            ? const Icon(
                Icons.pause,
                size: 30,
              )
            : const Icon(
                Icons.play_arrow,
                size: 30,
              ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CoffeeText(text: '8 capítulos baixados no total'),
                      CoffeeText(text: '1 capítulo em transferência'),
                    ],
                  ),
                ],
              ),
            ),
            SliverVisibility(
              visible: true,
              sliver: ListMangaDownload(title: 'Em transferência'),
            ),
            ListMangaDownload(title: 'Baixados'),
          ],
        ),
      ),
    );
  }
}
