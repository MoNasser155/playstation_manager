import 'package:local_erp_system/core/shared/di.dart';

import 'data/datasources/transactions_local_data_source.dart';
import 'data/repositories/transactions_repository_impl.dart';
import 'domain/repositories/transactions_repository.dart';
import 'domain/usecases/create_transaction_usecase.dart';
import 'domain/usecases/get_all_transactions_usecase.dart';
import 'domain/usecases/get_all_user_transactions_usecase.dart';
import 'domain/usecases/get_transactions_by_type_usecase.dart';
import 'presentation/cubits/cubit/add_transaction_cubit.dart';
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
  sl.registerLazySingleton<CreateTransactionUseCase>(
    () => CreateTransactionUseCase(),
  );
  sl.registerLazySingleton<GetAllTransactionsUseCase>(
    () => GetAllTransactionsUseCase(),
  );
  sl.registerLazySingleton<GetAllUserTransactionsUseCase>(
    () => GetAllUserTransactionsUseCase(),
  );
  sl.registerLazySingleton<GetTransactionsByTypeUseCase>(
    () => GetTransactionsByTypeUseCase(),
  );

  //cubit
  sl.registerFactory<TransactionsCubit>(() => TransactionsCubit());
  sl.registerFactory<AddTransactionCubit>(() => AddTransactionCubit());
}

Future<void> resetTransactionsDI() async {
  await sl.resetLazySingleton<TransactionsLocalDataSource>();
  await sl.resetLazySingleton<TransactionsRepository>();
  await sl.resetLazySingleton<CreateTransactionUseCase>();
  await sl.resetLazySingleton<GetAllTransactionsUseCase>();
  await sl.resetLazySingleton<GetAllUserTransactionsUseCase>();
  await sl.resetLazySingleton<GetTransactionsByTypeUseCase>();
}
