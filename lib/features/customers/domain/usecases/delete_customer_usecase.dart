import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../repositories/customers_repository.dart';

class DeleteCustomerUseCase {
  final _repository = sl<CustomersRepository>();

  Future<Either<Failure, bool>> call(String uuid) async {
    return await _repository.deleteCustomer(uuid);
  }
}
