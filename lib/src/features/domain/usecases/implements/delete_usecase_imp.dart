import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/delete_usecase.dart';

class DeleteUsecaseImp implements DeleteUsecase {
  final DownloadRepository repository;

  DeleteUsecaseImp(this.repository);

  @override
  Future<void> delete({required String id}) async {
    await repository.delete(id: id);
  }
}
