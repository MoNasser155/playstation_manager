part of 'invoice_cubit.dart';

class InvoiceState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final PaymentType paymentType;
  final GetInvoiceModels invoiceModels;
  final CustomerModel? selectedCustomer;
  final StorageModel? selectedStorageItem;
  final String invoiceUuid;
  final List<CreateInvoiceModel> invoiceList;
  final List<ItemsInvoice> invoiceItems;
  final double totalInvoice;
  final double currentInputTotal;
  final double cashPaid; 

  const InvoiceState({
    required this.status,
    this.errMessage,
    required this.paymentType,
    required this.invoiceModels,
    this.selectedCustomer,
    this.selectedStorageItem,
    required this.invoiceUuid,
    required this.invoiceList,
    required this.invoiceItems,
    required this.totalInvoice,
    required this.currentInputTotal,
    required this.cashPaid,
  });

  factory InvoiceState.initial() {
    return InvoiceState(
      status: StateStatus.initial,
      paymentType: PaymentType.cash,
      invoiceModels: GetInvoiceModels(
        customers: [],
        storageItems: [],
        warnings: [],
      ),
      selectedCustomer: null,
      selectedStorageItem: null,
      invoiceUuid: const Uuid().v4(),
      invoiceList: [],
      invoiceItems: [],
      totalInvoice: 0,
      currentInputTotal: 0,
      cashPaid: 0,
    );
  }

  /// Amount not yet paid (only meaningful for "later" payment type)
  double get laterPaid => (totalInvoice - cashPaid).clamp(0, double.infinity);

  bool get canAddItem => selectedStorageItem != null && currentInputTotal > 0;

  bool get canSaveInvoice =>
      selectedCustomer != null &&
      invoiceItems.isNotEmpty &&
      totalInvoice > 0 &&
      (paymentType == PaymentType.cash ||
          (paymentType == PaymentType.later && cashPaid >= 0));

  InvoiceState copyWith({
    StateStatus? status,
    String? errMessage,
    PaymentType? paymentType,
    GetInvoiceModels? invoiceModels,
    CustomerModel? selectedCustomer,
    StorageModel? selectedStorageItem,
    bool clearSelectedStorageItem = false,
    String? invoiceUuid,
    List<CreateInvoiceModel>? invoiceList,
    List<ItemsInvoice>? invoiceItems,
    double? totalInvoice,
    double? currentInputTotal,
    double? cashPaid,
  }) {
    return InvoiceState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      paymentType: paymentType ?? this.paymentType,
      invoiceModels: invoiceModels ?? this.invoiceModels,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      selectedStorageItem:
          clearSelectedStorageItem
              ? null
              : selectedStorageItem ?? this.selectedStorageItem,
      invoiceUuid: invoiceUuid ?? this.invoiceUuid,
      invoiceList: invoiceList ?? this.invoiceList,
      invoiceItems: invoiceItems ?? this.invoiceItems,
      totalInvoice: totalInvoice ?? this.totalInvoice,
      currentInputTotal: currentInputTotal ?? this.currentInputTotal,
      cashPaid: cashPaid ?? this.cashPaid,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    paymentType,
    invoiceModels,
    selectedCustomer,
    selectedStorageItem,
    invoiceUuid,
    invoiceList,
    invoiceItems,
    totalInvoice,
    currentInputTotal,
    cashPaid,
  ];
}
