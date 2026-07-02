import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/profits_model.dart';
import '../repositories/profits_repository.dart';

class GetFilteredProfitsUsecase {
  final _repository = sl<ProfitsRepository>();

  Future<Either<Failure, ProfitsModel>> getProfit({
    DateTime? from,
    DateTime? to,
  }) async {
    return await _repository.getProfit(from: from, to: to);
  }
}
