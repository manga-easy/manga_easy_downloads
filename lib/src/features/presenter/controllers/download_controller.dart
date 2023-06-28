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
    create();
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

  void listDownload() async {
    List<DownloadEntity> listMangaDownloadTemp = await listCase.list();
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
          // Atualiza listTodo após o download de cada elemento
          listDownload();
          notifyListeners();
        }
      }

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

  void create() async {
    await createCase.create(
      data: DownloadEntity(
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
        folder: '/storage/emulated/0/Documents/Manga Easy',
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
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/10.jpg",
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
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/02/10.jpg",
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
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/03/10.jpg",
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
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/9.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/04/10.jpg",
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
  }
}
