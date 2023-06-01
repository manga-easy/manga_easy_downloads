import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/get_usecase.dart';

class GetUsecaseImp implements GetUsecase {
  final DownloadRepository repository;

  GetUsecaseImp(this.repository);

  @override
  Future<DownloadEntity> get({required String id}) async {
    return await repository.get(id: id);
  }
}
