import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class SessionItemTextField extends StatelessWidget {
  const SessionItemTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.hint,
    this.isLastColumn = false,
    this.readonly = false,
    this.initial,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hint;
  final String? initial;
  final bool isLastColumn;
  final bool readonly;

  BorderRadius _borderRadius(BuildContext context) {
    return BorderRadius.only(
      bottomRight:
          isLastColumn
              ? context.isRtl
                  ? Radius.zero
                  : Radius.circular(AppRadius.r16)
              : Radius.zero,
      bottomLeft:
          isLastColumn
              ? context.isRtl
                  ? Radius.circular(AppRadius.r16)
                  : Radius.zero
              : Radius.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = _borderRadius(context);

    return CustomTextField(
      controller: controller,
      initial: initial,
      hint: hint,
      maxlines: 1,
      readonly: readonly,
      onChange: onChanged,
      inputType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: context.colorScheme.error,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: context.colorScheme.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: radius,
        ),
      ),
    );
  }
}
