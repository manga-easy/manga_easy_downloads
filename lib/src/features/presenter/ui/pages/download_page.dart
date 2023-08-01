import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/atoms/custom_app_bar.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/moleculs/container_manga_download.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';
import 'package:reorderables/reorderables.dart';

class DownloadPage extends StatefulWidget {
  static const route = '/downloads-v2';
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  DownloadController ct = GetIt.I();
  TextEditingController searchController = TextEditingController();

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
          controller: searchController,
          onChanged: ct.filterList,
          title: 'Downloads',
          listPopMenu: [
            PopupMenuItem(
              onTap: () {
                setState(() {
                  ct.deleteAllDownload();
                });
              },
              child: const CoffeeText(text: 'Limpar todos os downloads'),
            ),
            PopupMenuItem(
              onTap: () => ct.pickDirectory(),
              child: const CoffeeText(text: 'Escolher pasta para download'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeService.of.backgroundIcon,
        onPressed: () {
          setState(() {
            ct.savePauseAllPref();
          });
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
                      ct.listFilterTodo.length > 1
                          ? CoffeeText(
                              text:
                                  '${ct.listFilterDownload.length} capítulos em transferência')
                          : CoffeeText(
                              text:
                                  '${ct.listFilterTodo.length} capítulo em transferência'),
                      ct.listFilterDownload.length > 1
                          ? CoffeeText(
                              text:
                                  '${ct.listFilterDownload.length} capítulos baixados no total')
                          : CoffeeText(
                              text:
                                  '${ct.listFilterDownload.length} capítulo baixado no total'),
                    ],
                  ),
                ],
              ),
            ),
            SliverVisibility(
              visible: ct.listFilterTodo.isNotEmpty,
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
              visible: ct.listFilterTodo.isNotEmpty,
              sliver: ReorderableSliverList(
                delegate: ReorderableSliverChildBuilderDelegate(
                  childCount: ct.listFilterTodo.length,
                  (context, idx) {
                    var mangaDownload = ct.listFilterTodo[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ContainerMangaDownload(
                        mangaDownload: mangaDownload,
                        isDownload: true,
                        downloadProgress: ct.downloadProgress,
                        ct: ct,
                        isPaused: ct.isPaused,
                      ),
                    );
                  },
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = ct.listFilterTodo.removeAt(oldIndex);
                    ct.listFilterTodo.insert(newIndex, item);
                  });
                },
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
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: ct.listFilterDownload.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, idx) {
                      var mangaDownload = ct.listFilterDownload[idx];
                      return ContainerMangaDownload(
                        mangaDownload: mangaDownload,
                        ct: ct,
                        isPaused: ct.isPaused,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
