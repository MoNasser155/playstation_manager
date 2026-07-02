import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/customer_model.dart';
import '../repositories/customers_repository.dart';

class UpdateCustomerUseCase {
  final _repository = sl<CustomersRepository>();

  Future<Either<Failure, int>> call(CustomerModel customer) async {
    return await _repository.updateCustomer(customer);
  }
}