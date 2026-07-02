import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/main_view_mode.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/shared/di.dart';
import '../../../../core/widgets/row_taps/custom_taps_row.dart';
import '../../../customers/data/models/customer_model.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../data/models/create_invoice_model.dart';
import '../cubits/cubit/invoice_cubit.dart';
import '../cubits/refund_cubit/refund_invoice_cubit.dart';
import '../widgets/desktop/desktop_invoice_body.dart';
import '../widgets/desktop/desktop_refund_invoice_body.dart';
import '../widgets/mobile/mobile_invoice_body.dart';
import '../widgets/mobile/mobile_refund_invoice_body.dart';
import '../widgets/tablet/tablet_invoice_body.dart';
import '../widgets/tablet/tablet_refund_invoice_body.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key, this.customer, this.invoice});
  final CustomerModel? customer;
  final CreateInvoiceModel? invoice;

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  int _selectedSubTabIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedSubTabIndex = widget.invoice != null ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.toString()),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: CustomTapsRow(
                selectedIndex: _selectedSubTabIndex,
                itemsCount: 2,
                itemsName: [LocaleKeys.createInvoice, LocaleKeys.refundInvoice],
                onTap: (index) {
                  setState(() {
                    _selectedSubTabIndex = index;
                  });
                },
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedSubTabIndex,
                children: [
                  // Sales Invoice tab
                  BlocProvider(
                    key: const ValueKey('sales_invoice_tab'),
                    create:
                        (context) =>
                            sl<InvoiceCubit>()
                              ..init(context, customer: widget.customer),
                    child: BlocBuilder<MainViewCubit, MainViewState>(
                      buildWhen:
                          (previous, current) => previous.mode != current.mode,
                      builder: (context, state) {
                        switch (state.mode) {
                          case MainViewMode.mobile:
                            return const MobileInvoiceBody();
                          case MainViewMode.tablet:
                            return const TabletInvoiceBody();
                          case MainViewMode.desktop:
                            return const DesktopInvoiceBody();
                        }
                      },
                    ),
                  ),
                  // Refund Invoice tab
                  BlocProvider(
                    key: const ValueKey('refund_invoice_tab'),
                    create:
                        (context) =>
                            sl<RefundInvoiceCubit>()..init(
                              context,
                              customer: widget.customer,
                              invoice: widget.invoice,
                            ),
                    child: BlocBuilder<MainViewCubit, MainViewState>(
                      buildWhen:
                          (previous, current) => previous.mode != current.mode,
                      builder: (context, state) {
                        switch (state.mode) {
                          case MainViewMode.mobile:
                            return const MobileRefundInvoiceBody();
                          case MainViewMode.tablet:
                            return const TabletRefundInvoiceBody();
                          case MainViewMode.desktop:
                            return const DesktopRefundInvoiceBody();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
