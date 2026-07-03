import '../../core/shared/di.dart';
import 'data/datasources/invoice_local_data_source.dart';
import 'data/repositories/invoice_repository_impl.dart';
import 'domain/repositories/invoice_repository.dart';
import 'domain/usecases/create_invoice_usecase.dart';
import 'domain/usecases/get_all_invoice_models_usecase.dart';
import 'domain/usecases/get_all_invoices_usecase.dart';
import 'domain/usecases/get_active_sessions_usecase.dart';
import 'domain/usecases/get_active_session_for_device_usecase.dart';
import 'domain/usecases/start_device_session_usecase.dart';
import 'domain/usecases/update_session_items_usecase.dart';
import 'domain/usecases/end_device_session_usecase.dart';
import 'presentation/cubits/cubit/invoice_cubit.dart';

initInvoicesDI() {
  //data source
  sl.registerLazySingleton<InvoiceLocalDataSource>(
    () => InvoiceLocalDataSourceImpl(),
  );

  //repository
  sl.registerLazySingleton<InvoiceRepository>(() => InvoiceRepositoryImpl());

  //use cases
  sl.registerLazySingleton<GetAllInvoiceModelsUseCase>(
    () => GetAllInvoiceModelsUseCase(),
  );
  sl.registerLazySingleton<CreateInvoiceUseCase>(
    () => CreateInvoiceUseCase(),
  );
  sl.registerLazySingleton<GetAllInvoicesUseCase>(
    () => GetAllInvoicesUseCase(),
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
  sl.registerFactory<InvoiceCubit>(() => InvoiceCubit());
}

Future<void> resetInvoicesDI() async {
  await sl.resetLazySingleton<InvoiceLocalDataSource>();
  await sl.resetLazySingleton<InvoiceRepository>();
  await sl.resetLazySingleton<GetAllInvoiceModelsUseCase>();
  await sl.resetLazySingleton<CreateInvoiceUseCase>();
  await sl.resetLazySingleton<GetAllInvoicesUseCase>();
  await sl.resetLazySingleton<GetActiveSessionsUseCase>();
  await sl.resetLazySingleton<GetActiveSessionForDeviceUseCase>();
  await sl.resetLazySingleton<StartDeviceSessionUseCase>();
  await sl.resetLazySingleton<UpdateSessionItemsUseCase>();
  await sl.resetLazySingleton<EndDeviceSessionUseCase>();
}