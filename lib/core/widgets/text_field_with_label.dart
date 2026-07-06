import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../utils/gaps.dart';
import 'custom_text_field.dart';

class TextFieldWithLabel extends StatelessWidget {
  const TextFieldWithLabel({
    super.key,
    required this.label,
    this.hidden = false,
    this.suffix,
    this.hint,
    this.readOnly = false,
    this.fillColor,
    this.controller,
    this.validate,
    this.inputType,
    this.onChange,
    this.removeInit = false,
    this.action,
    this.maxLines = 1,
    this.scrollPhysics,
    this.inputFormatters,
    this.isEnabled = true,
    this.maxLength,
    this.buildCounter = false,
  });
  final String? label, hint;
  final bool hidden, readOnly, removeInit, buildCounter;
  final Widget? suffix;
  final Color? fillColor;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final TextInputType? inputType;
  final Function(String)? onChange;
  final TextInputAction? action;
  final int? maxLines, maxLength;
  final bool? isEnabled;
  final ScrollPhysics? scrollPhysics;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final initialValue = controller == null && !removeInit ? hint : null;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(label!, style: context.textTheme.titleMedium),
        gapH(6),
        CustomTextField(
          inputFormatters: inputFormatters,
          scrollPhysics: scrollPhysics ?? const NeverScrollableScrollPhysics(),
          action: action,
          onChange: onChange,
          inputType: inputType,
          validate: validate,
          readonly: readOnly,
          initial: initialValue,
          controller: controller,
          hint: hint,
          suffix: suffix,
          isHidden: hidden,
          fillColor: fillColor ?? context.mapCard,
          maxlines: maxLines,
          maxLength: maxLength,
          builderCounter: buildCounter,
        ),
      ],
    );
  }
}
