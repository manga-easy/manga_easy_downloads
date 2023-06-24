import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ListUsecaseImp implements ListUsecase {
  final DownloadRepository repository;

  ListUsecaseImp(this.repository);

  @override
  Future<List<DownloadEntity>> list() async {
    return [  DownloadEntity(
        uniqueid: "MentallyBroken",
        idUser: 1,
        createAt: DateTime.now(),
        manga: Manga(
          capa: "http://api.lucas-cm.com.br/mentally-broken/capa.png",
          href: "easy-scanMentallyBroken",
          title: "Mentally Broken",
          idHost: 7,
          uniqueid: "MentallyBroken",
        ),
        folder: '/storage/emulated/0/Documents/Manga Easy',
        chapters: [
          ChapterStatus(
            Chapter(
              title: '1',
              href: "easy-scanMentallyBroken1",
              id: "MentallyBroken1",
              imagens: [
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/1.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/2.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/3.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/4.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/5.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/6.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/7.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
                ImageChapter(
                  src: "http://api.lucas-cm.com.br/mentally-broken/01/8.jpg",
                  state: 1,
                  tipo: TypeFonte.image,
                ),
              ],
              number: 1,
              date: "2023-06-16 16:49:58.507446",
            ),
            Status.todo,
          ),
        ],
      ),];
  }
}
