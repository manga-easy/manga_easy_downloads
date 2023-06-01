import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';

abstract class UpdateUsecase {
  Future<void> update({required DownloadEntity data, required String id});
}
