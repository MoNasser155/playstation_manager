import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/supplier_model.dart';
import '../repositories/suppliers_repository.dart';

class AddSupplierUseCase {
  final _repository = sl<SuppliersRepository>();

  AddSupplierUseCase();

  Future<Either<Failure, int>> call(SupplierModel supplier) async {
    return await _repository.addSupplier(supplier);
  }
}
