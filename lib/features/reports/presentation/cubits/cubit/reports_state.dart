import 'package:equatable/equatable.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../data/models/reports_model.dart';

class ReportsState extends Equatable {
  final StateStatus status;
  final ReportFilter reportFilter;
  final ReportModel? reportData;
  final String? errorMessage;

  const ReportsState({
    required this.status,
    required this.reportFilter,
    this.reportData,
    this.errorMessage,
  });

  factory ReportsState.initial() {
    return const ReportsState(
      status: StateStatus.initial,
      reportFilter: ReportFilter.today,
      reportData: null,
      errorMessage: null,
    );
  }

  ReportsState copyWith({
    StateStatus? status,
    ReportFilter? reportFilter,
    ReportModel? reportData,
    String? errorMessage,
  }) {
    return ReportsState(
      status: status ?? this.status,
      reportFilter: reportFilter ?? this.reportFilter,
      reportData: reportData ?? this.reportData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reportFilter, reportData, errorMessage];
}
