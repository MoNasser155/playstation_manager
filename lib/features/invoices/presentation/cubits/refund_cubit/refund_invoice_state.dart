part of 'refund_invoice_cubit.dart';

class RefundInvoiceState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final List<CustomerModel> customers;
  final CustomerModel? selectedCustomer;
  final List<CreateInvoiceModel> customerInvoices;
  final CreateInvoiceModel? selectedInvoice;
  final List<ItemsInvoice> adjustedItems;
  final Map<String, double> originalQuantities;
  final Map<String, double> originalPrices;
  final double cashPaid;
  final double totalInvoice;
  final double totalRefundAmount;

  const RefundInvoiceState({
    required this.status,
    this.errMessage,
    required this.customers,
    this.selectedCustomer,
    required this.customerInvoices,
    this.selectedInvoice,
    required this.adjustedItems,
    required this.originalQuantities,
    required this.originalPrices,
    required this.cashPaid,
    required this.totalInvoice,
    required this.totalRefundAmount,
  });

  factory RefundInvoiceState.initial() {
    return const RefundInvoiceState(
      status: StateStatus.initial,
      errMessage: null,
      customers: [],
      selectedCustomer: null,
      customerInvoices: [],
      selectedInvoice: null,
      adjustedItems: [],
      originalQuantities: {},
      originalPrices: {},
      cashPaid: 0,
      totalInvoice: 0,
      totalRefundAmount: 0,
    );
  }

  double get newLaterPaid {
    if (selectedInvoice == null) return 0.0;
    return (totalInvoice - cashPaid).clamp(0, double.infinity);
  }

  bool get canSaveRefund {
    if (selectedCustomer == null || selectedInvoice == null || status == StateStatus.loading) {
      return false;
    }
    // There must be some items refunded/adjusted (refund total > 0 or profit changed or quantities reduced)
    final totalDiff = selectedInvoice!.totalInvoice - totalInvoice;
    final cashPaidDiff = selectedInvoice!.cashPaid - cashPaid;
    return totalDiff > 0 || cashPaidDiff != 0;
  }

  RefundInvoiceState copyWith({
    StateStatus? status,
    String? errMessage,
    List<CustomerModel>? customers,
    CustomerModel? selectedCustomer,
    bool clearSelectedCustomer = false,
    List<CreateInvoiceModel>? customerInvoices,
    CreateInvoiceModel? selectedInvoice,
    bool clearSelectedInvoice = false,
    List<ItemsInvoice>? adjustedItems,
    Map<String, double>? originalQuantities,
    Map<String, double>? originalPrices,
    double? cashPaid,
    double? totalInvoice,
    double? totalRefundAmount,
  }) {
    return RefundInvoiceState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      customers: customers ?? this.customers,
      selectedCustomer: clearSelectedCustomer ? null : (selectedCustomer ?? this.selectedCustomer),
      customerInvoices: customerInvoices ?? this.customerInvoices,
      selectedInvoice: clearSelectedInvoice ? null : (selectedInvoice ?? this.selectedInvoice),
      adjustedItems: adjustedItems ?? this.adjustedItems,
      originalQuantities: originalQuantities ?? this.originalQuantities,
      originalPrices: originalPrices ?? this.originalPrices,
      cashPaid: cashPaid ?? this.cashPaid,
      totalInvoice: totalInvoice ?? this.totalInvoice,
      totalRefundAmount: totalRefundAmount ?? this.totalRefundAmount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errMessage,
        customers,
        selectedCustomer,
        customerInvoices,
        selectedInvoice,
        adjustedItems,
        originalQuantities,
        originalPrices,
        cashPaid,
        totalInvoice,
        totalRefundAmount,
      ];
}
