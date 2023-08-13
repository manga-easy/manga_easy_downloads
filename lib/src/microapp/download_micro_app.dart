import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/data/mappers/download_mapper.dart';
import 'package:manga_easy_downloads/src/features/data/repositories/download_repository_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/chapter_download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/pages/chapters_download_page.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/pages/download_page.dart';
import 'package:manga_easy_routes/manga_easy_routes.dart';

class DownloadMicroApp extends MicroApp {
  GetIt getIt = GetIt.instance;
  @override
  Map<String, Widget> routers = {
    DownloadPage.route: const DownloadPage(),
    ChapterDownloadPage.route: const ChapterDownloadPage(),
  };

  @override
  void registerDependencies() {
    //mapper
    getIt.registerFactory(() => DownloadMapper());
    //repositories
    getIt.registerFactory<DownloadRepository>(() => DownloadRepositoryImp(
          getIt(),
          getIt(),
        ));

    //Service
    getIt.registerLazySingleton(
      () => ServiceDownload(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    );

    //Controller
    getIt.registerFactory(
      () => DownloadController(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    );
    getIt.registerFactory(
      () => ChapterDownloadController(
        getIt(),
        getIt(),
      ),
    );
  }
}
