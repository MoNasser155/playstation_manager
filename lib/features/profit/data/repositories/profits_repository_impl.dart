import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/repositories/profits_repository.dart';
import '../datasources/profit_local_data_source.dart';
import '../models/profits_model.dart';

class ProfitsRepositoryImpl with ErrorHandler implements ProfitsRepository {
  final _localDataSource = sl<ProfitLocalDataSource>();

  ProfitsRepositoryImpl();
  @override
  Future<Either<Failure, ProfitsModel>> getProfit({
    DateTime? from,
    DateTime? to,
  }) async {
    return wrapBoxOperationSync(
      () => _localDataSource.getProfit(from: from, to: to),
    );
  }
}
