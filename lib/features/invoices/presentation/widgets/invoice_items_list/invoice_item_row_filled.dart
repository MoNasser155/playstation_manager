import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../data/models/create_invoice_model.dart';
import '../../cubits/cubit/invoice_cubit.dart';

class InvoiceItemRowFilled extends StatelessWidget {
  const InvoiceItemRowFilled({
    super.key,
    required this.item,
    required this.index,
  });

  final ItemsInvoice item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
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
          ...List.generate(
            4,
            (index) => _FilledCell(
              title: switch (index) {
                0 => item.storageItem.target?.itemName ?? '',
                1 => item.sellPrice.toStringAsFixed(2),
                2 => item.quantity.toStringAsFixed(
                  item.quantity == item.quantity.floorToDouble() ? 0 : 2,
                ),
                _ => item.totalItemPrice.toStringAsFixed(2),
              },
              index: index,
            ),
          ),
          _DeleteButton(
            onTap: () => InvoiceCubit.get(context).removeInvoiceItem(index),
          ),
        ],
      ),
    );
  }
}

class _FilledCell extends StatelessWidget {
  const _FilledCell({required this.index, required this.title});

  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: index == 0 ? 3 : 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right:
                index == 3
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide.none
                    : BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    ),
            left:
                index == 3
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    )
                    : BorderSide.none,
          ),
        ),
        child: Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r8),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.pf4),
        child: Icon(
          Icons.delete_rounded,
          color: context.colorScheme.error,
          size: 16,
        ),
      ),
    );
  }
}
