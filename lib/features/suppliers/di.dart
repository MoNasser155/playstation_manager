import '../../../core/shared/di.dart';
import 'data/datasources/suppliers_local_data_source.dart';
import 'data/repositories/suppliers_repository_impl.dart';
import 'domain/repositories/suppliers_repository.dart';
import 'domain/usecases/add_supplier_usecase.dart';
import 'domain/usecases/delete_supplier_usecase.dart';
import 'domain/usecases/get_all_suppliers_usecase.dart';
import 'domain/usecases/get_supplier_details_usecase.dart';
import 'domain/usecases/update_supplier_usecase.dart';
import 'presentation/cubits/add_supplier_cubit/add_supplier_cubit.dart';
import 'presentation/cubits/supplier_details_cubit/supplier_details_cubit.dart';
import 'presentation/cubits/suppliers_cubit/suppliers_cubit.dart';

void initSuppliersDI() {
  // Data sources
  sl.registerLazySingleton<SuppliersLocalDataSource>(
    () => SuppliersLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<SuppliersRepository>(
    () => SuppliersRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton<GetAllSuppliersUseCase>(
    () => GetAllSuppliersUseCase(),
  );
  sl.registerLazySingleton<AddSupplierUseCase>(() => AddSupplierUseCase());
  sl.registerLazySingleton<DeleteSupplierUseCase>(
    () => DeleteSupplierUseCase(),
  );
  sl.registerLazySingleton<UpdateSupplierUseCase>(
    () => UpdateSupplierUseCase(),
  );
  sl.registerLazySingleton<GetSupplierDetailsUseCase>(
    () => GetSupplierDetailsUseCase(),
  );

  // Cubits
  sl.registerFactory<SuppliersCubit>(() => SuppliersCubit());
  sl.registerFactory<AddSupplierCubit>(() => AddSupplierCubit());
  sl.registerFactory<SupplierDetailsCubit>(() => SupplierDetailsCubit());
}

Future<void> resetSuppliersDI() async {
  await sl.resetLazySingleton<SuppliersLocalDataSource>();
  await sl.resetLazySingleton<SuppliersRepository>();
  await sl.resetLazySingleton<GetAllSuppliersUseCase>();
  await sl.resetLazySingleton<AddSupplierUseCase>();
  await sl.resetLazySingleton<DeleteSupplierUseCase>();
  await sl.resetLazySingleton<UpdateSupplierUseCase>();
  await sl.resetLazySingleton<GetSupplierDetailsUseCase>();
}
