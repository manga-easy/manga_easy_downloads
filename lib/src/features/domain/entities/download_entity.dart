import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadEntity {
  String? id;
  String uniqueid;
  int idUser;
  String folder;
  Manga manga;
  Status status;
  List<ChapterStatus> chapters;
  DateTime createAt;

  DownloadEntity({
    this.id,
    required this.uniqueid,
    required this.idUser,
    required this.createAt,
    required this.manga,
    required this.folder,
    required this.chapters,
    required this.status,
  });
}

enum Status { todo, doing, done, error }

class ChapterStatus {
  final Chapter chapter;
  final Status status;

  ChapterStatus(this.chapter, this.status);
}
