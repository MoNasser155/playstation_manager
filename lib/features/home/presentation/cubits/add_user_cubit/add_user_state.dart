part of 'add_user_cubit.dart';

class AddUserState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final UserType userType;

  const AddUserState({
    required this.status,
    this.errMessage,
    required this.userType,
  });

  AddUserState copyWith({
    StateStatus? status,
    String? errMessage,
    UserType? userType,
  }) {
    return AddUserState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      userType: userType ?? this.userType,
    );
  }

  factory AddUserState.initial() => const AddUserState(
    status: StateStatus.initial,
    userType: UserType.customer,
  );

  @override
  List<Object?> get props => [status, errMessage, userType];
}
