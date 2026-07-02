import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/supplier_model.dart';
import '../repositories/suppliers_repository.dart';

class GetAllSuppliersUseCase {
  final _repository = sl<SuppliersRepository>();
  GetAllSuppliersUseCase();

  Future<Either<Failure, List<SupplierModel>>> call() async {
    return await _repository.getAllSuppliers();
  }
}
