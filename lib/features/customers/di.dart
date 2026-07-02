import '../../core/shared/di.dart';
import 'data/datasources/customers_locale_data_source.dart';
import 'data/repositories/customer_repository_impl.dart';
import 'domain/repositories/customers_repository.dart';
import 'domain/usecases/add_customer_usecase.dart';
import 'domain/usecases/delete_customer_usecase.dart';
import 'domain/usecases/get_all_customers_usecase.dart';
import 'domain/usecases/get_customer_details_usecase.dart';
import 'domain/usecases/update_customer_usecase.dart';
import 'presentation/cubits/add_customer_cubit/add_customer_cubit.dart';
import 'presentation/cubits/customer_details_cubit/customer_details_cubit.dart';
import 'presentation/cubits/customers_cubit/customer_cubit.dart';

initCustomersDI() {
  // data sources
  sl.registerLazySingleton<CustomersLocaleDatasource>(
    () => CustomersLocaleDatasourceImpl(),
  );

  // repositories
  sl.registerLazySingleton<CustomersRepository>(() => CustomerRepositoryImpl());

  // usecases
  sl.registerLazySingleton<GetAllCustomersUseCase>(
    () => GetAllCustomersUseCase(),
  );
  sl.registerLazySingleton<AddCustomerUseCase>(() => AddCustomerUseCase());
  sl.registerLazySingleton<DeleteCustomerUseCase>(
    () => DeleteCustomerUseCase(),
  );
  sl.registerLazySingleton<GetCustomerDetailsUseCase>(
    () => GetCustomerDetailsUseCase(),
  );
  sl.registerLazySingleton<UpdateCustomerUseCase>(
    () => UpdateCustomerUseCase(),
  );

  // cubits
  sl.registerFactory<CustomersCubit>(() => CustomersCubit());
  sl.registerFactory<AddCustomerCubit>(() => AddCustomerCubit());
  sl.registerFactory<CustomerDetailsCubit>(() => CustomerDetailsCubit());
}

Future<void> resetCustomersDI() async {
  await sl.resetLazySingleton<CustomersLocaleDatasource>();
  await sl.resetLazySingleton<CustomersRepository>();
  await sl.resetLazySingleton<GetAllCustomersUseCase>();
  await sl.resetLazySingleton<AddCustomerUseCase>();
  await sl.resetLazySingleton<DeleteCustomerUseCase>();
  await sl.resetLazySingleton<GetCustomerDetailsUseCase>();
  await sl.resetLazySingleton<UpdateCustomerUseCase>();
}
