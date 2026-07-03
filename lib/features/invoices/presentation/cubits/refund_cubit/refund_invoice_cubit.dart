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
import '../../../data/models/create_invoice_model.dart';
import '../../../domain/usecases/get_all_invoices_usecase.dart';
import '../../../domain/usecases/refund_invoice_usecase.dart';

part 'refund_invoice_state.dart';

class RefundInvoiceCubit extends BaseCubit<RefundInvoiceState> {
  RefundInvoiceCubit() : super(RefundInvoiceState.initial());

  static RefundInvoiceCubit get(context) =>
      BlocProvider.of<RefundInvoiceCubit>(context);

  final _getAllInvoicesUseCase = sl<GetAllInvoicesUseCase>();
  final _refundInvoiceUseCase = sl<RefundInvoiceUseCase>();

  final paidCashController = TextEditingController(text: '0');

  void init(
    BuildContext context, {
    CreateInvoiceModel? invoice,
  }) {
    safeEmit(
      state.copyWith(status: StateStatus.loading, selectedInvoice: invoice),
    );
    _loadAllInvoices(context, invoice: invoice);
  }

  Future<void> _loadAllInvoices(
    BuildContext context, {
    CreateInvoiceModel? invoice,
  }) async {
    final result = await _getAllInvoicesUseCase();
    result.fold(
      (failure) {
        // NoInvoicesFoundException is handled cleanly by displaying an empty list, not failing the cubit
        if (failure.message == LocaleKeys.noInvoicesFound) {
          safeEmit(
            state.copyWith(status: StateStatus.success, invoices: []),
          );
        } else {
          CustomSnackBar.top(context: context, msg: failure.message);
          safeEmit(state.copyWith(status: StateStatus.failure));
        }
      },
      (invoicesList) {
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            invoices: invoicesList,
          ),
        );
        if (invoice != null) {
          selectInvoice(invoice);
        }
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
    safeEmit(RefundInvoiceState.initial());
    _loadAllInvoices(context);
  }

  @override
  Future<void> close() {
    paidCashController.dispose();
    return super.close();
  }
}
