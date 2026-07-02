import 'package:get_it/get_it.dart';

import '../../features/auth/di.dart';
import '../../features/customers/di.dart';
import '../../features/home/di.dart';
import '../../features/invoices/di.dart';
import '../../features/main_view/di.dart';
import '../../features/profit/di.dart';
import '../../features/storage/di.dart';
import '../../features/suppliers/di.dart';
import '../../features/transactions/di.dart';
import '../objectbox/objectbox_store.dart';
import 'cubits/global_theming_cubit.dart';

final sl = GetIt.instance;
initDI() async {
  await sharedDI();
  initAuthDI();
  initHomeDI();
  initMainViewDI();
  initSuppliersDI();
  initStorageDI();
  initCustomersDI();
  initInvoicesDI();
  initTransactionsDI();
  initProfitDI();
}

sharedDI() async {
  // ObjectBox
  final objectBoxStore = await ObjectBoxStore.instance;
  sl.registerSingleton<ObjectBoxStore>(objectBoxStore);

  // cubits
  sl.registerFactory<GlobalThemingCubit>(() => GlobalThemingCubit());
}
