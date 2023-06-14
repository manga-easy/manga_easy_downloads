import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadMapper {
  DownloadEntity fromJson(Map<String, dynamic> json) {
    return DownloadEntity(
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
      dataCria: json['dataCria'],
    );
  }

  Map<String, dynamic> toJson(DownloadEntity data) {
    return {
      'id': data.id,
      'idHost': data.idHost,
      'uniqueid': data.uniqueid,
      'idUser': data.idUser,
      'abaixar': data.abaixar.map((v) => v.toJson()).toList(),
      'erro': data.erro.map((v) => v.toJson()).toList(),
      'baixado': data.baixado.map((v) => v.toJson()).toList(),
      'dataCria': data.dataCria,
      'detalhesManga': data.detalhesManga.toJson(),
    };
  }
}
