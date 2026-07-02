part of 'customer_cubit.dart';

class CustomersState extends Equatable {
  final StateStatus status;
  final List<CustomerModel> customers;
  final List<CustomerModel> filteredCustomers;
  final String? errMessage;

  const CustomersState({
    required this.status,
    required this.customers,
    required this.filteredCustomers,
    this.errMessage,
  });

  CustomersState copyWith({
    StateStatus? status,
    List<CustomerModel>? customers,
    List<CustomerModel>? filteredCustomers,
    String? errMessage,
  }) {
    return CustomersState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      filteredCustomers: filteredCustomers ?? this.filteredCustomers,
      errMessage: errMessage ?? this.errMessage,
    );
  }

  factory CustomersState.initial() => const CustomersState(
      status: StateStatus.initial, customers: [], filteredCustomers: []);

  @override
  List<Object?> get props => [status, customers, filteredCustomers, errMessage];
}
