part of 'add_transaction_cubit.dart';

class AddTransactionState extends Equatable {
  final StateStatus status;
  final StateStatus customerStatus;
  final String? errMessage;
  final CustomerModel? customer;
  final UserType userType;

  final List<CustomerModel> customers;
  final int tapIndex;

  const AddTransactionState({
    required this.status,
    required this.customerStatus,
    this.errMessage,
    this.customer,
    required this.userType,
    required this.customers,
    required this.tapIndex,
  });

  AddTransactionState copyWith({
    StateStatus? status,
    StateStatus? customerStatus,
    String? errMessage,
    CustomerModel? customer,
    UserType? userType,
    List<CustomerModel>? customers,
    int? tapIndex,
  }) {
    return AddTransactionState(
      status: status ?? this.status,
      customerStatus: customerStatus ?? this.customerStatus,
      errMessage: errMessage ?? this.errMessage,
      customer: customer ?? this.customer,
      userType: userType ?? this.userType,
      customers: customers ?? this.customers,
      tapIndex: tapIndex ?? this.tapIndex,
    );
  }

  factory AddTransactionState.initial() {
    return AddTransactionState(
      status: StateStatus.initial,
      customerStatus: StateStatus.initial,
      errMessage: null,
      customer: null,
      userType: UserType.customer,
      customers: [],
      tapIndex: 0,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    customer,
    userType,
    customers,
    tapIndex,
  ];
}
