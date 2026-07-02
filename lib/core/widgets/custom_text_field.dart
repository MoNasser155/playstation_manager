import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onChange,
    this.hint,
    this.suffix,
    this.isHidden = false,
    this.prefix,
    this.initial,
    this.maxlines = 1,
    this.minlines,
    this.readonly = false,
    this.fillColor,
    this.controller,
    this.validate,
    this.inputType,
    this.action,
    this.borderRadius,
    this.scrollPhysics,
    this.enabeledBorder,
    this.inputFormatters,
    this.textAlign,
    this.maxLength,
    this.builderCounter = false,
    this.decoration,
  });
  final Function(String)? onChange;
  final TextInputAction? action;
  final String? hint, initial;
  final bool isHidden, readonly;
  final Widget? suffix, prefix;
  final int? maxlines, minlines;
  final Color? fillColor;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final TextInputType? inputType;
  final BorderRadius? borderRadius;
  final ScrollPhysics? scrollPhysics;
  final Color? enabeledBorder;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final int? maxLength;
  final bool builderCounter;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      scrollPhysics: scrollPhysics ?? const NeverScrollableScrollPhysics(),
      textAlignVertical: TextAlignVertical.center,
      selectionHeightStyle: ui.BoxHeightStyle.max,
      textInputAction: action,
      validator: validate,
      controller: controller,
      initialValue: initial,
      style: context.textTheme.titleLarge!.copyWith(
        color: context.colorScheme.onPrimary,
      ),
      onChanged: onChange,
      readOnly: readonly,
      maxLines: maxlines,
      minLines: minlines,
      obscureText: isHidden,
      keyboardType: inputType,
      cursorErrorColor: Colors.red,
      cursorColor: AppColors.primaryColor,
      textAlign: textAlign ?? TextAlign.start,
      maxLength: maxLength,
      buildCounter: (
        context, {
        required currentLength,
        required isFocused,
        maxLength,
      }) {
        // Return null if there's a validation error to let the error message show
        if (context.findAncestorStateOfType<FormFieldState>()?.hasError ??
            false) {
          return null;
        }

        return builderCounter
            ? Row(
              children: [
                const Spacer(),
                Text(
                  "${currentLength.toString()}/${maxLength.toString()}",
                  style: context.textTheme.labelMedium!.copyWith(
                    color: context.colorScheme.secondaryFixed,
                  ),
                ),
              ],
            )
            : null;
      },
      decoration:
          decoration ??
          InputDecoration(
            prefixIcon: prefix,
            suffixIcon: suffix,
            hintText: hint,
            filled: true,
            fillColor: fillColor,
          ),
    );
  }
}
