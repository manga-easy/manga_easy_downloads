import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';

class ChapterDownloadController extends ChangeNotifier {
  final DeleteUsecase deleteCase;

  ChapterDownloadController(this.deleteCase);

  void deleteAllChapter({required DownloadEntity downloadEntity}) async {
    await deleteCase.delete(id: downloadEntity.id!);
    final file = Directory(
        '${downloadEntity.folder}/Manga Easy/${downloadEntity.uniqueid}');
    if (await file.exists()) {
      file.deleteSync(recursive: true);
      print('Pasta excluída com sucesso');
    } else {
      print('A pasta não existe');
    }
    //TODO listDownload();
    notifyListeners();
  }

  void deleteOneChapter() async {}
}
