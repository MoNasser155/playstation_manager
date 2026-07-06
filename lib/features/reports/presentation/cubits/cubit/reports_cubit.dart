import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../reports/data/models/reports_model.dart';
import '../../../../reports/domain/usecases/get_report_data_usecase.dart';
import 'reports_state.dart';

class ReportsCubit extends BaseCubit<ReportsState> {
  ReportsCubit() : super(ReportsState.initial());

  static ReportsCubit get(context) => BlocProvider.of<ReportsCubit>(context);

  GetReportDataUsecase get _getReportDataUsecase => sl<GetReportDataUsecase>();

  void getReportData({ReportFilter? filter}) async {
    final activeFilter = filter ?? state.reportFilter;
    safeEmit(
      state.copyWith(status: StateStatus.loading, reportFilter: activeFilter),
    );

    final result = await _getReportDataUsecase(activeFilter);

    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (reportsData) {
        safeEmit(
          state.copyWith(status: StateStatus.success, reportData: reportsData),
        );
      },
    );
  }

  void changeFilter(ReportFilter filter) {
    getReportData(filter: filter);
  }
}
