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

class ServiceDownload extends ChangeNotifier {
  final CreateUsecase createCase;
  final UpdateUsecase updateCase;
  final DeleteUsecase deleteCase;
  final DeleteAllUsecase deleteAllCase;
  final GetUsecase getCase;
  final ListUsecase listCase;
  //final ClientDio client;

  ServiceDownload(this.createCase, this.updateCase, this.deleteCase,
      this.deleteAllCase, this.getCase, this.listCase);

  final dio = Dio();

  Future<void> downloadFile(DownloadEntity downloadEntity) async {
    var chapters = downloadEntity.chapters.map((e) => e).toList();
    var images =
        chapters.expand((e) => e.chapter.imagens.map((e) => e.src)).toList();
    for (var chapter in chapters) {
      for (var image in images) {
       
        if (chapter.status == Status.todo || chapter.status == Status.doing) {
          try {
            chapter.status = Status.doing;
            final response = await dio.get(
              image,
              options: Options(
                headers: {
                  'Authorization':
                      'Bearer eyJhbGciOiJIUzUxMiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTY1MTUxMDgwNCwiaWF0IjoxNjUxNTEwODA0fQ.q2iOBcQjNvQJXtw32zsYP6m0NLV2Pboxto92xa5t-R__HWzn2m8wc5f9uAfZof76xAaY6eZYuuGtU_lIjxusvQ',
                },
                responseType: ResponseType.bytes,
              ),
              onReceiveProgress: (receivedBytes, totalBytes) {
                if (totalBytes != -1) {
                  final progress =
                      (receivedBytes / totalBytes * 100).toStringAsFixed(0);
                 // print('Progresso do download: $progress%');
                }
              },
            );

            final fileBytes = response.data;
            var compressImage = await FlutterImageCompress.compressWithList(
              fileBytes,
              quality: 20,
            );
            var directory = Directory(
                '${downloadEntity.folder}/Manga Easy/${downloadEntity.uniqueid}/${chapter.chapter.title}');
            if (!await directory.exists()) {
              await directory.create(recursive: true);
            }
            var compressFile =
                File('${directory.path}/${image.split('/').last}');
            await compressFile.writeAsBytes(compressImage);

            //${downloadEntity.uniqueid}/${chapter.chapter.number}/

            print('Download complete!');
            notifyListeners();
          } catch (e) {
            print('Error during file download: $e');
          }
        }
      }
      chapter.status = Status.done;
    }

    updateCase.update(data: downloadEntity, id: downloadEntity.uniqueid);
    notifyListeners();
  }
}
