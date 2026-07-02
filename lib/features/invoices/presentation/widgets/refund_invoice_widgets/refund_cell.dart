import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

/// RTL-aware table cell matching the [InvoiceItemsHeaderRow] /
/// [InvoiceItemRowFilled] border pattern.
class RefundCell extends StatelessWidget {
  const RefundCell({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  static const _lastIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: index == 0 ? 3 : 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right:
                index == _lastIndex
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide.none
                    : BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    ),
            left:
                index == _lastIndex
                    ? BorderSide.none
                    : context.isRtl
                    ? BorderSide(
                      color: context.colorScheme.secondaryFixed,
                      width: 1.5,
                    )
                    : BorderSide.none,
          ),
        ),
        child: child,
      ),
    );
  }
}
