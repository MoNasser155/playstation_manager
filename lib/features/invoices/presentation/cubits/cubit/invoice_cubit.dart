import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enums/device_status.dart';
import '../../../../../core/enums/payment_type.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../customers/data/models/customer_model.dart';
import '../../../../devices/data/models/device_model.dart';
import '../../../../devices/domain/usecases/get_all_devices_usecase.dart';
import '../../../../storage/data/models/storage_model.dart';
import '../../../data/models/create_invoice_model.dart';
import '../../../data/models/get_invoice_models.dart';
import '../../../domain/usecases/create_invoice_usecase.dart';
import '../../../domain/usecases/end_device_session_usecase.dart';
import '../../../domain/usecases/get_active_session_for_device_usecase.dart';
import '../../../domain/usecases/get_all_invoice_models_usecase.dart';
import '../../../domain/usecases/start_device_session_usecase.dart';
import '../../../domain/usecases/update_session_items_usecase.dart';

part 'invoice_state.dart';

class InvoiceCubit extends BaseCubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceState.initial()) {
    setControllersValue();
  }

  static InvoiceCubit get(context) => BlocProvider.of<InvoiceCubit>(context);

  final _getAllInvoiceModelsUsecase = sl<GetAllInvoiceModelsUseCase>();
  final _createInvoiceUseCase = sl<CreateInvoiceUseCase>();
  final _getAllDevicesUseCase = sl<GetAllDevicesUseCase>();
  final _getActiveSessionForDeviceUseCase = sl<GetActiveSessionForDeviceUseCase>();
  final _startDeviceSessionUseCase = sl<StartDeviceSessionUseCase>();
  final _updateSessionItemsUseCase = sl<UpdateSessionItemsUseCase>();
  final _endDeviceSessionUseCase = sl<EndDeviceSessionUseCase>();

  final sellPriceController = TextEditingController(text: '0');
  final quantityController = TextEditingController(text: '0');
  final paidCashController = TextEditingController(text: '0');

  Timer? _sessionTimer;

  void setControllersValue() {
    sellPriceController.text =
        state.selectedStorageItem?.sellPrice.toStringAsFixed(2) ?? '';
    quantityController.text =
        state.selectedStorageItem?.quantity.toStringAsFixed(2) ?? '';
  }

  init(BuildContext context, {CustomerModel? customer, DeviceModel? device}) {
    safeEmit(state.copyWith(status: StateStatus.loading));

    _getAllInvoiceModels(context);
    _getAllDevices();
    if (customer != null) setCustomer(customer);
    if (device != null) {
      selectDevice(device);
    }
  }

  void refresh(BuildContext context) {
    _resetInvoice(context);
  }

  Future<void> _getAllInvoiceModels(BuildContext context) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getAllInvoiceModelsUsecase();
    result.fold(
      (failure) {
        CustomSnackBar.top(context: context, msg: failure.message);
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (invoiceModels) {
        if (invoiceModels.warnings.isNotEmpty) {
          for (AppException warning in invoiceModels.warnings) {
            CustomSnackBar.top(context: context, msg: warning.messageKey);
          }
        }
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            invoiceModels: invoiceModels,
          ),
        );
      },
    );
  }

  Future<void> _getAllDevices() async {
    final result = await _getAllDevicesUseCase();
    result.fold(
      (_) {},
      (devicesList) {
        safeEmit(state.copyWith(devices: devicesList));
      },
    );
  }

  Future<void> selectDevice(DeviceModel? device) async {
    _sessionTimer?.cancel();
    if (device == null) {
      safeEmit(state.copyWith(
        clearSelectedDevice: true,
        clearActiveSessionInvoice: true,
        sessionDuration: Duration.zero,
        sessionCost: 0.0,
        isSessionActive: false,
        invoiceItems: [],
        totalInvoice: 0.0,
        invoiceUuid: const Uuid().v4(),
      ));
      return;
    }

    final result = await _getActiveSessionForDeviceUseCase(device.id!);
    result.fold(
      (failure) {
        safeEmit(state.copyWith(
          selectedDevice: device,
          clearActiveSessionInvoice: true,
          sessionDuration: Duration.zero,
          sessionCost: 0.0,
          isSessionActive: false,
          invoiceItems: [],
          totalInvoice: 0.0,
          invoiceUuid: const Uuid().v4(),
        ));
      },
      (activeSession) {
        if (activeSession != null) {
          final items = activeSession.items.toList();
          final start = activeSession.sessionStartDate ?? DateTime.now();
          final duration = DateTime.now().difference(start);
          final cost = (duration.inSeconds / 3600.0) * activeSession.hourlyRate;
          final itemsTotal = items.fold<double>(0.0, (s, e) => s + e.totalItemPrice);

          safeEmit(state.copyWith(
            selectedDevice: device,
            activeSessionInvoice: activeSession,
            sessionDuration: duration,
            sessionCost: cost,
            isSessionActive: true,
            invoiceItems: items,
            invoiceUuid: activeSession.uuid,
            totalInvoice: cost + itemsTotal,
          ));

          _startSessionTimer();
        } else {
          safeEmit(state.copyWith(
            selectedDevice: device,
            clearActiveSessionInvoice: true,
            sessionDuration: Duration.zero,
            sessionCost: 0.0,
            isSessionActive: false,
            invoiceItems: [],
            totalInvoice: 0.0,
            invoiceUuid: const Uuid().v4(),
          ));
        }
      },
    );
  }

  Future<void> startSession(BuildContext context) async {
    final device = state.selectedDevice;
    if (device == null || device.status != DeviceStatus.available) return;

    final newInvoice = CreateInvoiceModel.create(
      uuid: const Uuid().v4(),
      totalInvoice: 0.0,
      cashPaid: 0.0,
      laterPaid: 0.0,
      invoiceDate: DateTime.now(),
      paymentType: PaymentType.cash,
      isSession: true,
      sessionStartDate: DateTime.now(),
      hourlyRate: device.hourlyRate,
    );
    newInvoice.device.target = device;

    final result = await _startDeviceSessionUseCase(
      sessionInvoice: newInvoice,
      device: device,
    );

    result.fold(
      (failure) {
        if (context.mounted) {
          CustomSnackBar.top(context: context, msg: failure.message);
        }
      },
      (id) async {
        final updatedDevice = device.copyWith(status: DeviceStatus.reserved);
        await _getAllDevices();
        await selectDevice(updatedDevice);

        if (context.mounted) {
          CustomSnackBar.top(
            context: context,
            msg: LocaleKeys.sessionStarted,
            color: Colors.green,
          );
        }
      },
    );
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isSessionActive && state.activeSessionInvoice != null) {
        final start = state.activeSessionInvoice!.sessionStartDate ?? DateTime.now();
        final duration = DateTime.now().difference(start);
        final cost = (duration.inSeconds / 3600.0) * state.activeSessionInvoice!.hourlyRate;
        final itemsTotal = state.invoiceItems.fold<double>(0.0, (s, e) => s + e.totalItemPrice);

        safeEmit(state.copyWith(
          sessionDuration: duration,
          sessionCost: cost,
          totalInvoice: cost + itemsTotal,
        ));
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _persistActiveSessionItems() async {
    if (state.isSessionActive && state.activeSessionInvoice != null) {
      await _updateSessionItemsUseCase(
        sessionUuid: state.activeSessionInvoice!.uuid,
        items: state.invoiceItems,
      );
    }
  }

  Future<void> endSession(BuildContext context) async {
    if (!state.isSessionActive || state.activeSessionInvoice == null) return;
    final device = state.selectedDevice;
    if (device == null) return;

    _sessionTimer?.cancel();
    final activeInvoice = state.activeSessionInvoice!;
    final total = state.totalInvoice;

    final completedInvoice = CreateInvoiceModel(
      id: activeInvoice.id,
      uuid: activeInvoice.uuid,
      totalInvoice: total,
      cashPaid: total,
      laterPaid: 0.0,
      invoiceDate: DateTime.now(),
      paymentIndex: PaymentType.cash.index,
      isSession: false,
      sessionStartDate: activeInvoice.sessionStartDate,
      hourlyRate: activeInvoice.hourlyRate,
    );
    completedInvoice.device.target = device;
    completedInvoice.items.addAll(state.invoiceItems);

    final result = await _endDeviceSessionUseCase(
      completedInvoice: completedInvoice,
      device: device,
    );

    result.fold(
      (failure) {
        if (context.mounted) {
          CustomSnackBar.top(context: context, msg: failure.message);
        }
      },
      (_) async {
        if (context.mounted) {
          CustomSnackBar.top(
            context: context,
            msg: LocaleKeys.sessionEnded,
            color: Colors.green,
          );
        }

        await _getAllDevices();
        await selectDevice(null);
      },
    );
  }

  void setCustomer(CustomerModel customer) {
    if (customer != state.selectedCustomer) {
      safeEmit(state.copyWith(selectedCustomer: customer));
    }
  }

  void changePayType(PaymentType paymentType) {
    if (paymentType != state.paymentType) {
      paidCashController.clear();
      safeEmit(state.copyWith(paymentType: paymentType, cashPaid: 0));
    }
  }

  void selectItem(StorageModel? item) {
    if (item == null || item == state.selectedStorageItem) return;
    sellPriceController.text = item.sellPrice.toStringAsFixed(2);
    double qty = double.tryParse(quantityController.text.trim()) ?? 0;
    if (qty > item.quantity) {
      qty = item.quantity;
      quantityController.text =
          qty % 1 == 0 ? qty.toInt().toString() : qty.toString();
    }
    safeEmit(
      state.copyWith(
        selectedStorageItem: item,
        currentInputTotal: item.sellPrice * qty,
      ),
    );
  }

  void updateInputTotal([BuildContext? context]) {
    final price = double.tryParse(sellPriceController.text.trim()) ?? 0;
    double qty = double.tryParse(quantityController.text.trim()) ?? 0;

    if (state.selectedStorageItem != null) {
      final maxQty = state.selectedStorageItem!.quantity;
      if (qty > maxQty) {
        qty = maxQty;
        quantityController.text = qty.toStringAsFixed(2);
        quantityController.selection = TextSelection.fromPosition(
          TextPosition(offset: quantityController.text.length),
        );
        if (context != null && context.mounted) {
          CustomSnackBar.top(
            context: context,
            msg: LocaleKeys.quantityLimitExceeded,
          );
        }
      }
    }

    safeEmit(state.copyWith(currentInputTotal: price * qty));
  }

  void addInvoiceItem() {
    final currentSelectedItem = state.selectedStorageItem;
    if (currentSelectedItem == null || state.currentInputTotal <= 0) return;
    final price = double.tryParse(sellPriceController.text.trim()) ?? 0;
    double qty = double.tryParse(quantityController.text.trim()) ?? 0;
    if (price <= 0 || qty <= 0) return;
    if (qty > currentSelectedItem.quantity) {
      qty = currentSelectedItem.quantity;
      quantityController.text = qty.toStringAsFixed(2);
    }

    List<ItemsInvoice> updated = List<ItemsInvoice>.from(state.invoiceItems);
    final existingIndex = updated.indexWhere(
      (item) => item.storageItem.target?.uuid == currentSelectedItem.uuid,
    );

    if (existingIndex != -1) {
      final existing = updated[existingIndex];
      final newQty =
          (existing.quantity + qty)
              .clamp(0, currentSelectedItem.quantity)
              .toDouble();

      final updatedItem = ItemsInvoice(
        sellPrice: price,
        quantity: newQty,
        totalItemPrice: price * newQty,
      )..storageItem.target = existing.storageItem.target;

      updated[existingIndex] = updatedItem;
    } else {
      final newItem = ItemsInvoice(
        sellPrice: price,
        quantity: qty,
        totalItemPrice: price * qty,
      )..storageItem.target = currentSelectedItem;

      updated.add(newItem);
    }

    final total = updated.fold<double>(0, (sum, e) => sum + e.totalItemPrice);
    final finalTotal = state.isSessionActive ? (state.sessionCost + total) : total;

    sellPriceController.clear();
    quantityController.clear();

    safeEmit(
      state.copyWith(
        invoiceItems: updated,
        totalInvoice: finalTotal,
        currentInputTotal: 0,
        clearSelectedStorageItem: true,
      ),
    );

    _persistActiveSessionItems();
  }

  void removeInvoiceItem(int index) {
    final updated = List<ItemsInvoice>.from(state.invoiceItems)
      ..removeAt(index);
    final total = updated.fold<double>(0, (sum, e) => sum + e.totalItemPrice);
    final finalTotal = state.isSessionActive ? (state.sessionCost + total) : total;
    
    safeEmit(state.copyWith(invoiceItems: updated, totalInvoice: finalTotal));
    _persistActiveSessionItems();
  }

  void updateCashPaid() {
    final paid = double.tryParse(paidCashController.text.trim()) ?? 0;
    safeEmit(state.copyWith(cashPaid: paid));
  }

  Future<void> saveInvoice(BuildContext context) async {
    if (!state.canSaveInvoice) return;

    final isPaidLater = state.paymentType == PaymentType.later;
    final cashPaid = isPaidLater ? state.cashPaid : state.totalInvoice;
    final laterPaid = isPaidLater ? state.laterPaid : 0.0;

    final invoice = CreateInvoiceModel.create(
      uuid: state.invoiceUuid,
      totalInvoice: state.totalInvoice,
      cashPaid: cashPaid,
      laterPaid: laterPaid,
      invoiceDate: DateTime.now(),
      paymentType: state.paymentType,
    );

    // Link customer if any (only when not session, or if customer is allowed, but we don't use customers)
    invoice.customer.target = state.selectedCustomer;

    // Link items
    invoice.items.addAll(state.invoiceItems);

    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _createInvoiceUseCase(invoice);
    result.fold(
      (failure) {
        CustomSnackBar.top(context: context, msg: failure.message);
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (_) {
        CustomSnackBar.top(
          context: context,
          msg: LocaleKeys.invoiceSaved,
          color: AppColors.successColor,
        );
        _resetInvoice(context);
      },
    );
  }

  void _resetInvoice(BuildContext context) {
    paidCashController.clear();
    sellPriceController.clear();
    quantityController.clear();
    _getAllInvoiceModels(context);
    _getAllDevices();
    
    safeEmit(
      InvoiceState.initial().copyWith(
        invoiceModels: state.invoiceModels,
        devices: state.devices,
        status: StateStatus.success,
      ),
    );
  }

  @override
  Future<void> close() {
    _sessionTimer?.cancel();
    sellPriceController.dispose();
    quantityController.dispose();
    paidCashController.dispose();
    return super.close();
  }
}
