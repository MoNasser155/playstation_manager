import '../../core/shared/di.dart';
import 'data/datasources/reports_local_data_source.dart';
import 'data/repositories/reports_repository_impl.dart';
import 'domain/repositories/reports_repository.dart';
import 'domain/usecases/get_report_data_usecase.dart';
import 'presentation/cubits/cubit/reports_cubit.dart';

initReportsDI() {
  // data source
  sl.registerLazySingleton<ReportsLocalDataSource>(
    () => ReportsLocalDataSourceImpl(),
  );

  // repositories
  sl.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(),
  );

  // use cases
  sl.registerLazySingleton<GetReportDataUsecase>(
    () => GetReportDataUsecase(),
  );

  // cubits
  sl.registerFactory<ReportsCubit>(() => ReportsCubit());
}

Future<void> resetReportsDI() async {
  await sl.resetLazySingleton<ReportsLocalDataSource>();
  await sl.resetLazySingleton<ReportsRepository>();
  await sl.resetLazySingleton<GetReportDataUsecase>();
}
