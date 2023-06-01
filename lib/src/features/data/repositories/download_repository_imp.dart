import 'package:manga_easy_downloads/src/features/data/mappers/download_mapper.dart';
import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_persistent_database_service/manga_easy_persistent_database_service.dart';

class DownloadRepositoryImp implements DownloadRepository {
  final DownloadMapper mapper;
  final db = PersistentDatabaseSembastService();

  DownloadRepositoryImp(
    this.mapper,
  );
  final store = StoreSembast.toggle;

  @override
  Future<String> create({required DownloadEntity data}) async {
    var result = await db.create(objeto: mapper.toJson(data), store: store);
    return result;
  }

  @override
  Future<void> update(
      {required DownloadEntity data, required String id}) async {
    await db.update(objeto: mapper.toJson(data), store: store, id: id);
  }

  @override
  Future<void> delete({required String id}) async {
    await db.delete(id: id, store: store);
  }

  @override
  Future<void> deleteAll() async {
    await db.deleteAll(store: store);
  }

  @override
  Future<DownloadEntity> get({required String id}) async {
    var result = await db.get(id: id, store: store);
    var convert = mapper.fromJson(result!);
    return convert;
  }

  @override
  Future<List<DownloadEntity>> list() async {
    var result = await db.list(store: store);
    var convert = result.map((e) => mapper.fromJson(e)).toList();
    return convert;
  }

//   @override
//   bool veriCapAbaixar(Chapter cap, String id) {
//     var down = get(id: id);
//     if (down == null) return false;
//     var index =
//         down.abaixar.indexWhere((element) => element.title == cap.title);
//     return index >= 0;
//   }

//   @override
//   bool veriCapBaixado(Chapter cap, String id) {
//     var down = get(id: id);
//     if (down == null) return false;
//     var index =
//         down.baixado.indexWhere((element) => element.title == cap.title);
//     return index >= 0;
//   }
}