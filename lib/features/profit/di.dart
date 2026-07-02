import '../../core/shared/di.dart';
import 'data/datasources/profit_local_data_source.dart';
import 'data/repositories/profits_repository_impl.dart';
import 'domain/repositories/profits_repository.dart';
import 'domain/usecases/get_filtered_profits_usecase.dart';
import 'presentation/cubits/cubit/profit_cubit.dart';

initProfitDI() {
  //data source
  sl.registerLazySingleton<ProfitLocalDataSource>(
    () => ProfitLocalDataSourceImpl(),
  );

  //repositories
  sl.registerLazySingleton<ProfitsRepository>(() => ProfitsRepositoryImpl());

  // usecases
  sl.registerLazySingleton<GetFilteredProfitsUsecase>(
    () => GetFilteredProfitsUsecase(),
  );

  //cubits
  sl.registerFactory<ProfitCubit>(() => ProfitCubit());
}

Future<void> resetProfitDI() async {
  await sl.resetLazySingleton<ProfitLocalDataSource>();
  await sl.resetLazySingleton<ProfitsRepository>();
  await sl.resetLazySingleton<GetFilteredProfitsUsecase>();
}
