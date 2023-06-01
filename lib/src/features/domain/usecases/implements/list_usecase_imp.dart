import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/list_usecase.dart';

class ListUsecaseImp implements ListUsecase {
  final DownloadRepository repository;

  ListUsecaseImp(this.repository);

  @override
  Future<List<DownloadEntity>> list() async {
    return await repository.list();
  }
}
