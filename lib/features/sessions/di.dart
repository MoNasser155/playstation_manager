import '../../core/shared/di.dart';
import 'data/datasources/session_local_data_source.dart';
import 'data/repositories/session_repository_impl.dart';
import 'domain/repositories/session_repository.dart';
import 'domain/usecases/create_session_usecase.dart';
import 'domain/usecases/get_all_session_models_usecase.dart';
import 'domain/usecases/get_all_sessions_usecase.dart';
import 'domain/usecases/get_active_sessions_usecase.dart';
import 'domain/usecases/get_active_session_for_device_usecase.dart';
import 'domain/usecases/start_device_session_usecase.dart';
import 'domain/usecases/update_session_items_usecase.dart';
import 'domain/usecases/end_device_session_usecase.dart';
import 'presentation/cubits/cubit/session_cubit.dart';

initSessionsDI() {
  //data source
  sl.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSourceImpl(),
  );

  //repository
  sl.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl());

  //use cases
  sl.registerLazySingleton<GetAllSessionModelsUseCase>(
    () => GetAllSessionModelsUseCase(),
  );
  sl.registerLazySingleton<CreateSessionUseCase>(
    () => CreateSessionUseCase(),
  );
  sl.registerLazySingleton<GetAllSessionsUseCase>(
    () => GetAllSessionsUseCase(),
  );
  sl.registerLazySingleton<GetActiveSessionsUseCase>(
    () => GetActiveSessionsUseCase(),
  );
  sl.registerLazySingleton<GetActiveSessionForDeviceUseCase>(
    () => GetActiveSessionForDeviceUseCase(),
  );
  sl.registerLazySingleton<StartDeviceSessionUseCase>(
    () => StartDeviceSessionUseCase(),
  );
  sl.registerLazySingleton<UpdateSessionItemsUseCase>(
    () => UpdateSessionItemsUseCase(),
  );
  sl.registerLazySingleton<EndDeviceSessionUseCase>(
    () => EndDeviceSessionUseCase(),
  );

  //cubit
  sl.registerFactory<SessionCubit>(() => SessionCubit());
}

Future<void> resetSessionsDI() async {
  await sl.resetLazySingleton<SessionLocalDataSource>();
  await sl.resetLazySingleton<SessionRepository>();
  await sl.resetLazySingleton<GetAllSessionModelsUseCase>();
  await sl.resetLazySingleton<CreateSessionUseCase>();
  await sl.resetLazySingleton<GetAllSessionsUseCase>();
  await sl.resetLazySingleton<GetActiveSessionsUseCase>();
  await sl.resetLazySingleton<GetActiveSessionForDeviceUseCase>();
  await sl.resetLazySingleton<StartDeviceSessionUseCase>();
  await sl.resetLazySingleton<UpdateSessionItemsUseCase>();
  await sl.resetLazySingleton<EndDeviceSessionUseCase>();
}