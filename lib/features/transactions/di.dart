import 'package:local_erp_system/core/shared/di.dart';

import 'data/datasources/transactions_local_data_source.dart';
import 'data/repositories/transactions_repository_impl.dart';
import 'domain/repositories/transactions_repository.dart';
import 'domain/usecases/get_all_transactions_usecase.dart';
import 'presentation/cubits/transactions_cubit/transactions_cubit.dart';

initTransactionsDI() {
  //data source
  sl.registerLazySingleton<TransactionsLocalDataSource>(
    () => TransactionsLocalDataSourceImpl(),
  );

  //repository
  sl.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(),
  );

  //usecase
  sl.registerLazySingleton<GetAllTransactionsUseCase>(
    () => GetAllTransactionsUseCase(),
  );

  //cubit
  sl.registerFactory<TransactionsCubit>(() => TransactionsCubit());
}

Future<void> resetTransactionsDI() async {
  await sl.resetLazySingleton<TransactionsLocalDataSource>();
  await sl.resetLazySingleton<TransactionsRepository>();
  await sl.resetLazySingleton<GetAllTransactionsUseCase>();
}
