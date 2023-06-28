import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class DownloadEntity {
  String? id;
  String uniqueid;
  int idUser;
  String folder;
  Manga manga;
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
  });

  Status get status {
    if (chapters.map((e) => e.status).toList().contains(Status.doing)) {
      return Status.doing;
    }
    if (chapters.any((e) => e.status == Status.todo)) {
      return Status.todo;
    }

    return Status.done;
  }
}

enum Status { todo, doing, paused, done, error }

class ChapterStatus {
  final Chapter chapter;
  Status status;

  ChapterStatus(this.chapter, this.status);
}
