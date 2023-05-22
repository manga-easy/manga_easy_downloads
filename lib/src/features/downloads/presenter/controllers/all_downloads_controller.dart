import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manga_easy/core/config/controller_inter.dart';
import 'package:manga_easy/core/config/helpes.dart';
import 'package:manga_easy/core/services/service_downloads.dart';
import 'package:manga_easy/modules/downloads/domain/models/download.dart';
import 'package:manga_easy/modules/downloads/domain/repositories/download_repository_inter.dart';
import 'package:manga_easy/modules/historico/domain/repositories/historico_repo.dart';
import 'package:manga_easy/modules/mangas/domain/mapper/manga_mapper.dart';
import 'package:manga_easy/modules/mangas/domain/repositories/detalhes_manga_repo.dart';
import 'package:manga_easy/modules/mangas/domain/repositories/manga_repo.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:path_provider/path_provider.dart';

class AllDownloadsController extends IController {
  final IDownloadRepositor downloadRepositor;
  final ServiceDownloads download;
  final MangaRepo mangaRepo;
  final DetalhesMangaRepo detalhesMangaRepo;
  final HistoricRepositoryLocal historicoRepo;
  final MangaMapper mangaMapper;

  AllDownloadsController({
    required this.download,
    required this.detalhesMangaRepo,
    required this.historicoRepo,
    required this.mangaRepo,
    required this.downloadRepositor,
    required this.mangaMapper,
  });

  var listDownload = <Download>[];

  @override
  void dispose() {
    download.removeListener(loadingDownload);
    super.dispose();
  }

  @override
  void init(BuildContext context) {
    loadingDownload();
    download.notifyListeners();
    download.addListener(loadingDownload);
  }

  double retornaPorcentagem(num total, num a) {
    try {
      if (total == 0) {
        return 1.0;
      }
      return ((a * 100) / total) * 0.01;
    } catch (e) {
      return 1.0;
    }
  }

  void pausaIniciaDownload() {
    download.pause.value = !download.pause.value;
    if (!download.pause.value) {
      download.iniciaDowload();
    }
  }

  void loadingDownload() {
    listDownload = downloadRepositor.list();
  }

  void optionsMenu(int opt, context) {
    switch (opt) {
      case 1:
        pausaIniciaDownload();
        break;
      case 2:
        clearAllDownloads(context);
        break;
    }
  }

  Future<void> clearAllDownloads(BuildContext context) async {
    var contains = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];
    await downloadRepositor.deleteAll();
    listDownload.clear();
    download.notifyListeners();
    var patth = await getApplicationDocumentsDirectory();
    var ret = Directory(patth.path).listSync();
    for (var element in ret) {
      var ret2 = contains.indexWhere((e) => element.path.contains(e));
      if (ret2 >= 0) {
        element.deleteSync();
      }
    }
    AppHelps.showSnacBar(msg: 'Downloads limpos', context: context);
  }

  Manga getMangaFromDownload(Download download) {
    return mangaMapper.from(download.detalhesManga);
  }
}
