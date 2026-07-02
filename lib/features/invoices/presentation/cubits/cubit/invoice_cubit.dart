import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enums/payment_type.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../customers/data/models/customer_model.dart';
import '../../../../storage/data/models/storage_model.dart';
import '../../../data/models/create_invoice_model.dart';
import '../../../data/models/get_invoice_models.dart';
import '../../../domain/usecases/create_invoice_usecase.dart';
import '../../../domain/usecases/get_all_invoice_models_usecase.dart';

part 'invoice_state.dart';

class InvoiceCubit extends BaseCubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceState.initial()) {
    setControllersValue();
  }

  static InvoiceCubit get(context) => BlocProvider.of(context);

  final _getAllInvoiceModelsUsecase = sl<GetAllInvoiceModelsUseCase>();
  final _createInvoiceUseCase = sl<CreateInvoiceUseCase>();

  final sellPriceController = TextEditingController(text: '0');
  final quantityController = TextEditingController(text: '0');
  final paidCashController = TextEditingController(text: '0');

  void setControllersValue() {
    sellPriceController.text =
        state.selectedStorageItem?.sellPrice.toStringAsFixed(2) ?? '';
    quantityController.text =
        state.selectedStorageItem?.quantity.toStringAsFixed(2) ?? '';
  }

  init(BuildContext context, {CustomerModel? customer}) {
    safeEmit(state.copyWith(status: StateStatus.loading));

    _getAllInvoiceModels(context);
    if (customer != null) setCustomer(customer);
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

    sellPriceController.clear();
    quantityController.clear();

    safeEmit(
      state.copyWith(
        invoiceItems: updated,
        totalInvoice: total,
        currentInputTotal: 0,
        clearSelectedStorageItem: true,
      ),
    );
  }

  void removeInvoiceItem(int index) {
    final updated = List<ItemsInvoice>.from(state.invoiceItems)
      ..removeAt(index);
    final total = updated.fold<double>(0, (sum, e) => sum + e.totalItemPrice);
    safeEmit(state.copyWith(invoiceItems: updated, totalInvoice: total));
  }

  /// Called when the user types in the "paid now" field (later payment type)
  void updateCashPaid() {
    final paid = double.tryParse(paidCashController.text.trim()) ?? 0;
    safeEmit(state.copyWith(cashPaid: paid));
  }

  /// Builds and persists the invoice, updates stock & customer balance
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

    // Link customer
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
        // Reset invoice state for a new invoice
        _resetInvoice(context);
      },
    );
  }

  void _resetInvoice(BuildContext context) {
    paidCashController.clear();
    sellPriceController.clear();
    quantityController.clear();
    // Re-fetch to get updated stock & customer data
    _getAllInvoiceModels(context);
    safeEmit(
      InvoiceState.initial().copyWith(
        invoiceModels: state.invoiceModels,
        status: StateStatus.success,
      ),
    );
  }

  @override
  Future<void> close() {
    sellPriceController.dispose();
    quantityController.dispose();
    paidCashController.dispose();
    return super.close();
  }
}
