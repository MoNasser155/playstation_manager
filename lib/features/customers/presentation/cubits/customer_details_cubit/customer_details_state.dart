part of 'customer_details_cubit.dart';

class CustomerDetailsState extends Equatable {
  final StateStatus status;
  final StateStatus transactionsStatus;
  final StateStatus invoicesStatus;
  final String customerUuid;
  final String? errMessage;
  final CustomerDetailsModel customerDetails;
  final List<TransactionModel> transactions;
  final List<CreateInvoiceModel> invoices;
  final int currentTapIndex;

  const CustomerDetailsState({
    required this.status,
    required this.transactionsStatus,
    required this.invoicesStatus,
    required this.transactions,
    required this.customerUuid,
    required this.invoices,
    required this.errMessage,
    required this.customerDetails,
    required this.currentTapIndex,
  });

  factory CustomerDetailsState.initial() {
    return CustomerDetailsState(
      status: StateStatus.initial,
      transactionsStatus: StateStatus.initial,
      invoicesStatus: StateStatus.initial,
      customerUuid: '',
      transactions: [],
      invoices: [],
      errMessage: null,
      customerDetails: CustomerDetailsModel.initial(),
      currentTapIndex: 0,
    );
  }

  CustomerDetailsState copyWith({
    StateStatus? status,
    StateStatus? transactionsStatus,
    List<TransactionModel>? transactions,
    StateStatus? invoicesStatus,
    List<CreateInvoiceModel>? invoices,
    String? customerUuid,
    String? errMessage,
    CustomerDetailsModel? customerDetails,
    int? currentTapIndex,
  }) {
    return CustomerDetailsState(
      status: status ?? this.status,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      invoicesStatus: invoicesStatus ?? this.invoicesStatus,
      transactions: transactions ?? this.transactions,
      invoices: invoices ?? this.invoices,
      customerUuid: customerUuid ?? this.customerUuid,
      errMessage: errMessage ?? this.errMessage,
      customerDetails: customerDetails ?? this.customerDetails,
      currentTapIndex: currentTapIndex ?? this.currentTapIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    transactionsStatus,
    invoicesStatus,
    customerUuid,
    transactions.length,
    invoices,
    errMessage,
    customerDetails,
    currentTapIndex,
  ];
}
