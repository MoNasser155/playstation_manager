import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/customer_details_model.dart';
import '../../data/models/customer_model.dart';

abstract class CustomersRepository {
  Future<Either<Failure, List<CustomerModel>>> getAllCustomers();
  Future<Either<Failure, int>> addCustomer(CustomerModel customer);
  Future<Either<Failure, bool>> deleteCustomer(String uuid);
  Future<Either<Failure, int>> updateCustomer(CustomerModel customer);
  Future<Either<Failure, CustomerDetailsModel>> getCustomerDetails(String uuid);
}
