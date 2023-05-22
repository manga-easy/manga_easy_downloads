import 'package:manga_easy/core/library/interfaces/local_database_inter.dart';
import 'package:manga_easy/modules/downloads/domain/models/download.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

abstract class IDownloadRepositor {
  abstract String table;
  final ILocalDatabase localDatabase;

  IDownloadRepositor(this.localDatabase);

  Future<void> remove({required String id});

  List<Download> list();

  bool veriCapBaixado(Chapter cap, String uniqueid);

  bool veriCapAbaixar(Chapter cap, String uniqueid);

  Download? get({required String id});

  Future<void> put({required Download objeto, required String id});

  Future<void> deleteAll();
}
