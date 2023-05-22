import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy/main.dart';
import 'package:manga_easy/modules/downloads/domain/models/download.dart';
import 'package:manga_easy/modules/downloads/presenter/controllers/all_downloads_controller.dart';
import 'package:manga_easy/modules/downloads/presenter/ui/pages/downloads_page.dart';
import 'package:manga_easy/modules/downloads/presenter/ui/atoms/status_download.dart';
import 'package:manga_easy/modules/home/presenter/ui/atoms/card_manga.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class AllDownloadsPage extends StatefulWidget {
  static const router = '/allDownloads';

  const AllDownloadsPage({super.key});

  @override
  State<AllDownloadsPage> createState() => _AllDownloadsPageState();
}

class _AllDownloadsPageState extends State<AllDownloadsPage> {
  final ct = di.get<AllDownloadsController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    super.initState();
  }

  @override
  void dispose() {
    ct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_sharp,
                    color: ThemeService.of.backgroundText,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Downloads',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  onSelected: (v) => ct.optionsMenu(v, context),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(ct.download.pause.value
                          ? "Iniciar todos os downloads"
                          : 'Pausar os downloads'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Limpar todos os downloads'),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: ThemeService.of.backgroundText,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CoffeeField(
                icone: Icons.search,
                contentPadding: EdgeInsets.zero,
                color: ThemeService.of.backgroundText,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: ct.download,
                builder: (BuildContext context, value, child) =>
                    ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: ct.listDownload.length,
                  itemBuilder: (context, index) {
                    Download download = ct.listDownload[index];
                    var hes = ct.historicoRepo.get(id: download.uniqueid);
                    final manga = ct.getMangaFromDownload(download);
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        DonwloadsPage.router,
                        arguments: [
                          download.detalhesManga.capitulos,
                          download.detalhesManga,
                          manga,
                          hes,
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: 245,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                CardManga(
                                  man: manga,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    DonwloadsPage.router,
                                    arguments: [
                                      download.detalhesManga.capitulos,
                                      download.detalhesManga,
                                      manga,
                                      hes,
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        retornaTitulo(manga.title),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Total de capitulos ${download.detalhesManga.capitulos.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Capitulos a baixar ${download.abaixar.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Capitulos Baixado ${download.baixado.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        ct.download.deletaAllDownload(download),
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    )),
                                StatusDownload(
                                  finalizado: download.abaixar.isEmpty,
                                  pausado: !ct.download.andamento.value,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String retornaTitulo(String titulo) {
    if (titulo.length >= 20) {
      return '${titulo.substring(0, 20)}...';
    }
    return titulo;
  }
}
