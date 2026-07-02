import 'package:flutter/material.dart';

import '../../../features/customers/data/models/customer_model.dart';
import '../../../features/suppliers/data/models/supplier_model.dart';
import '../../../features/transactions/data/models/transaction_model.dart';
import '../../constants/app_assets.dart';
import '../../extentions/media_query_extenstions.dart';
import '../../extentions/theme_extensions.dart';
import '../../languages/local_keys.g.dart';
import '../../utils/gaps.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/validations.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_field.dart';
import 'transaction_pdf_service.dart';

class SavePdfDialog extends StatefulWidget {
  final CustomerModel? customer;
  final SupplierModel? supplier;
  final String? initialName;
  final List<TransactionModel> transactions;
  final String totalAmount;
  const SavePdfDialog({
    super.key,
    this.customer,
    this.supplier,
    this.initialName,
    required this.transactions,
    required this.totalAmount,
  });

  @override
  State<SavePdfDialog> createState() => _SavePdfDialogState();
}

class _SavePdfDialogState extends State<SavePdfDialog> {
  late final TextEditingController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final name =
        widget.customer != null
            ? widget.customer?.name
            : widget.supplier != null
            ? widget.supplier?.name
            : widget.initialName;
    _controller = TextEditingController(text: name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      maxWidth: context.width * 0.25,
      children: [
        Text(LocaleKeys.savePdf, style: context.textTheme.displayLarge),
        gapHFix(16),
        Form(
          key: _formKey,
          child: CustomTextField(
            controller: _controller,
            hint: LocaleKeys.fileName,
            validate: Validations.validateEmpty,
          ),
        ),
        gapHFix(20),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: LocaleKeys.cancel,
                backgroundColor: context.mapCard,
                borderColor: context.colorScheme.error,
                textColor: context.colorScheme.onPrimary,
                onTap: _isLoading ? null : () => AppNavigator.pop(),
              ),
            ),
            gapWFix(12),
            Expanded(
              child: CustomButton(
                isLoading: _isLoading,
                title: LocaleKeys.save,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    try {
                      await TransactionPdfService.saveTransactionsPdf(
                        transactions: widget.transactions,
                        customer: widget.customer,
                        supplier: widget.supplier,
                        initialName: _controller.text.trim(),
                        totalAmount: widget.totalAmount,
                        logoAssetPath: AppImages.logo,
                      );
                      if (mounted) AppNavigator.pop();
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
