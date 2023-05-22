import 'package:flutter/material.dart';
import 'package:manga_easy/modules/chapters/presenter/ui/views/capitulo_page.dart';
import 'package:manga_easy/modules/downloads/presenter/controllers/downloads_controller.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class CapitulosDownloads extends StatelessWidget {
  final DonwloadsController ct;
  final List detalhe;

  const CapitulosDownloads(
      {super.key, required this.detalhe, required this.ct});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ct.sd,
      builder: (BuildContext context, value, child) => ct.visualList
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Chapter cap = detalhe[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: ThemeService.of.isDarkTema ? null : Colors.white70,
                    child: ListTile(
                      // onLongPress: () => ct.marcaLido(cap.title),
                      onTap: () => Navigator.pushNamed(
                        context,
                        CapituloPage.router,
                        arguments: {
                          "DetalhesManga": ct.detalhes,
                          "Chapter": cap,
                          "Manga": ct.manga,
                          "Historico": ct.historico,
                        },
                      ),
                      title: Text(
                        'Capitulo ${cap.title}',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            //color: ct.isCapAtual(cap) ? Colors.white : null,
                            ),
                      ),
                      subtitle: Text(cap.date),
                      trailing: IconButton(
                        onPressed: () =>
                            ct.deletOrBaixa(cap, ct.manga.uniqueid),
                        icon: ct.downloadRepositor
                                .veriCapBaixado(cap, ct.manga.uniqueid)
                            ? const Icon(Icons.close)
                            : const Icon(Icons.download),
                      ),
                    ),
                  );
                },
                childCount: detalhe.length,
              ),
            )
          : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Chapter cap = detalhe[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    // color: ct.marcaCard(cap),
                    child: Center(
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 20),
                        dense: true,
                        // onLongPress: () => ct.marcaLido(cap.title),
                        onTap: () => Navigator.pushNamed(
                          context,
                          CapituloPage.router,
                          arguments: {
                            "DetalhesManga": ct.detalhes,
                            "Chapter": cap,
                            "Manga": ct.manga,
                            "Historico": ct.historico,
                          },
                        ),
                        title: Text(
                          cap.title,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              // color: ct.isCapAtual(cap) ? Colors.white : null,
                              ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: detalhe.length,
              ),
            ),
    );
  }
}
