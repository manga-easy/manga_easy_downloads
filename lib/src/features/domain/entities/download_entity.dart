// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    // if (chapters.any((e) => e.status == Status.doing)) {
    //   return Status.doing;
    // }
    if (chapters.any((e) => e.status == Status.todo)) {
      return Status.todo;
    }
    return Status.done;
  }

  DownloadEntity copyWith({
    String? id,
    String? uniqueid,
    int? idUser,
    String? folder,
    Manga? manga,
    List<ChapterStatus>? chapters,
    DateTime? createAt,
  }) {
    return DownloadEntity(
      id: id ?? this.id,
      uniqueid: uniqueid ?? this.uniqueid,
      idUser: idUser ?? this.idUser,
      folder: folder ?? this.folder,
      manga: manga ?? this.manga,
      chapters: chapters ?? this.chapters,
      createAt: createAt ?? this.createAt,
    );
  }
}

enum Status { todo, doing, paused, done, error }

class ChapterStatus {
  final Chapter chapter;
  Status status;

  ChapterStatus(this.chapter, this.status);
}
