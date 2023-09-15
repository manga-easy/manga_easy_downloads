import 'package:manga_easy_sdk/manga_easy_sdk.dart';

abstract class DownloadRepository {
  Future<void> update({required DownloadEntity data, required String uniqueid});
  Future<void> delete({required String uniqueid});
  Future<void> deleteAll();
  Future<DownloadEntity?> get({required String uniqueid});
  Future<List<DownloadEntity>> list();
}
