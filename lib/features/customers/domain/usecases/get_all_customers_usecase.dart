import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/customer_model.dart';
import '../repositories/customers_repository.dart';

class GetAllCustomersUseCase {
  final _repository = sl<CustomersRepository>();

  Future<Either<Failure, List<CustomerModel>>> call() async {
    return await _repository.getAllCustomers();
  }
}
