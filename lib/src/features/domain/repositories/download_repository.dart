import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';

abstract class DownloadRepository {
  Future<String> create({required DownloadEntity data});
  Future<void> update({required DownloadEntity data, required String id});
  Future<void> delete({required String id});
  Future<void> deleteAll();
  Future<DownloadEntity> get({required String id});
  Future<List<DownloadEntity>> list();
}
