import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../../core/widgets/sliver_empty_body.dart';
import '../../../../invoices/data/models/create_invoice_model.dart';
import '../../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../cubits/customer_details_cubit/customer_details_cubit.dart';
import 'customer_details_invoice_card.dart';

class CustomerDetailsInvoicesSection extends StatelessWidget {
  const CustomerDetailsInvoicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CustomerDetailsCubit, CustomerDetailsState>(
        buildWhen: (previous, current) {
          return previous.invoicesStatus != current.invoicesStatus;
        },
        builder: (context, state) {
          if (state.invoicesStatus.isSuccess && state.invoices.isEmpty) {
            return SliverEmptyBody(title: LocaleKeys.noInvoicesFound);
          }
          final length =
              state.invoicesStatus.isLoading ? 10 : state.invoices.length;
          return CustomScrollView(
            slivers: [
              CustomSliverPadding(
                sliver: SliverList.separated(
                  itemBuilder: (context, index) {
                    final invoice =
                        state.invoicesStatus.isLoading
                            ? CreateInvoiceModel.initial()
                            : state.invoices[index];
                    return InkWell(
                      onTap: () {
                        final mainViewCubit = MainViewCubit.get(context);
                        mainViewCubit.setSelectedTap(
                          1,
                          send: [state.customerDetails.customer, invoice],
                        );
                      },
                      child: CustomInvoiceCard(invoice: invoice),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return gapH(12);
                  },
                  itemCount: length,
                ),
              ),
              sliverGapHFix(12),
            ],
          );
        },
      ),
    );
  }
}
