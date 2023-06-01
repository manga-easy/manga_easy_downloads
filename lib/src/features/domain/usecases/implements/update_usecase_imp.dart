import 'package:manga_easy_downloads/src/features/domain/entities/download_entity.dart';
import 'package:manga_easy_downloads/src/features/domain/repositories/download_repository.dart';
import 'package:manga_easy_downloads/src/features/domain/usecases/update_usecase.dart';

class UpdateUsecaseImp implements UpdateUsecase {
  final DownloadRepository repository;

  UpdateUsecaseImp(this.repository);

  @override
  Future<void> update({required DownloadEntity data, required String id}) async {
    return await repository.update(data: data, id: id);
  }
}
