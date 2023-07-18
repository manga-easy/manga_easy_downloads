import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/organisms/list_manga_download.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:persistent_database/persistent_database.dart';

class DownloadController extends ChangeNotifier {
  final CreateUsecase createCase;
  final UpdateUsecase updateCase;
  final DeleteUsecase deleteCase;
  final DeleteAllUsecase deleteAllCase;
  final GetUsecase getCase;
  final ListUsecase listCase;
  final ServiceDownload _service;
  final Preference _servicePrefs;

  DownloadController(
    this.createCase,
    this.updateCase,
    this.deleteCase,
    this.deleteAllCase,
    this.getCase,
    this.listCase,
    this._service,
    this._servicePrefs,
  );

  bool isPausedAll = false;
  bool isPaused = false;

  void init() async {
    listDownload();
    isPausedAll = await readPauseAllPref();
    notifyListeners();
  }

  void savePauseAllPref() async {
    isPausedAll = !isPausedAll;
    await _servicePrefs.put(
      keyPreferences: KeyPreferences.downloadPauseAll,
      value: isPausedAll,
    );
  }

  Future<bool> readPauseAllPref() async {
    return await _servicePrefs.get<bool>(
        keyPreferences: KeyPreferences.downloadPauseAll);
  }

  List<DownloadEntity> listTodo = [];
  List<DownloadEntity> listDone = [];
  List<DownloadEntity> listMangaDownloadTemp = [];

  void listDownload() async {
    listMangaDownloadTemp = await listCase.list();
    print('Lista toda $listMangaDownloadTemp');
    listTodo =
        listMangaDownloadTemp.where((e) => e.status == Status.todo).toList();
    print('listTodo: $listTodo');
    listDone =
        listMangaDownloadTemp.where((e) => e.status == Status.done).toList();
    print('listDone: $listDone');
    notifyListeners();
  }

  Future<void> pickDirectory() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      // O usuário selecionou uma pasta
      print('Pasta selecionada: $directoryPath');
      Preference(GetIt.instance()).put(
        keyPreferences: KeyPreferences.downloadFolder,
        value: directoryPath,
      );
    }
  }

  double downloadProgress = 0.0;
  void downloadFile() async {
    try {
      listDownload();
      if (listTodo.isNotEmpty) {
        for (var todo in listTodo) {
          await _service.downloadFile(todo);
          updateCase.update(data: todo, id: todo.uniqueid);
        }
      }
      listDownload();

      print(listTodo.map((e) => e.chapters).map((e) => e.map((e) => e.status)));

      print('listTodo $listTodo');
      print('list done ${listDone.map((e) => e.manga.title).toList()}');

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  String calculateFolderSize(String dirPath) {
    var dir = Directory(dirPath);
    int totalSize = 0;
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      return 'N/A';
    }
    var totalKbytes = (totalSize / 1024).floor();
    var totalMegaByte = (totalSize / (1024 * 1024)).floor();

    return totalKbytes > 1000 ? '$totalMegaByte MB' : '$totalKbytes kB';
  }

  void progress(receivedBytes, totalBytes) {
    if (totalBytes != -1) {
      final progress = (receivedBytes / totalBytes * 100).toStringAsFixed(0);
      // print('Progresso do download: $progress%');
    }
  }

  void deleteAllDownload() async {
    for (var downloadTransfer in listTodo) {
      final folder =
          Directory('${downloadTransfer.folder}/${downloadTransfer.uniqueid}');

      await deleteCase.delete(id: downloadTransfer.uniqueid);
      if (await folder.exists()) {
        folder.deleteSync(recursive: true);
        listDownload();
        notifyListeners();
      } else {
        print('A pasta não existe');
      }
    }

    for (var download in listDone) {
      final folder = Directory('${download.folder}/${download.uniqueid}');

      await deleteCase.delete(id: download.uniqueid);
      if (await folder.exists()) {
        folder.deleteSync(recursive: true);
        listDownload();
        notifyListeners();

        print('Pasta excluída com sucesso');
      } else {
        print('A pasta não existe');
      }
    }
    print(listTodo.first.uniqueid);
    listDownload();
    notifyListeners();
  }

  void deleteAllChapter(String id, String folder) async {
    await deleteCase.delete(id: id);
    final file = Directory('$folder/$id');
    if (await file.exists()) {
      file.deleteSync(recursive: true);
      listDownload();

      print('Pasta excluída com sucesso');
    } else {
      print('A pasta não existe');
    }
    notifyListeners();
  }

  void deleteOneChapter() async {}

  void downloadManga(DownloadEntity downloadEntity) {
    if (listMangaDownloadTemp
        .any((e) => e.uniqueid == downloadEntity.uniqueid)) {
      var download = listMangaDownloadTemp
          .firstWhere((e) => e.uniqueid == downloadEntity.uniqueid);
      //     update
      // download.chapters.add
    } else {
      create();
    }
  }

  void create() async {
    //   bool permissionStatus;
    //   final deviceInfo = await DeviceInfoPlugin().androidInfo;

    // if (deviceInfo.version.sdkInt > 32) {
    //   permissionStatus = await Permission.photos.request().isGranted;
    // } else {
    //   permissionStatus = await Permission.storage.request().isGranted;
    // }

    await createCase.create(
      data: DownloadEntity(
        uniqueid: "MentallyBroken",
        idUser: 1,
        createAt: DateTime.now(),
        manga: Manga(
          capa: "http://api.lucas-cm.com.br/mentallybroken/capa.png",
          href: "easy-scanMentallyBroken",
          title: "Mentally Broken",
          idHost: 7,
          uniqueid: "MentallyBroken",
        ),
        folder: '/storage/emulated/0/Documents',
        chapters: [
          ChapterStatus(
            Chapter(
              title: '1',
              href: "easy-scanMentallyBroken1",
              id: "MentallyBroken1",
              imagens: [
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/1/10.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
              ],
              number: 1,
              date: "2023-06-16 16:49:58.507446",
            ),
            Status.todo,
          ),
          ChapterStatus(
            Chapter(
              title: '2',
              href: "easy-scanMentallyBroken2",
              id: "MentallyBroken2",
              imagens: [
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/2/10.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
              ],
              number: 2,
              date: "2023-06-16 16:49:58.507446",
            ),
            Status.todo,
          ),
          ChapterStatus(
            Chapter(
              title: '3',
              href: "easy-scanMentallyBroken3",
              id: "MentallyBroken3",
              imagens: [
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/3/10.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
              ],
              number: 3,
              date: "2023-06-16 16:49:58.507446",
            ),
            Status.todo,
          ),
          ChapterStatus(
            Chapter(
              title: '4',
              href: "easy-scanMentallyBroken4",
              id: "MentallyBroken4",
              imagens: [
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentallybroken/4/10.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
              ],
              number: 4,
              date: "2023-06-16 16:49:58.507446",
            ),
            Status.done,
          ),
        ],
      ),
    );
    listDownload();

    notifyListeners();
  }
}
