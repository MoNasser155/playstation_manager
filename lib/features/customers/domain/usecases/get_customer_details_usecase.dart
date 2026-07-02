
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/customer_details_model.dart';
import '../repositories/customers_repository.dart';

class GetCustomerDetailsUseCase {
  final _repository = sl<CustomersRepository>();

  Future<Either<Failure, CustomerDetailsModel>> call(String uuid) async {
    return await _repository.getCustomerDetails(uuid);
  }
}