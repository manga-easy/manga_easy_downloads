import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:path_provider/path_provider.dart';

class DownloadController {
  final CreateUsecase createCase;
  final UpdateUsecase updateCase;
  final DeleteUsecase deleteCase;
  final DeleteAllUsecase deleteAllCase;
  final GetUsecase getCase;
  final ListUsecase listCase;
  final ServiceDownload service;

  DownloadController(
    this.createCase,
    this.updateCase,
    this.deleteCase,
    this.deleteAllCase,
    this.getCase,
    this.listCase,
    this.service,
  );


  var downloadMangaMetal = DownloadEntity(
    uniqueid: "MentallyBroken",
    idUser: 1,
    createAt: DateTime.now(),
    manga: Manga(
      capa: "http://api.lucas-cm.com.br/mentally-broken/capa.png",
      href: "easy-scanMentallyBroken",
      title: "Mentally Broken",
      idHost: 7,
      uniqueid: "MentallyBroken",
    ),
    folder: '/storage/emulated/0/Download/',
    chapters: [
      ChapterStatus(
        Chapter(
          title: '1',
          href: "easy-scanMentallyBroken1",
          id: "MentallyBroken1",
          imagens: [
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/1.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/2.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/3.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/4.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/5.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/6.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/7.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
            ImageChapter(
              src: "http://api.lucas-cm.com.br/mentally-broken/01/8.jpg",
              state: 1,
              tipo: TypeFonte.image,
            ),
          ],
          number: 1,
          date: "2023-06-16 16:49:58.507446",
        ),
        Status.todo,
      ),
    ],
    status: Status.todo,
  );

  var folder = '/storage/emulated/0/Downloads';

  Future<String> pickDirectory() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      // O usuário selecionou uma pasta
      print('Pasta selecionada: $directoryPath');
      return folder = directoryPath;
      // ou fazer outras operações.
    }
    if (directoryPath == null) {
      // O usuário cancelou a seleção da pasta.
      print('Seleção de pasta cancelada.');
      return '';
    }

    return '/storage/emulated/0/Downloads';
  }

  Future<void> downloadFile() async {
    await service.downloadFile(downloadMangaMetal);
  }
}
