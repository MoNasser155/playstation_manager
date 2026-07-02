import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/supplier_details_model.dart';
import '../repositories/suppliers_repository.dart';

class GetSupplierDetailsUseCase {
  final _repository = sl<SuppliersRepository>();

  Future<Either<Failure, SupplierDetailsModel>> call(String uuid) =>
      _repository.getSupplierDetails(uuid);
}
