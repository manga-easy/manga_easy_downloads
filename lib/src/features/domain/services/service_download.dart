import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ServiceDownload extends ChangeNotifier {
  final CreateUsecase createCase;
  final UpdateUsecase updateCase;
  final DeleteUsecase deleteCase;
  final DeleteAllUsecase deleteAllCase;
  final GetUsecase getCase;
  final ListUsecase listCase;
  //final ClientDio client;
  final dio = Dio();
  double downloadProgress = 0.0;

  ServiceDownload(this.createCase, this.updateCase, this.deleteCase,
      this.deleteAllCase, this.getCase, this.listCase);

  CancelToken cancelToken = CancelToken();

  double getDownloadProgress(int totalImages, int completedImages) {
    return totalImages > 0 ? completedImages / totalImages : 0.0;
  }

  void progress(int totalImages, int completedImages) {
    downloadProgress = getDownloadProgress(totalImages, completedImages);
    notifyListeners();
  }

  Future<void> downloadFile(DownloadEntity downloadEntity) async {
    // int completedChapters = 0;
    //ler a lista de capitulos

    for (var i = 0; i < downloadEntity.chapters.length; i++) {
      var chapter = downloadEntity.chapters[i];
      var directory = Directory(
          '${downloadEntity.folder}/Manga Easy/${downloadEntity.uniqueid}/${chapter.chapter.number}');
      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }
      List<ImageChapter> imagensDownload = chapter.chapter.imagens;
      if (chapter.status == Status.done) continue;
      for (var image in imagensDownload) {
        if (File('${directory.path}/${image.src.split('/').last}')
            .existsSync()) {
          continue;
        }
        try {
          final response = await dio.get(
            image.src,
            options: Options(
              headers: {
                'Authorization':
                    'Bearer eyJhbGciOiJIUzUxMiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTY1MTUxMDgwNCwiaWF0IjoxNjUxNTEwODA0fQ.q2iOBcQjNvQJXtw32zsYP6m0NLV2Pboxto92xa5t-R__HWzn2m8wc5f9uAfZof76xAaY6eZYuuGtU_lIjxusvQ',
              },
              responseType: ResponseType.bytes,
            ),
            cancelToken: cancelToken,
            onReceiveProgress: (received, total) {
              int percentage = ((received / total) * 100).floor();
              print('$percentage%');
            },
          );

          final fileBytes = response.data;
          var compressImage = await FlutterImageCompress.compressWithList(
            fileBytes,
            quality: 20,
          );
          var compressFile =
              File('${directory.path}/${image.src.split('/').last}');
          await compressFile.writeAsBytes(compressImage, mode: FileMode.write);

          downloadEntity.chapters[i].status = Status.done;
        } catch (e) {
          chapter.status = Status.error;
          print('Deu erro no download: $e');
        }

        // completedChapters++;
        // progress(chaptersDownload.length, completedChapters);
      }
     //Colocar como um copywith
      await updateCase.update(
        data: DownloadEntity(
          uniqueid: downloadEntity.uniqueid,
          idUser: downloadEntity.idUser,
          createAt: downloadEntity.createAt,
          manga: downloadEntity.manga,
          folder: downloadEntity.folder,
          chapters: downloadEntity.chapters,
        ),
        id: downloadEntity.id!,
      );
    }
    notifyListeners();
  }

  void pauseDownload() {
    cancelToken.cancel();
  }

  // void resumeDownload(DownloadEntity downloadEntity) {
  //   cancelToken = CancelToken();
  //   downloadFile(downloadEntity);
  // }
  // Future<void> delete() {
  // }
}
