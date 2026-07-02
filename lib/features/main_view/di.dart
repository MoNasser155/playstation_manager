import '../../core/shared/di.dart';
import 'presentation/cubits/main_view_cubit/main_view_cubit.dart';

initMainViewDI() {
  //cubits
    sl.registerFactory<MainViewCubit>(() => MainViewCubit());
}
