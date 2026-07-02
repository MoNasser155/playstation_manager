import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../cubits/cubit/invoice_cubit.dart';
import 'invoice_item_row_filled.dart';
import 'invoice_item_row_input.dart';

class InvoiceItemsList extends StatelessWidget {
  const InvoiceItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<InvoiceCubit, InvoiceState>(
        buildWhen:
            (previous, current) =>
                previous.invoiceItems != current.invoiceItems,
        builder: (context, state) {
          final items = state.invoiceItems;
          final totalCount = items.length + 1;

          return SliverList.separated(
            itemCount: totalCount,
            separatorBuilder:
                (_, __) => Divider(
                  height: 0,
                  color: context.colorScheme.secondaryFixed,
                ),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return const InvoiceItemRowInput();
              }

              return InvoiceItemRowFilled(item: items[index], index: index);
            },
          );
        },
      ),
    );
  }
}
