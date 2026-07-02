import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;

  const CustomRadioButton({
    super.key,
    required this.isSelected,
    this.onTap,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.secondaryFixed,
            width: 2,
          ),
        ),
        child:
            isSelected
                ? Center(
                  child: Container(
                    width: size * 0.5,
                    height: size * 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colorScheme.primary,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
