import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';

abstract class ListUsecase {
  Future<List<DownloadEntity>> list();
}