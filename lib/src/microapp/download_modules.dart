import 'package:flutter/src/widgets/framework.dart';
import 'package:manga_easy/main.dart';
import 'package:manga_easy/modules/downloads/domain/repositories/download_repository_inter.dart';
import 'package:manga_easy/modules/downloads/infra/api_download.dart';
import 'package:manga_easy/modules/downloads/infra/download_repository.dart';
import 'package:manga_easy/modules/downloads/presenter/controllers/all_downloads_controller.dart';
import 'package:manga_easy/modules/downloads/presenter/controllers/downloads_controller.dart';
import 'package:manga_easy/modules/downloads/presenter/ui/pages/all_downloads_page.dart';
import 'package:manga_easy/modules/downloads/presenter/ui/pages/downloads_page.dart';
import 'package:manga_easy_routes/manga_easy_routes.dart';

class DownloadModule extends MicroApp {
  @override
  Map<String, Widget> routers = {
    DonwloadsPage.router: const DonwloadsPage(),
    AllDownloadsPage.router: const AllDownloadsPage()
  };

  @override
  void registerDependencies() {
    //register cases
    di.registerFactory(() => ApiDownload());
    //register repositories
    di.registerFactory<IDownloadRepositor>(() => DownloadRepository(di()));
    //register controllers
    di.registerFactory(
      () => DonwloadsController(
        di(),
        di(),
        di(),
      ),
    );
    di.registerFactory(
      () => AllDownloadsController(
        download: di(),
        detalhesMangaRepo: di(),
        historicoRepo: di(),
        mangaRepo: di(),
        downloadRepositor: di(),
        mangaMapper: di(),
      ),
    );
  }
}
