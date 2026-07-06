import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/reports_model.dart';
import '../repositories/reports_repository.dart';

class GetReportDataUsecase {
  ReportsRepository get _repository => sl<ReportsRepository>();

  Future<Either<Failure, ReportModel>> call(ReportFilter filter) async {
    return await _repository.getReportData(filter);
  }
}
