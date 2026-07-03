import '../../core/shared/di.dart';
import 'data/datasources/device_local_data_source.dart';
import 'data/repositories/device_repository_impl.dart';
import 'domain/repositories/device_repository.dart';
import 'domain/usecases/add_device_usecase.dart';
import 'domain/usecases/delete_device_usecase.dart';
import 'domain/usecases/get_all_devices_usecase.dart';
import 'domain/usecases/get_device_by_uuid_usecase.dart';
import 'domain/usecases/update_device_usecase.dart';
import 'presentation/cubits/add_device_cubit/add_device_cubit.dart';
import 'presentation/cubits/devices_cubit/devices_cubit.dart';

void initDevicesDI() {
  // Data sources
  sl.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllDevicesUseCase());
  sl.registerLazySingleton(() => AddDeviceUseCase());
  sl.registerLazySingleton(() => DeleteDeviceUseCase());
  sl.registerLazySingleton(() => UpdateDeviceUseCase());
  sl.registerLazySingleton(() => GetDeviceByUuidUseCase());

  // Cubits
  sl.registerFactory<DevicesCubit>(() => DevicesCubit());
  sl.registerFactory<AddDeviceCubit>(() => AddDeviceCubit());
}
