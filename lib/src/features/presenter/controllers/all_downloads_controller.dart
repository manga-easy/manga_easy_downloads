// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:manga_easy_downloads/src/core/services/service_download.dart';
// import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
// import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';
// import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';
// import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';
// import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';
// import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
// import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';
// import 'package:manga_easy_sdk/manga_easy_sdk.dart';
// import 'package:path_provider/path_provider.dart';

// class AllDownloadsController {
//   // final CreateUsecase createCase;
//   // final UpdateUsecase updateCase;
//   // final DeleteUsecase deleteCase;
//   final DeleteAllUsecase deleteAllCase;
// //  final GetUsecase getCase;
//   final ListUsecase listCase;
//   final ServiceDownloads download;
//   final MangaRepo mangaRepo;
//   final DetalhesMangaRepo detalhesMangaRepo;
//   final HistoricRepositoryLocal historicoRepo;
//   final MangaMapper mangaMapper;

//   AllDownloadsController({
//     required this.download,
//     required this.detalhesMangaRepo,
//     required this.historicoRepo,
//     required this.mangaRepo,
//     required this.mangaMapper,
//   });

//   var listDownload = <DownloadEntity>[];

//   void dispose() {
//     download.removeListener(loadingDownload);
//   }

//   void init() {
//     loadingDownload();
//     download.notifyListeners();
//     download.addListener(loadingDownload);
//   }

//   double retornaPorcentagem(num total, num a) {
//     try {
//       if (total == 0) {
//         return 1.0;
//       }
//       return ((a * 100) / total) * 0.01;
//     } catch (e) {
//       return 1.0;
//     }
//   }

//   void pausaIniciaDownload() {
//     download.pause.value = !download.pause.value;
//     if (!download.pause.value) {
//       download.iniciaDowload();
//     }
//   }

//   void loadingDownload() async {
//     listDownload = await listCase.list();
//   }

//   void optionsMenu(int opt, context) {
//     switch (opt) {
//       case 1:
//         pausaIniciaDownload();
//         break;
//       case 2:
//         clearAllDownloads(context);
//         break;
//     }
//   }

//   Future<void> clearAllDownloads(BuildContext context) async {
//     var contains = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];
//     await deleteAllCase.deleteAll();
//     listDownload.clear();
//     download.notifyListeners();
//     var patth = await getApplicationDocumentsDirectory();
//     var ret = Directory(patth.path).listSync();
//     for (var element in ret) {
//       var ret2 = contains.indexWhere((e) => element.path.contains(e));
//       if (ret2 >= 0) {
//         element.deleteSync();
//       }
//     }
//     AppHelps.showSnacBar(msg: 'Downloads limpos', context: context);
//   }

//   Manga getMangaFromDownload(DownloadEntity download) {
//     return mangaMapper.from(download.detalhesManga);
//   }
// }
