import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadMapper {
  DownloadEntity fromJson(Map<String, dynamic> json) {
    return DownloadEntity(
      id: json['id'] ?? '',
      uniqueid: json['uniqueid'],
      idUser: json['idUser'],
      createAt: json['createAt'],
      folder: json['folder'],
      manga: json['manga'],
      status: json['status'],
      chapters: json['chapters'],
    );
  }

  Map<String, dynamic> toJson(DownloadEntity data) {
    return {
      'id': data.id,
      'uniqueid': data.uniqueid,
      'idUser': data.idUser,
      'createAt': data.createAt,
      'folder': data.folder,
      'manga': data.manga,
      'status': data.status,
      'chapters': data.chapters,
    };
  }
}
