part of 'supplier_details_cubit.dart';

class SupplierDetailsState extends Equatable {
  final StateStatus status;
  final StateStatus transactionsState;
  final String? errMessage;
  final SupplierDetailsModel supplierDetails;
  final List<TransactionModel> transactions;
  final String supplierUuid;

  const SupplierDetailsState({
    required this.status,
    required this.errMessage,
    required this.transactionsState,
    required this.supplierDetails,
    required this.transactions,
    required this.supplierUuid,
  });

  factory SupplierDetailsState.initial() {
    return SupplierDetailsState(
      status: StateStatus.initial,
      errMessage: null,
      transactionsState: StateStatus.initial,
      supplierDetails: SupplierDetailsModel.initial(),
      transactions: [],
      supplierUuid: "",
    );
  }

  SupplierDetailsState copyWith({
    StateStatus? status,
    String? errMessage,
    StateStatus? transactionsState,
    SupplierDetailsModel? supplierDetails,
    List<TransactionModel>? transactions,
    String? supplierUuid,
  }) {
    return SupplierDetailsState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      transactionsState: transactionsState ?? this.transactionsState,
      supplierDetails: supplierDetails ?? this.supplierDetails,
      transactions: transactions ?? this.transactions,
      supplierUuid: supplierUuid ?? this.supplierUuid,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    transactionsState,
    supplierDetails,
    transactions,
    supplierUuid,
  ];
}
