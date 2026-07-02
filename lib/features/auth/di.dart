import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/local_auth_server.dart';
import '../../core/services/machine_id_service.dart';
import '../../core/shared/di.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_current_user_usecase.dart';
import 'domain/usecases/google_sign_in_usecase.dart';
import 'domain/usecases/sign_out_usecase.dart';
import 'presentation/cubit/auth_cubit.dart';

void initAuthDI() {
  // External dependency
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Core services
  sl.registerLazySingleton<MachineIdService>(() => MachineIdService());
  sl.registerLazySingleton<LocalAuthServer>(() => LocalAuthServer());

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  //UseCases
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(),
  );
  sl.registerLazySingleton<GoogleSignInUseCase>(() => GoogleSignInUseCase());
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase());

  // Cubit
  sl.registerFactory<AuthCubit>(() => AuthCubit());
}
