import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:manga_easy/core/config/app_box.dart';
import 'package:manga_easy/core/config/controller_inter.dart';

import 'package:manga_easy/modules/downloads/domain/models/download.dart';
import 'package:manga_easy/core/services/service_downloads.dart';
import 'package:manga_easy/modules/downloads/domain/repositories/download_repository_inter.dart';
import 'package:manga_easy/modules/home/domain/repositories/general_repository_inter.dart';
import 'package:manga_easy/modules/mangas/domain/models/status_page.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DonwloadsController extends IController {
  final IDownloadRepositor downloadRepositor;
  final ServiceDownloads sd;
  final GeneralRepositoryLocal _generalRepositoryLocal;

  DonwloadsController(
    this.downloadRepositor,
    this.sd,
    this._generalRepositoryLocal,
  );

  late List capitulos;
  late DetalhesManga detalhes;
  late Manga manga;
  late Historico historico;
  var visualList = true;
  Download? download;

  @override
  void dispose() {
    sd.removeListener(carregaDownload);
    super.dispose();
  }

  @override
  void init(BuildContext context) {
    showWarningDownload(context);
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    capitulos = arguments[0];
    detalhes = arguments[1];
    manga = arguments[2];
    historico = arguments[3];
    carregaDownload();
    state = PageStatus.done;
    sd.addListener(carregaDownload);
  }

  void carregaDownload() {
    download = downloadRepositor.get(id: manga.uniqueid);
  }

  Future<void> baixarCaps(Chapter cap) async {
    carregaDownload();
    download ??= Download(
      idHost: Helps.retornaIdHost(v: manga.href),
      uniqueid: manga.uniqueid,
      idUser: 0,
      dataCria: DateTime.now(),
      abaixar: [],
      baixado: [],
      erro: [],
      detalhesManga: detalhes,
    );
    if (!downloadRepositor.veriCapAbaixar(cap, manga.uniqueid)) {
      download!.abaixar.add(cap);
    }

    await downloadRepositor.put(objeto: download!, id: download!.uniqueid);
    sd.pause.value = false;
    sd.iniciaDowload();
  }

  Future<void> baixarAllCaps() async {
    carregaDownload();
    download ??= Download(
      idHost: Helps.retornaIdHost(v: manga.href),
      uniqueid: manga.uniqueid,
      idUser: 0,
      dataCria: DateTime.now(),
      abaixar: [],
      baixado: [],
      erro: [],
      detalhesManga: detalhes,
    );
    for (var item in detalhes.capitulos) {
      if (!downloadRepositor.veriCapAbaixar(item, manga.uniqueid) &&
          !downloadRepositor.veriCapBaixado(item, manga.uniqueid)) {
        download!.abaixar.add(item);
      }
    }
    await downloadRepositor.put(objeto: download!, id: download!.uniqueid);
    sd.pause.value = false;
    sd.iniciaDowload();
  }

  Future<void> deletarCap(Chapter cap) async {
    await sd.deletarDownload(cap, download!);
  }

  Future<void> deletOrBaixa(Chapter cap, String uniqueid) async {
    downloadRepositor.veriCapBaixado(cap, uniqueid)
        ? deletarCap(cap)
        : baixarCaps(cap);
  }

  void optinMenu(int value) {
    switch (value) {
      case 1:
        baixarAllCaps();
        break;
      case 2:
        deleteAll();
        break;
      default:
    }
  }

  Future<void> deleteAll() async {
    if (download != null) {
      var caps = download!.baixado.toList();
      for (var element in caps) {
        await deletarCap(element);
      }
      downloadRepositor.remove(id: download!.uniqueid);
    }
  }

  void showWarningDownload(BuildContext context) {
    var result = _generalRepositoryLocal.get(
          keybox: KeyBox.isShowWarningDownload,
        ) ??
        true;
    if (result) {
      const CoffeeDialogUnicorn(
        title: 'Lembre-se',
        middleText: 'É necessário que esteja ciente, que a função de baixar os '
            'capítulos só funciona em primeiro plano. Dessa forma, para que o download '
            'conclua sem erros, é primordial que espere com o aplicativo aberto.',
      ).warning(context);
      _generalRepositoryLocal.put(
        keybox: KeyBox.isShowWarningDownload,
        objeto: false,
      );
    }
  }
}
