import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/supplier_details_model.dart';
import '../../data/models/supplier_model.dart';

abstract class SuppliersRepository {
  Future<Either<Failure, List<SupplierModel>>> getAllSuppliers();
  Future<Either<Failure, int>> addSupplier(SupplierModel supplier);
  Future<Either<Failure, bool>> deleteSupplier(String uuid);
  Future<Either<Failure, int>> updateSupplier(SupplierModel supplier);
  Future<Either<Failure, SupplierDetailsModel>> getSupplierDetails(String uuid);
}
