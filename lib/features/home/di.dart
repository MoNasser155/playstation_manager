import '../../core/shared/di.dart';
import 'presentation/cubits/add_user_cubit/add_user_cubit.dart';

initHomeDI() {
  sl.registerFactory<AddUserCubit>(() => AddUserCubit());
}
