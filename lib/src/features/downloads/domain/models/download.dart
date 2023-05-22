import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class Download {
  String? id;
  int idHost;
  String uniqueid;
  int idUser;
  DetalhesManga detalhesManga;
  List<Chapter> baixado;
  List<Chapter> abaixar;
  List<Chapter> erro;
  DateTime dataCria;
  Download({
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

  factory Download.fromJson(dynamic json) {
    return Download(
        id: json['id'] ?? '',
        idHost: json['idHost'],
        uniqueid: Helps.convertUniqueid(json['uniqueid'] ?? json['idManga']),
        detalhesManga: DetalhesManga.fromJson(Map.from(json['detalhesManga'])),
        idUser: json['idUser'],
        erro: json['erro'] != null
            ? json['erro'].map<Chapter>((e) => Chapter.fromJson(e)).toList()
            : [],
        abaixar: json['abaixar'] != null
            ? json['abaixar'].map<Chapter>((e) => Chapter.fromJson(e)).toList()
            : [],
        baixado: json['baixado'] != null
            ? json['baixado'].map<Chapter>((e) => Chapter.fromJson(e)).toList()
            : [],
        dataCria: json['dataCria']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idHost'] = idHost;
    data['uniqueid'] = uniqueid;
    data['idUser'] = idUser;
    data['abaixar'] = abaixar.map((v) => v.toJson()).toList();
    data['erro'] = erro.map((v) => v.toJson()).toList();
    data['baixado'] = baixado.map((v) => v.toJson()).toList();
    data['dataCria'] = dataCria;
    data['detalhesManga'] = detalhesManga.toJson();
    return data;
  }

  Download copy() => Download.fromJson(toJson());
}
