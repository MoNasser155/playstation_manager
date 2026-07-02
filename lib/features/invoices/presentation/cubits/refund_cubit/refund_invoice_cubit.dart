import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/payment_type.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../customers/data/models/customer_model.dart';
import '../../../data/models/create_invoice_model.dart';
import '../../../domain/usecases/get_all_invoice_models_usecase.dart';
import '../../../domain/usecases/get_customer_invoices_usecase.dart';
import '../../../domain/usecases/refund_invoice_usecase.dart';

part 'refund_invoice_state.dart';

class RefundInvoiceCubit extends BaseCubit<RefundInvoiceState> {
  RefundInvoiceCubit() : super(RefundInvoiceState.initial());

  static RefundInvoiceCubit get(context) =>
      BlocProvider.of<RefundInvoiceCubit>(context);

  final _getAllInvoiceModelsUseCase = sl<GetAllInvoiceModelsUseCase>();
  final _getCustomerInvoicesUseCase = sl<GetCustomerInvoicesUseCase>();
  final _refundInvoiceUseCase = sl<RefundInvoiceUseCase>();

  final paidCashController = TextEditingController(text: '0');

  void init(
    BuildContext context, {
    CustomerModel? customer,
    CreateInvoiceModel? invoice,
  }) {
    safeEmit(
      state.copyWith(status: StateStatus.loading, selectedInvoice: invoice),
    );
    _loadAllCustomers(context, customer: customer, invoice: invoice);
  }

  Future<void> _loadAllCustomers(
    BuildContext context, {
    CustomerModel? customer,
    CreateInvoiceModel? invoice,
  }) async {
    final result = await _getAllInvoiceModelsUseCase();
    result.fold(
      (failure) {
        CustomSnackBar.top(context: context, msg: failure.message);
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (invoiceModels) {
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            customers: invoiceModels.customers,
          ),
        );
        if (customer != null && invoice != null) {
          setCustomer(context, customer);
          selectInvoice(invoice);
        }
      },
    );
  }

  Future<void> setCustomer(BuildContext context, CustomerModel customer) async {
    safeEmit(
      state.copyWith(
        selectedCustomer: customer,
        clearSelectedInvoice: false,
        adjustedItems: [],
        originalQuantities: {},
        originalPrices: {},
        cashPaid: 0,
        totalInvoice: 0,
        totalRefundAmount: 0,
      ),
    );
    paidCashController.clear();
    _loadCustomerInvoices(context, customer.uuid);
  }

  Future<void> _loadCustomerInvoices(
    BuildContext context,
    String customerUuid,
  ) async {
    safeEmit(state.copyWith(status: StateStatus.loading, customerInvoices: []));
    final result = await _getCustomerInvoicesUseCase(customerUuid);
    result.fold(
      (failure) {
        // NoInvoicesFoundException is handled cleanly by displaying an empty list, not failing the cubit
        if (failure.message == LocaleKeys.noInvoicesFound) {
          safeEmit(
            state.copyWith(status: StateStatus.success, customerInvoices: []),
          );
        } else {
          CustomSnackBar.top(context: context, msg: failure.message);
          safeEmit(state.copyWith(status: StateStatus.failure));
        }
      },
      (invoices) {
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            customerInvoices: invoices,
          ),
        );
      },
    );
  }

  void selectInvoice(CreateInvoiceModel invoice) {
    // Clone invoice items
    final clonedItems =
        invoice.items.map((item) {
          final copy = ItemsInvoice(
            id: item.id,
            sellPrice: item.sellPrice,
            quantity: item.quantity,
            totalItemPrice: item.totalItemPrice,
          );
          copy.storageItem.target = item.storageItem.target;
          return copy;
        }).toList();

    // Map original quantities and prices
    final Map<String, double> originalQtys = {};
    final Map<String, double> originalPrs = {};
    for (final item in invoice.items) {
      final uuid = item.storageItem.target?.uuid ?? '';
      if (uuid.isNotEmpty) {
        originalQtys[uuid] = item.quantity;
        originalPrs[uuid] = item.sellPrice;
      }
    }

    paidCashController.text = invoice.cashPaid.toStringAsFixed(2);

    safeEmit(
      state.copyWith(
        selectedInvoice: invoice,
        adjustedItems: clonedItems,
        originalQuantities: originalQtys,
        originalPrices: originalPrs,
        cashPaid: invoice.cashPaid,
        totalInvoice: invoice.totalInvoice,
        totalRefundAmount: 0,
      ),
    );
  }

  void updateItemQuantity(String storageUuid, double newQty) {
    if (state.selectedInvoice == null) return;
    final maxQty = state.originalQuantities[storageUuid] ?? 0.0;
    final clampedQty = newQty.clamp(0.0, maxQty);

    final updatedItems =
        state.adjustedItems
            .map((item) {
              if (item.storageItem.target?.uuid == storageUuid) {
                final total = clampedQty * item.sellPrice;
                final updated = ItemsInvoice(
                  id: item.id,
                  sellPrice: item.sellPrice,
                  quantity: clampedQty,
                  totalItemPrice: total,
                );
                updated.storageItem.target = item.storageItem.target;
                return updated;
              }
              return item;
            })
            .where((item) => item.quantity > 0)
            .toList();

    _recalculateTotals(updatedItems);
  }

  void updateItemPrice(String storageUuid, double newPrice) {
    if (state.selectedInvoice == null) return;
    final clampedPrice = newPrice.clamp(0.0, double.infinity);

    final updatedItems =
        state.adjustedItems.map((item) {
          if (item.storageItem.target?.uuid == storageUuid) {
            final total = item.quantity * clampedPrice;
            final updated = ItemsInvoice(
              id: item.id,
              sellPrice: clampedPrice,
              quantity: item.quantity,
              totalItemPrice: total,
            );
            updated.storageItem.target = item.storageItem.target;
            return updated;
          }
          return item;
        }).toList();

    _recalculateTotals(updatedItems);
  }

  void removeItem(String storageUuid) {
    if (state.selectedInvoice == null) return;
    final updatedItems =
        state.adjustedItems
            .where((item) => item.storageItem.target?.uuid != storageUuid)
            .toList();

    _recalculateTotals(updatedItems);
  }

  void _recalculateTotals(List<ItemsInvoice> items) {
    final originalInvoice = state.selectedInvoice!;
    final newTotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.totalItemPrice,
    );
    final refundAmount = originalInvoice.totalInvoice - newTotal;

    double cashPaid = state.cashPaid;
    if (originalInvoice.paymentType == PaymentType.cash) {
      cashPaid = newTotal;
      paidCashController.text = cashPaid.toStringAsFixed(2);
    } else {
      // For later, paid cash cannot exceed new total
      if (cashPaid > newTotal) {
        cashPaid = newTotal;
        paidCashController.text = cashPaid.toStringAsFixed(2);
      }
    }

    safeEmit(
      state.copyWith(
        adjustedItems: items,
        totalInvoice: newTotal,
        totalRefundAmount: refundAmount,
        cashPaid: cashPaid,
      ),
    );
  }

  void updateCashPaid() {
    if (state.selectedInvoice == null) return;
    double cash = double.tryParse(paidCashController.text.trim()) ?? 0.0;

    // Cash paid cannot exceed the new total invoice
    if (cash > state.totalInvoice) {
      cash = state.totalInvoice;
      paidCashController.text = cash.toStringAsFixed(2);
    }

    safeEmit(state.copyWith(cashPaid: cash));
  }

  Future<void> saveRefund(BuildContext context) async {
    if (!state.canSaveRefund) return;

    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _refundInvoiceUseCase(
      invoiceUuid: state.selectedInvoice!.uuid,
      adjustedItems: state.adjustedItems,
      newTotal: state.totalInvoice,
      newCashPaid: state.cashPaid,
      newLaterPaid: state.newLaterPaid,
    );

    result.fold(
      (failure) {
        CustomSnackBar.top(context: context, msg: failure.message);
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (_) {
        CustomSnackBar.top(
          context: context,
          msg: LocaleKeys.refundSaved,
          color: AppColors.successColor,
        );
        _resetRefund(context);
      },
    );
  }

  void _resetRefund(BuildContext context) {
    paidCashController.clear();
    final previousCustomer = state.selectedCustomer;
    safeEmit(RefundInvoiceState.initial().copyWith(customers: state.customers));
    if (previousCustomer != null) {
      setCustomer(context, previousCustomer);
    }
  }

  @override
  Future<void> close() {
    paidCashController.dispose();
    return super.close();
  }
}
