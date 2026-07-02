import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/profits_model.dart';

abstract class ProfitsRepository {
  Future<Either<Failure, ProfitsModel>> getProfit({
    DateTime? from,
    DateTime? to,
  });
}
