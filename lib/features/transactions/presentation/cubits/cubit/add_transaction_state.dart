part of 'add_transaction_cubit.dart';

class AddTransactionState extends Equatable {
  final StateStatus status;
  final StateStatus customerStatus;
  final StateStatus supplierStatus;
  final String? errMessage;
  final CustomerModel? customer;
  final SupplierModel? supplier;
  final UserType userType;
  final List<SupplierModel> suppliers;

  final List<CustomerModel> customers;
  final int tapIndex;

  const AddTransactionState({
    required this.status,
    required this.customerStatus,
    required this.supplierStatus,
    this.errMessage,
    this.customer,
    this.supplier,
    required this.userType,
    required this.suppliers,
    required this.customers,
    required this.tapIndex,
  });

  AddTransactionState copyWith({
    StateStatus? status,
    StateStatus? customerStatus,
    StateStatus? supplierStatus,
    String? errMessage,
    CustomerModel? customer,
    SupplierModel? supplier,
    UserType? userType,
    List<SupplierModel>? suppliers,
    List<CustomerModel>? customers,
    int? tapIndex,
  }) {
    return AddTransactionState(
      status: status ?? this.status,
      customerStatus: customerStatus ?? this.customerStatus,
      supplierStatus: supplierStatus ?? this.supplierStatus,
      errMessage: errMessage ?? this.errMessage,
      customer: customer ?? this.customer,
      supplier: supplier ?? this.supplier,
      userType: userType ?? this.userType,
      suppliers: suppliers ?? this.suppliers,
      customers: customers ?? this.customers,
      tapIndex: tapIndex ?? this.tapIndex,
    );
  }

  factory AddTransactionState.initial() {
    return AddTransactionState(
      status: StateStatus.initial,
      customerStatus: StateStatus.initial,
      supplierStatus: StateStatus.initial,
      errMessage: null,
      customer: null,
      supplier: null,
      userType: UserType.customer,
      suppliers: [],
      customers: [],
      tapIndex: 0,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    customer,
    supplier,
    userType,
    suppliers,
    customers,
    tapIndex,
  ];
}
