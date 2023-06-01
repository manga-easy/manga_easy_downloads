import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';

abstract class CreateUsecase{
  Future<String> create({required DownloadEntity data});
}