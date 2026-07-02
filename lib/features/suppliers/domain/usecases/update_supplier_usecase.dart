import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/supplier_model.dart';
import '../repositories/suppliers_repository.dart';

class UpdateSupplierUseCase {
  final _repository = sl<SuppliersRepository>();
  UpdateSupplierUseCase();

  Future<Either<Failure, int>> call(SupplierModel supplier) async {
    return await _repository.updateSupplier(supplier);
  }
}
