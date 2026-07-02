part of 'add_customer_cubit.dart';

class AddCustomerState extends Equatable {
  final StateStatus status;
  final String? errMessage;

  const AddCustomerState({
    required this.status,
    this.errMessage,
  });

  AddCustomerState copyWith({
    StateStatus? status,
    String? errMessage,
  }) {
    return AddCustomerState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
    );
  }

  factory AddCustomerState.initial() =>
      const AddCustomerState(status: StateStatus.initial);

  @override
  List<Object?> get props => [status, errMessage];
}
