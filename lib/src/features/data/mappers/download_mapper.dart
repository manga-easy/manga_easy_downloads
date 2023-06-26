import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadMapper {
  DownloadEntity fromJson(Map<String, dynamic> json) {
    return DownloadEntity(
      id: json['id'] ?? '',
      uniqueid: json['uniqueid'],
      idUser: json['idUser'],
      createAt: DateTime.tryParse(json['createAt']) ?? DateTime.now(),
      folder: json['folder'],
      manga: Manga.fromJson(json['manga']),
      chapters: (json['chapters'] as List)
          .map(
            (e) => ChapterStatus(
                Chapter.fromJson(e['chapter']),
                Status.values.firstWhere(
                    (s) => s.toString().split('.').last == e['status'])),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson(DownloadEntity data) {
    return {
      'id': data.id,
      'uniqueid': data.uniqueid,
      'idUser': data.idUser,
      'createAt': data.createAt.toString(),
      'folder': data.folder,
      'manga': data.manga.toJson(),
      'chapters': data.chapters
          .map((e) => {'chapter': e.chapter.toJson(), 'status': e.status.name})
          .toList(),
    };
  }
}
