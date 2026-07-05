import '../../core/shared/di.dart';
import 'data/datasources/home_local_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_home_data_usecase.dart';

initHomeDI() {
  // data source
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  // repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(),
  );

  // usecase
  sl.registerLazySingleton<GetHomeDataUseCase>(
    () => GetHomeDataUseCase(),
  );
}
