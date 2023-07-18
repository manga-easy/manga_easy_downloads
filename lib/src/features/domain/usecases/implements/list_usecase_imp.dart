import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';

class ListUsecaseImp implements ListUsecase {
  final DownloadRepository repository;

  ListUsecaseImp(this.repository);

  @override
  Future<List<DownloadEntity>> list() async {
    return await repository.list();
    //   DownloadEntity(
    //     uniqueid: "MentallyBroken",
    //     idUser: 1,
    //     createAt: DateTime.now(),
    //     manga: Manga(
    //       capa: "http://api.lucas-cm.com.br/mentally-broken/capa.png",
    //       href: "easy-scanMentallyBroken",
    //       title: "Mentally Broken",
    //       idHost: 7,
    //       uniqueid: "MentallyBroken",
    //     ),
    //     folder: '/storage/emulated/0/Documents/Manga Easy',
    //     chapters: [
    //       ChapterStatus(
    //         Chapter(
    //           title: '1',
    //           href: "easy-scanMentallyBroken1",
    //           id: "MentallyBroken1",
    //           imagens: [
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/1.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/2.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/3.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/4.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/5.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/6.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/7.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/8.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/9.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/01/10.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //           ],
    //           number: 1,
    //           date: "2023-06-16 16:49:58.507446",
    //         ),
    //         Status.todo,
    //       ),
    //        ChapterStatus(
    //         Chapter(
    //           title: '2',
    //           href: "easy-scanMentallyBroken2",
    //           id: "MentallyBroken2",
    //           imagens: [
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/1.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/2.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/3.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/4.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/5.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/6.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/7.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/8.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/9.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/02/10.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //           ],
    //           number: 2,
    //           date: "2023-06-16 16:49:58.507446",
    //         ),
    //         Status.todo,
    //       ),
    //        ChapterStatus(
    //         Chapter(
    //           title: '3',
    //           href: "easy-scanMentallyBroken3",
    //           id: "MentallyBroken3",
    //           imagens: [
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/1.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/2.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/3.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/4.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/5.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/6.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/7.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/8.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/9.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/03/10.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //           ],
    //           number: 3,
    //           date: "2023-06-16 16:49:58.507446",
    //         ),
    //         Status.todo,
    //       ),
    //        ChapterStatus(
    //         Chapter(
    //           title: '4',
    //           href: "easy-scanMentallyBroken4",
    //           id: "MentallyBroken4",
    //           imagens: [
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/1.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/2.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/3.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/4.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/5.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/6.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/7.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/8.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/9.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mentally-broken/04/10.jpg",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //           ],
    //           number: 4,
    //           date: "2023-06-16 16:49:58.507446",
    //         ),
    //         Status.done,
    //       ),
    //     ],
    //   ),
    //   DownloadEntity(
    //     uniqueid: "mantodeguerra",
    //     idUser: 1,
    //     createAt: DateTime.now(),
    //     manga: Manga(
    //       capa: "http://api.lucas-cm.com.br/mantodeguerra/thumb.gif",
    //       href: "easy-scanmantodeguerra",
    //       title: "Manto de Guerra",
    //       idHost: 7,
    //       uniqueid: "mantodeguerra",
    //     ),
    //     folder: '/storage/emulated/0/Documents/Manga Easy',
    //     chapters: [
    //       ChapterStatus(
    //         Chapter(
    //           title: '1',
    //           href: "easy-scanmantodeguerra1",
    //           id: "mantodeguerra1",
    //           imagens: [
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/1-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/2-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/3-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/4-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/5-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/6-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/7-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/8-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/9-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //             ImageChapter(
    //               src: "http://api.lucas-cm.com.br/mantodeguerra/1/10-1.png",
    //               state: 1,
    //               tipo: TypeFonte.image,
    //             ),
    //           ],
    //           number: 1.0,
    //           date: "2023-06-25 17:44:43.508779",
    //         ),
    //         Status.todo,
    //       ),
    //     ],
    //   ),
    // ];
  }
}
