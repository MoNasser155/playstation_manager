import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.title,
    this.child,
    this.onTap,
    this.buttonWidth = double.infinity,
    this.buttonPadding,
    this.heightPercent,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.radius,
    this.buttonHeight = 44,
    this.isLoading = false,
    this.isEnabled = true,
  });
  final String? title;
  final Widget? child;
  final VoidCallback? onTap;
  final double buttonWidth, buttonHeight;
  final EdgeInsetsGeometry? buttonPadding;
  final double? heightPercent, radius;
  final Color? backgroundColor, borderColor, textColor;
  final bool isLoading;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isLoading || !isEnabled) ? null : onTap,
      borderRadius: BorderRadius.circular(radius ?? 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isEnabled
                    ? (borderColor ?? backgroundColor ?? AppColors.primaryColor)
                    : context.colorScheme.primary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(radius ?? 8),
          color:
              isEnabled
                  ? (backgroundColor ?? AppColors.primaryColor)
                  : context.colorScheme.primary.withValues(alpha: 0.3),
        ),
        margin: buttonPadding,
        width: buttonWidth,
        height: buttonHeight,
        alignment: Alignment.center,
        child: Center(
          child:
              child != null
                  ? isLoading
                      ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: context.colorScheme.onPrimary,
                        ),
                      )
                      : child!
                  : isLoading
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: context.colorScheme.onPrimary,
                    ),
                  )
                  : Text(
                    title ?? '',
                    style: context.textTheme.headlineLarge!.copyWith(
                      color:
                          isEnabled
                              ? (textColor ?? Colors.white)
                              : context.colorScheme.secondaryFixed.withValues(
                                alpha: 0.4,
                              ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }
}
