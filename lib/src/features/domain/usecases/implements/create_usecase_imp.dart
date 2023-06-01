import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/create_usecase.dart';

class CreateUsecaseImp implements CreateUsecase {
  final DownloadRepository repository;

  CreateUsecaseImp(this.repository);

  @override
  Future<String> create({required DownloadEntity data}) async {
    return await repository.create(data: data);
  }
}
