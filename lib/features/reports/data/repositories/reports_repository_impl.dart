import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_local_data_source.dart';
import '../models/reports_model.dart';

class ReportsRepositoryImpl with ErrorHandler implements ReportsRepository {
  ReportsLocalDataSource get _dataSource => sl<ReportsLocalDataSource>();

  @override
  Future<Either<Failure, ReportModel>> getReportData(
    ReportFilter filter,
  ) async {
    return wrapBoxOperationSync(() => _dataSource.getReportData(filter));
  }
}
