// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:manga_easy_sdk/manga_easy_sdk.dart';

// class ServiceDownloads extends ValueNotifier {
//   final IDownloadRepositor downloadRepositor;
//   final GetHostHrefCase getHostHref;
//   final NotificFCM noti;
//   final ApiDownload api;

//   ServiceDownloads({
//     required this.downloadRepositor,
//     required this.noti,
//     required this.api,
//     required this.getHostHref,
//   }) : super(null);

//   var pause = ValueNotifier(false);
//   var andamento = ValueNotifier(false);

//   void starting() {
//     iniciaDowload();
//     return;
//   }

//   Future iniciaDowload() async {
//     var downloads = downloadRepositor.list();
//     if (andamento.value) {
//       return null;
//     }
//     try {
//       if (kDebugMode) {
//         print('Serviço em andamento');
//       }
//       for (var i = 0; i < downloads.length; i++) {
//         andamento.value = true;
//         var download = downloads[i];
//         var auxi = download.copy();
//         if (pause.value) {
//           andamento.value = false;
//           return null;
//         }
//         var idNoti = DateTime.now().second;
//         var totalAbaixar = download.abaixar.length;
//         var totalBaixado = 0;
//         if (download.abaixar.isNotEmpty) {
//           if (kDebugMode) {
//             print(
//                 'Download em andamento: Baixando $totalBaixado de $totalAbaixar');
//           }
//           await noti.showprogressNotification(
//             id: idNoti,
//             title: "Download em andamento",
//             progress: returnPorcent(totalBaixado, totalAbaixar),
//             body: 'Baixando $totalBaixado de $totalAbaixar',
//           );
//           for (var capitulo in download.abaixar) {
//             var cap = auxi.baixado
//                 .indexWhere((element) => capitulo.title == element.title);
//             if (cap < 0) {
//               try {
//                 if (pause.value) {
//                   andamento.value = false;
//                   notifyListeners();
//                   return null;
//                 }
//                 if (!await Helps.verificarConexao()) {
//                   if (kDebugMode) {
//                     print('Download Pausado: Sem conexão');
//                   }
//                   await noti.showDefaltNotication(
//                     id: idNoti,
//                     title: "Download Pausado",
//                     body: 'Sem conexão',
//                   );
//                   andamento.value = false;
//                   return null;
//                 }
//                 var host = await getHostHref(capitulo.href);
//                 var retorno =
//                     await host.getConteudoChapter(manga: capitulo.href);
//                 var listImages = retorno.toList();
//                 var idImage = 0;

//                 for (var image in listImages) {
//                   if (pause.value) {
//                     andamento.value = false;
//                     return null;
//                   }
//                   if (image.tipo == TypeFonte.image) {
//                     await noti.showprogressNotification(
//                       id: idNoti,
//                       title: "Baixando Capítulo ${subStringCapName(capitulo)}",
//                       progress: returnPorcent(idImage, listImages.length),
//                       body: 'Baixando imagens $idImage de ${listImages.length}',
//                     );
//                     var path = await downloadFile(
//                       imageUrl: image.src,
//                       pasta: "/${download.uniqueid}cap-${capitulo.title}image",
//                       cap: idImage.toString(),
//                     );
//                     if (path != null) {
//                       image.path = path;
//                     } else {
//                       return null;
//                     }

//                     idImage++;
//                   }
//                 }
//                 capitulo.imagens = listImages;
//                 if (listImages.isEmpty) {
//                   throw Exception('Imagens vazias');
//                 }
//                 var cap = auxi.baixado
//                     .indexWhere((element) => capitulo.title == element.title);
//                 if (cap < 0 && listImages.isNotEmpty) {
//                   auxi.abaixar.removeWhere(
//                       (element) => capitulo.title == element.title);
//                   auxi.baixado.add(capitulo);
//                 }
//                 totalBaixado++;
//                 await noti.showprogressNotification(
//                   id: idNoti,
//                   title: "Download em andamento",
//                   progress: ((totalBaixado / totalAbaixar) * 100).toInt(),
//                   body: 'Baixando $totalBaixado de $totalAbaixar',
//                 );
//               } catch (e) {
//                 var cap = auxi.erro
//                     .indexWhere((element) => capitulo.title == element.title);
//                 if (cap < 0) {
//                   auxi.abaixar.removeWhere(
//                       (element) => capitulo.title == element.title);
//                   auxi.erro.add(capitulo);
//                 }
//                 await noti.showprogressNotification(
//                   id: idNoti,
//                   title: "Download com erro",
//                   progress: returnPorcent(totalBaixado, totalAbaixar),
//                   body: 'Erro no capítulo ${capitulo.title}',
//                 );
//                 Helps.log(e);
//               }

//               await downloadRepositor.put(objeto: auxi, id: auxi.uniqueid);
//             }

//             notifyListeners();
//           }
//           if (kDebugMode) {
//             print(
//                 'Download finalizado: $totalBaixado capitulos de ${download.detalhesManga.title}');
//           }
//           await noti.showDefaltNotication(
//             id: idNoti,
//             title: "Download finalizado",
//             body: '$totalBaixado capitulos de ${download.detalhesManga.title}',
//           );
//           notifyListeners();
//         }
//       }
//       andamento.value = false;
//     } catch (e) {
//       Helps.log(e);
//       await noti.showDefaltNotication(
//         id: DateTime.now().second,
//         title: "Erro nos downloads",
//         body: e.toString(),
//       );
//       andamento.value = false;
//       return null;
//     }
//   }

//   Future<void> deletarDownload(Chapter cap, DownloadEntity down) async {
//     try {
//       for (var item in cap.imagens) {
//         if (item.path != null) {
//           var file = File(item.path!);
//           await file.delete();
//         }
//       }
//       down.baixado.removeWhere((element) => element.title == cap.title);
//       down.abaixar.removeWhere((element) => element.title == cap.title);
//       await downloadRepositor.put(objeto: down, id: down.uniqueid);
//       await noti.showDefaltNotication(
//         id: DateTime.now().second,
//         title: "Deletado com sucesso",
//         body: 'Capitulo ${cap.title}',
//       );
//       notifyListeners();
//     } catch (e) {
//       Helps.log(e);
//     }
//   }

//   Future deletaAllDownload(DownloadEntity download) async {
//     var captitulos = download.baixado.toList();
//     for (var item in captitulos) {
//       await deletarDownload(item, download);
//     }
//     await downloadRepositor.remove(id: download.uniqueid);
//     notifyListeners();
//   }

//   Future<String?> downloadFile(
//       {required String imageUrl,
//       required String pasta,
//       required String cap}) async {
//     try {
//       //comment out the next two lines to prevent the device from getting
//       // the image from the web in order to prove that the picture is
//       // coming from the device instead of the web
//       var type = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
//       var patth = await getApplicationDocumentsDirectory();
//       var filename = '${patth.path}$pasta$cap$type';
//       if (kDebugMode) {
//         print(filename);
//       }
//       var response = await api.get(imageUrl, filename);
//       File file = File(filename);
//       if (!await file.exists()) {
//         // response.data is List<int> type
//         await file.writeAsBytes(response.bodyBytes);
//         if (response.statusCode == 200) {
//           return filename;
//         } else {
//           return null;
//         }
//       } else {
//         return filename;
//       }
//     } catch (e) {
//       await noti.showDefaltNotication(
//         id: DateTime.now().second,
//         title: "Erro nos downloadFile",
//         body: e.toString(),
//       );
//       Helps.log(e);
//       return null;
//     }
//   }

//   returnPorcent(int totalBaixado, int totalAbaixar) {
//     try {
//       return ((totalBaixado / totalAbaixar) * 100).toInt();
//     } catch (e) {
//       return 0;
//     }
//   }

//   subStringCapName(Chapter cap) {
//     return cap.title
//         .substring(0, cap.title.length > 15 ? 15 : cap.title.length);
//   }
// }