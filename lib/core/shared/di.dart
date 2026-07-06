import 'package:get_it/get_it.dart';

import '../../features/auth/di.dart';
import '../../features/devices/di.dart';
import '../../features/home/di.dart';
import '../../features/sessions/di.dart';
import '../../features/main_view/di.dart';
import '../../features/profit/di.dart';
import '../../features/storage/di.dart';
import '../../features/transactions/di.dart';
import '../../features/reports/di.dart';
import '../objectbox/objectbox_store.dart';
import 'cubits/global_theming_cubit.dart';

final sl = GetIt.instance;
initDI() async {
  await sharedDI();
  initAuthDI();
  initHomeDI();
  initMainViewDI();
  initStorageDI();
  initDevicesDI();
  initSessionsDI();
  initTransactionsDI();
  initProfitDI();
  initReportsDI();
}

sharedDI() async {
  // ObjectBox
  final objectBoxStore = await ObjectBoxStore.instance;
  sl.registerSingleton<ObjectBoxStore>(objectBoxStore);

  // cubits
  sl.registerFactory<GlobalThemingCubit>(() => GlobalThemingCubit());
}
