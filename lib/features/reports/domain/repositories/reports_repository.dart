import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/reports_model.dart';

abstract class ReportsRepository {
  Future<Either<Failure, ReportModel>> getReportData(ReportFilter filter);
}
