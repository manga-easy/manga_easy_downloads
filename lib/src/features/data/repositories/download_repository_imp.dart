import 'package:manga_easy_downloads/src/features/data/mappers/download_mapper.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:persistent_database/persistent_database.dart';

class DownloadRepositoryImp implements DownloadRepository {
  final DownloadMapper _mapper;
  final PersistentDatabaseSembast _database;

  DownloadRepositoryImp(
    this._mapper,
    this._database,
  );

  final store = StoreSembast.download;

  @override
  Future<void> update({
    required DownloadEntity data,
    required String uniqueid,
  }) async {
    await _database.update(
      objeto: _mapper.toJson(data),
      store: store,
      id: uniqueid,
    );
  }

  @override
  Future<void> delete({required String uniqueid}) async {
    await _database.delete(id: uniqueid, store: store);
  }

  @override
  Future<void> deleteAll() async {
    await _database.deleteAll(store: store);
  }

  @override
  Future<DownloadEntity?> get({required String uniqueid}) async {
    final result = await _database.get(id: uniqueid, store: store);
    if (result == null) {
      return null;
    }
    return _mapper.fromJson(result);
  }

  @override
  Future<List<DownloadEntity>> list() async {
    final result = await _database.list(store: store);
    return result.map((e) => _mapper.fromJson(e)).toList();
  }
}
