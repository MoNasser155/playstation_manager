part of 'invoice_cubit.dart';

class InvoiceState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final GetInvoiceModels invoiceModels;
  final StorageModel? selectedStorageItem;
  final String invoiceUuid;
  final List<CreateInvoiceModel> invoiceList;
  final List<ItemsInvoice> invoiceItems;
  final double totalInvoice;
  final double currentInputTotal;

  // Devices & Sessions fields
  final List<DeviceModel> devices;
  final DeviceModel? selectedDevice;
  final CreateInvoiceModel? activeSessionInvoice;
  final Duration sessionDuration;
  final double sessionCost;
  final bool isSessionActive;

  const InvoiceState({
    required this.status,
    this.errMessage,
    required this.invoiceModels,
    this.selectedStorageItem,
    required this.invoiceUuid,
    required this.invoiceList,
    required this.invoiceItems,
    required this.totalInvoice,
    required this.currentInputTotal,
    required this.devices,
    this.selectedDevice,
    this.activeSessionInvoice,
    required this.sessionDuration,
    required this.sessionCost,
    required this.isSessionActive,
  });

  factory InvoiceState.initial() {
    return InvoiceState(
      status: StateStatus.initial,
      invoiceModels: GetInvoiceModels(
        storageItems: [],
        warnings: [],
      ),
      selectedStorageItem: null,
      invoiceUuid: const Uuid().v4(),
      invoiceList: [],
      invoiceItems: [],
      totalInvoice: 0,
      currentInputTotal: 0,
      devices: const [],
      selectedDevice: null,
      activeSessionInvoice: null,
      sessionDuration: Duration.zero,
      sessionCost: 0.0,
      isSessionActive: false,
    );
  }

  bool get canAddItem => selectedStorageItem != null && currentInputTotal > 0;

  bool get canSaveInvoice =>
      !isSessionActive &&
      invoiceItems.isNotEmpty &&
      totalInvoice > 0;

  InvoiceState copyWith({
    StateStatus? status,
    String? errMessage,
    GetInvoiceModels? invoiceModels,
    StorageModel? selectedStorageItem,
    bool clearSelectedStorageItem = false,
    String? invoiceUuid,
    List<CreateInvoiceModel>? invoiceList,
    List<ItemsInvoice>? invoiceItems,
    double? totalInvoice,
    double? currentInputTotal,
    List<DeviceModel>? devices,
    DeviceModel? selectedDevice,
    bool clearSelectedDevice = false,
    CreateInvoiceModel? activeSessionInvoice,
    bool clearActiveSessionInvoice = false,
    Duration? sessionDuration,
    double? sessionCost,
    bool? isSessionActive,
  }) {
    return InvoiceState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      invoiceModels: invoiceModels ?? this.invoiceModels,
      selectedStorageItem:
          clearSelectedStorageItem
              ? null
              : selectedStorageItem ?? this.selectedStorageItem,
      invoiceUuid: invoiceUuid ?? this.invoiceUuid,
      invoiceList: invoiceList ?? this.invoiceList,
      invoiceItems: invoiceItems ?? this.invoiceItems,
      totalInvoice: totalInvoice ?? this.totalInvoice,
      currentInputTotal: currentInputTotal ?? this.currentInputTotal,
      devices: devices ?? this.devices,
      selectedDevice: clearSelectedDevice ? null : selectedDevice ?? this.selectedDevice,
      activeSessionInvoice: clearActiveSessionInvoice ? null : activeSessionInvoice ?? this.activeSessionInvoice,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      sessionCost: sessionCost ?? this.sessionCost,
      isSessionActive: isSessionActive ?? this.isSessionActive,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    invoiceModels,
    selectedStorageItem,
    invoiceUuid,
    invoiceList,
    invoiceItems,
    totalInvoice,
    currentInputTotal,
    devices,
    selectedDevice,
    activeSessionInvoice,
    sessionDuration,
    sessionCost,
    isSessionActive,
  ];
}
