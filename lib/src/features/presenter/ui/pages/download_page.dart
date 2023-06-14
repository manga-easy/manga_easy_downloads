import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
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

List<Widget> _items = [
  const ContainerMangaDownload(),
  const ContainerMangaDownload(),
  const ContainerMangaDownload(),
];

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
          PopupMenuButton(
            icon: const Icon(Icons.list),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: CoffeeText(text: 'Limpar todos os downloads'),
              )
            ],
          )
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
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
            const SliverVisibility(
              sliver: SliverPadding(
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
              visible: true,
              sliver: ReorderableSliverList(
                delegate: ReorderableSliverChildListDelegate(_items),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = _items.removeAt(oldIndex);
                    _items.insert(newIndex, item);
                  });
                },
              ),
            ),
            const ListMangaDownload(title: 'Baixados'),
          ],
        ),
      ),
    );
  }
}
