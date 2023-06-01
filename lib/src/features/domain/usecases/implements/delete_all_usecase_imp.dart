import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_all_usecase.dart';

class DeleteAllUsecaseImp implements DeleteAllUsecase {
  final DownloadRepository repository;

  DeleteAllUsecaseImp(this.repository);

  @override
  Future<void> deleteAll() async {
    await repository.deleteAll();
  }
}
