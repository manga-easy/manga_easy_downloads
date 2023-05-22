import 'package:flutter/material.dart';
import 'package:manga_easy/main.dart';
import 'package:manga_easy/modules/downloads/presenter/controllers/downloads_controller.dart';
import 'package:manga_easy/modules/downloads/presenter/ui/organisms/capitulo_downloads.dart';
import 'package:manga_easy/modules/home/presenter/ui/atoms/loading.dart';
import 'package:manga_easy/modules/mangas/domain/models/status_page.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class DonwloadsPage extends StatefulWidget {
  static const router = '/downloads';

  const DonwloadsPage({super.key});

  @override
  State<DonwloadsPage> createState() => _DonwloadsPageState();
}

class _DonwloadsPageState extends State<DonwloadsPage> {
  final ct = di.get<DonwloadsController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    ct.addListener(() => setState(() {}));
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
        child: Builder(builder: (context) {
          switch (ct.state) {
            case PageStatus.done:
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    leading: BackButton(
                      color: ThemeService.of.backgroundText,
                    ),
                    backgroundColor: ThemeService.of.backgroundColor,
                    title: Text(
                      ct.detalhes.title.substring(
                          0,
                          ct.detalhes.title.length > 32
                              ? 32
                              : ct.detalhes.title.length),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    actions: [
                      PopupMenuButton<int>(
                        padding: EdgeInsets.zero,
                        onSelected: (value) => ct.optinMenu(value),
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Baixar Todos'),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Text('Deletar Todos'),
                          )
                        ],
                        child: Icon(
                          Icons.more_vert,
                          color: ThemeService.of.backgroundText,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  CapitulosDownloads(
                    detalhe: ct.capitulos,
                    ct: ct,
                  ),
                ],
              );
            default:
              return const Loading();
          }
        }),
      ),
    );
  }
}
