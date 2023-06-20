import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_downloads/src/features/data/mappers/download_mapper.dart';
import 'package:manga_easy_downloads/src/features/data/repositories/download_repository_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/services/service_download.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/implements/create_usecase_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/implements/delete_all_usecase_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/implements/delete_usecase_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/implements/get_usecase_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/implements/list_usecase_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/implements/update_usecase_imp.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';
import 'package:manga_easy_downloads/src/features/presenter/controllers/download_controller.dart';
import 'package:manga_easy_downloads/src/features/presenter/ui/pages/download_page.dart';
import 'package:manga_easy_routes/manga_easy_routes.dart';

class DownloadMicroApp extends MicroApp {
  GetIt getIt = GetIt.instance;
  @override
  Map<String, Widget> routers = {
    DownloadPage.route: const DownloadPage(),
  };

  @override
  void registerDependencies() {
    //mapper
    getIt.registerFactory(() => DownloadMapper());
    //repositories
    getIt.registerFactory<DownloadRepository>(
        () => DownloadRepositoryImp(getIt()));
    //usecases
    getIt.registerFactory<CreateUsecase>(() => CreateUsecaseImp(getIt()));
    getIt.registerFactory<UpdateUsecase>(() => UpdateUsecaseImp(getIt()));
    getIt.registerFactory<DeleteUsecase>(() => DeleteUsecaseImp(getIt()));
    getIt.registerFactory<DeleteAllUsecase>(() => DeleteAllUsecaseImp(getIt()));
    getIt.registerFactory<GetUsecase>(() => GetUsecaseImp(getIt()));
    getIt.registerFactory<ListUsecase>(() => ListUsecaseImp(getIt()));

//Service
    getIt.registerFactory(() => ServiceDownload(
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
        ));

//Controller
    getIt.registerFactory(
      () => DownloadController(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    );
  }
}
