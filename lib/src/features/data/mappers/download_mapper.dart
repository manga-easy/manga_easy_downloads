import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadMapper {
  DownloadEntity fromJson(Map<String, dynamic> json) {
    return DownloadEntity(
      id: json['id'] ?? '',
      uniqueid: json['uniqueid'],
      idUser: json['idUser'],
      createAt: DateTime.tryParse(json['createAt']) ?? DateTime.now(),
      manga: Manga.fromJson(json['manga']),
      chapters: (json['chapters'] as List)
          .map(
            (e) => ChapterStatus(
              chapter: Chapter.fromJson(e['chapter']),
              status: Status.values.firstWhere(
                (s) => s.toString().split('.').last == e['status'],
              ),
              path: e['path'],
              uniqueid: e['uniqueid'],
            ),
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
      'manga': data.manga.toJson(),
      'chapters': data.chapters
          .map(
            (e) => {
              'chapter': e.chapter.toJson(),
              'status': e.status.name,
              'uniqueid': e.uniqueid,
              'path': e.path,
            },
          )
          .toList(),
    };
  }
}
