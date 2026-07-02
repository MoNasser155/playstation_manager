import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/repositories/customers_repository.dart';
import '../datasources/customers_locale_data_source.dart';
import '../models/customer_details_model.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl with ErrorHandler implements CustomersRepository {
  final _localeDatasource = sl<CustomersLocaleDatasource>();

  CustomerRepositoryImpl();

  @override
  Future<Either<Failure, List<CustomerModel>>> getAllCustomers() async {
    return wrapBoxOperationSync(() => _localeDatasource.getAllCustomers());
  }

  @override
  Future<Either<Failure, bool>> deleteCustomer(String uuid) async {
    return wrapBoxOperationSync(() => _localeDatasource.deleteCustomer(uuid));
  }

  @override
  Future<Either<Failure, int>> addCustomer(CustomerModel customer) async {
    return wrapBoxOperationSync(() => _localeDatasource.addCustomer(customer));
  }

  @override
  Future<Either<Failure, CustomerDetailsModel>> getCustomerDetails(
    String uuid,
  ) async {
    return wrapBoxOperationSync(
      () => _localeDatasource.getCustomerDetails(uuid),
    );
  }

  @override
  Future<Either<Failure, int>> updateCustomer(CustomerModel customer) async {
    return wrapBoxOperationSync(
      () => _localeDatasource.updateCustomer(customer),
    );
  }
}
