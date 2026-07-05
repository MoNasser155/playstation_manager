import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../domain/usecases/get_home_data_usecase.dart';
import 'home_state.dart';

class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final _getHomeDataUseCase = sl<GetHomeDataUseCase>();

  Future<void> getHomeData() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getHomeDataUseCase();
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
      },
      (homeModel) {
        safeEmit(
          state.copyWith(status: StateStatus.success, homeModel: homeModel),
        );
      },
    );
  }
}
