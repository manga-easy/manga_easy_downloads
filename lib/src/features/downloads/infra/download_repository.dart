import 'package:manga_easy/modules/downloads/domain/models/download.dart';
import 'package:manga_easy/modules/downloads/domain/repositories/download_repository_inter.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadRepository extends IDownloadRepositor {
  DownloadRepository(super.localDatabase);

  @override
  String table = 'boxDownloads';

  @override
  Download? get({required String id}) {
    var ret = localDatabase.get(id: id, table: table);
    if (ret == null) {
      return null;
    }
    return Download.fromJson(Map.from(ret));
  }

  @override
  List<Download> list() {
    var ret = localDatabase.list(table: table);
    return ret.map((e) => Download.fromJson(Map.from(e))).toList();
  }

  @override
  Future<void> remove({required String id}) async {
    await localDatabase.delete(id: id, table: table);
  }

  @override
  bool veriCapAbaixar(Chapter cap, String uniqueid) {
    var down = get(id: uniqueid);
    if (down == null) return false;
    var index =
        down.abaixar.indexWhere((element) => element.title == cap.title);
    return index >= 0;
  }

  @override
  bool veriCapBaixado(Chapter cap, String uniqueid) {
    var down = get(id: uniqueid);
    if (down == null) return false;
    var index =
        down.baixado.indexWhere((element) => element.title == cap.title);
    return index >= 0;
  }

  @override
  Future<void> put({required Download objeto, required String id}) async {
    await localDatabase.update(
      id: id,
      table: table,
      objeto: objeto.toJson(),
    );
  }

  @override
  Future<void> deleteAll() async {
    await localDatabase.deleteAll(table: table);
  }
}
