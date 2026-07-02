import 'package:fpdart/fpdart.dart';
import 'package:local_erp_system/features/customers/domain/repositories/customers_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/customer_model.dart';

class AddCustomerUseCase {
  final _repository = sl<CustomersRepository>();

  Future<Either<Failure, int>> call(CustomerModel customer) async {
    return await _repository.addCustomer(customer);
  }
}


