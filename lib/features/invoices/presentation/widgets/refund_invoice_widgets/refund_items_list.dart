import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../../data/models/create_invoice_model.dart';
import '../../cubits/refund_cubit/refund_invoice_cubit.dart';
import 'refund_cell.dart';

class RefundItemsList extends StatelessWidget {
  const RefundItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundInvoiceCubit, RefundInvoiceState>(
      buildWhen: (prev, cur) =>
          prev.selectedInvoice != cur.selectedInvoice ||
          prev.adjustedItems != cur.adjustedItems ||
          prev.originalQuantities != cur.originalQuantities ||
          prev.originalPrices != cur.originalPrices,
      builder: (context, state) {
        if (state.selectedInvoice == null) return const SliverToBoxAdapter();
        final cubit = RefundInvoiceCubit.get(context);

        return CustomSliverPadding(
          sliver: SliverList.separated(
            itemCount: state.adjustedItems.length,
            separatorBuilder: (_, __) => Divider(
              height: 0,
              color: context.colorScheme.secondaryFixed,
            ),
            itemBuilder: (context, index) {
              final item = state.adjustedItems[index];
              final storageUuid = item.storageItem.target?.uuid ?? '';
              final maxQty = state.originalQuantities[storageUuid] ?? 0.0;
              final originalPrice = state.originalPrices[storageUuid] ?? 0.0;

              return _RefundItemRow(
                item: item,
                storageUuid: storageUuid,
                maxQty: maxQty,
                originalPrice: originalPrice,
                cubit: cubit,
              );
            },
          ),
        );
      },
    );
  }
}

// ── Private row widget ─────────────────────────────────────────────────────────

class _RefundItemRow extends StatelessWidget {
  const _RefundItemRow({
    required this.item,
    required this.storageUuid,
    required this.maxQty,
    required this.originalPrice,
    required this.cubit,
  });

  final ItemsInvoice item;
  final String storageUuid;
  final double maxQty;
  final double originalPrice;
  final RefundInvoiceCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.pf12,
        horizontal: AppPadding.pf8,
      ),
      decoration: BoxDecoration(
        color: context.primaryContainer,
        border: Border(
          bottom: BorderSide(color: context.colorScheme.secondaryFixed),
        ),
      ),
      child: Row(
        spacing: AppSpacing.h12,
        children: [
          // Col 0 – Item name
          RefundCell(
            index: 0,
            child: Text(
              item.storageItem.target?.itemName ?? '',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Col 1 – Editable price
          RefundCell(
            index: 1,
            child: TextFormField(
              initialValue: item.sellPrice.toStringAsFixed(2),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              onFieldSubmitted: (val) {
                final price = double.tryParse(val) ?? originalPrice;
                cubit.updateItemPrice(storageUuid, price);
              },
            ),
          ),
          // Col 2 – Quantity stepper
          RefundCell(
            index: 2,
            child: Row(
              children: [
                InkWell(
                  onTap: item.quantity > 0
                      ? () => cubit.updateItemQuantity(
                            storageUuid,
                            item.quantity - 1,
                          )
                      : null,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.pf4),
                    child: Icon(
                      Icons.remove_circle_outline,
                      size: 18,
                      color: item.quantity > 0
                          ? context.colorScheme.primary
                          : context.colorScheme.secondaryFixed,
                    ),
                  ),
                ),
                gapW(4),
                Text(
                  '${item.quantity.toInt()} / ${maxQty.toInt()}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                gapW(4),
                InkWell(
                  onTap: item.quantity < maxQty
                      ? () => cubit.updateItemQuantity(
                            storageUuid,
                            item.quantity + 1,
                          )
                      : null,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.pf4),
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 18,
                      color: item.quantity < maxQty
                          ? context.colorScheme.primary
                          : context.colorScheme.secondaryFixed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Col 3 – Total
          RefundCell(
            index: 3,
            child: Text(
              item.totalItemPrice.toStringAsFixed(2),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Delete button
          InkWell(
            onTap: () => cubit.removeItem(storageUuid),
            borderRadius: BorderRadius.circular(AppRadius.r8),
            child: Padding(
              padding: EdgeInsets.all(AppPadding.pf4),
              child: Icon(
                Icons.delete_rounded,
                color: context.colorScheme.error,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
