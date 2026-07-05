import 'package:equatable/equatable.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../data/models/home_model.dart';

class HomeState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final HomeModel? homeModel;

  const HomeState({
    required this.status,
    this.errMessage,
    this.homeModel,
  });

  factory HomeState.initial() {
    return const HomeState(
      status: StateStatus.initial,
      errMessage: null,
      homeModel: null,
    );
  }

  HomeState copyWith({
    StateStatus? status,
    String? errMessage,
    HomeModel? homeModel,
  }) {
    return HomeState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      homeModel: homeModel ?? this.homeModel,
    );
  }

  @override
  List<Object?> get props => [status, errMessage, homeModel];
}
