import '../../core/shared/di.dart';
import 'data/datasources/storage_locale_data_source.dart';
import 'data/repositories/storage_repository_impl.dart';
import 'domain/repositories/storage_repository.dart';
import 'domain/usecases/add_storage_item_usecase.dart';
import 'domain/usecases/delete_storage_item_usecase.dart';
import 'domain/usecases/get_all_storage_items_usecase.dart';
import 'domain/usecases/get_storage_item_by_uuid_usecase.dart';
import 'domain/usecases/update_storage_item_usecase.dart';
import 'presentation/cubits/add_storage_item_cubit/add_storage_item_cubit.dart';
import 'presentation/cubits/storage_item_details_cubit/storage_item_details_cubit.dart';
import 'presentation/cubits/storage_cubit/storage_cubit.dart';

initStorageDI() {
  // Data sources
  sl.registerLazySingleton<StorageLocaleDataSource>(
    () => StorageLocaleDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<StorageRepository>(() => StorageRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => GetAllStorageItemsUseCase());
  sl.registerLazySingleton(() => AddStorageItemUseCase());
  sl.registerLazySingleton(() => DeleteStorageItemUseCase());
  sl.registerLazySingleton(() => UpdateStorageItemUseCase());
  sl.registerLazySingleton(() => GetStorageItemByUuidUseCase());

  // Cubits
  sl.registerFactory<StorageCubit>(() => StorageCubit());
  sl.registerFactory<AddStorageItemCubit>(() => AddStorageItemCubit());
  sl.registerFactory<StorageItemDetailsCubit>(() => StorageItemDetailsCubit());
}

Future<void> resetStorageDI() async {
  await sl.resetLazySingleton<StorageLocaleDataSource>();
  await sl.resetLazySingleton<StorageRepository>();
  await sl.resetLazySingleton<GetAllStorageItemsUseCase>();
  await sl.resetLazySingleton<AddStorageItemUseCase>();
  await sl.resetLazySingleton<DeleteStorageItemUseCase>();
  await sl.resetLazySingleton<UpdateStorageItemUseCase>();
  await sl.resetLazySingleton<GetStorageItemByUuidUseCase>();
}
