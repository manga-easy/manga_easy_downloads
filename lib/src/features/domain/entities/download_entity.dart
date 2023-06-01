import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadEntity {
  String? id;
  int idHost;
  String uniqueid;
  int idUser;
  DetalhesManga detalhesManga;
  List<Chapter> baixado;
  List<Chapter> abaixar;
  List<Chapter> erro;
  DateTime dataCria;

  DownloadEntity({
    this.id,
    required this.idHost,
    required this.uniqueid,
    required this.idUser,
    required this.dataCria,
    required this.abaixar,
    required this.baixado,
    required this.detalhesManga,
    required this.erro,
  });
}
