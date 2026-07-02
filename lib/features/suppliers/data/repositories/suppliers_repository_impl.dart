import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../datasources/suppliers_local_data_source.dart';
import '../models/supplier_model.dart';
import '../../domain/repositories/suppliers_repository.dart';
import '../models/supplier_details_model.dart';

class SuppliersRepositoryImpl with ErrorHandler implements SuppliersRepository {
  final _localDataSource = sl<SuppliersLocalDataSource>();

  SuppliersRepositoryImpl();

  @override
  Future<Either<Failure, List<SupplierModel>>> getAllSuppliers() async {
    return wrapBoxOperationSync(() => _localDataSource.getAllSuppliers());
  }

  @override
  Future<Either<Failure, int>> addSupplier(SupplierModel supplier) async {
    return wrapBoxOperationSync(() => _localDataSource.addSupplier(supplier));
  }

  @override
  Future<Either<Failure, bool>> deleteSupplier(String uuid) async {
    return wrapBoxOperationSync(() => _localDataSource.deleteSupplier(uuid));
  }

  @override
  Future<Either<Failure, int>> updateSupplier(SupplierModel supplier) async {
    return wrapBoxOperationSync(
      () => _localDataSource.updateSupplier(supplier),
    );
  }

  @override
  Future<Either<Failure, SupplierDetailsModel>> getSupplierDetails(
    String uuid,
  ) async {
    return wrapBoxOperationSync(
      () => _localDataSource.getSupplierDetails(uuid),
    );
  }
}
