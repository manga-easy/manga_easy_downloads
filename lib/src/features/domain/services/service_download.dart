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

class ServiceDownload {
  final CreateUsecase createCase;
  final UpdateUsecase updateCase;
  final DeleteUsecase deleteCase;
  final DeleteAllUsecase deleteAllCase;
  final GetUsecase getCase;
  final ListUsecase listCase;
  //final ClientDio client;
  final dio = Dio();
  ValueNotifier<double> downloadProgress = ValueNotifier<double>(0.0);

  ServiceDownload(this.createCase, this.updateCase, this.deleteCase,
      this.deleteAllCase, this.getCase, this.listCase);

  double getDownloadProgress(int totalImages, int completedImages) {
    return totalImages > 0 ? completedImages / totalImages : 0.0;
  }

  Future<void> downloadFile(DownloadEntity downloadEntity) async {
    var chapters = downloadEntity.chapters;
    var images =
        chapters.expand((e) => e.chapter.imagens.map((e) => e)).toList();
    int completedChapters = 0;
    print('Total de capítulos: ${chapters.length}');
    print('Total de imagens: ${images.length}');
    for (var chapter in chapters) {
      for (var image in images) {
        if (chapter.status == Status.todo || chapter.status == Status.doing) {
          try {
            chapter.status = Status.doing;
            await updateCase.update(
                data: downloadEntity, id: downloadEntity.uniqueid);

            print('Downloading image: ${image.src}');
            final response = await dio.get(
              image.src,
              options: Options(
                headers: {
                  'Authorization':
                      'Bearer eyJhbGciOiJIUzUxMiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTY1MTUxMDgwNCwiaWF0IjoxNjUxNTEwODA0fQ.q2iOBcQjNvQJXtw32zsYP6m0NLV2Pboxto92xa5t-R__HWzn2m8wc5f9uAfZof76xAaY6eZYuuGtU_lIjxusvQ',
                },
                responseType: ResponseType.bytes,
              ),
            );

            final fileBytes = response.data;
            var compressImage = await FlutterImageCompress.compressWithList(
              fileBytes,
              quality: 100,
            );
            var directory = Directory(
                '${downloadEntity.folder}/${downloadEntity.uniqueid}/${chapter.chapter.number}');
            if (!directory.existsSync()) {
              await directory.create(recursive: true);
            }
            var compressFile =
                File('${directory.path}/${image.src.split('/').last}');
            await compressFile.writeAsBytes(compressImage,
                mode: FileMode.write);

            completedChapters++;
            downloadProgress.value =
                getDownloadProgress(images.length, completedChapters);
            print('Download complete!');
          } catch (e) {
            print('Error during file download: $e');
          }
        }
      }
      chapter.status = Status.done;
      await updateCase.update(
          data: downloadEntity, id: downloadEntity.uniqueid);
      print('Chapter ${chapter.chapter.number} marked as done.');
    }

    await updateCase.update(data: downloadEntity, id: downloadEntity.uniqueid);
    print('Download entity updated.');
    print(downloadEntity.chapters.map((e) => e.status));
  }
}
