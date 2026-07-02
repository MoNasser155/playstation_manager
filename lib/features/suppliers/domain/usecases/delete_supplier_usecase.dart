import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../repositories/suppliers_repository.dart';

class DeleteSupplierUseCase {
  final SuppliersRepository _repository = sl<SuppliersRepository>();

  DeleteSupplierUseCase();

  Future<Either<Failure, bool>> call(String uuid) async {
    return await _repository.deleteSupplier(uuid);
  }
}
