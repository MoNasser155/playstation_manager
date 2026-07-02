// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../extentions/theme_extensions.dart';
import '../languages/local_keys.g.dart';
import 'text_field_with_label.dart';

class PassFieldWithLabel extends StatefulWidget {
  const PassFieldWithLabel({
    super.key,
    required this.label,
    this.validate,
    this.controller,
    this.hint,
    this.action,
    this.onChange,
  });
  final String label;
  final String? hint;
  final String? Function(String?)? validate;
  final TextEditingController? controller;
  final TextInputAction? action;
  final Function(String)? onChange;
  @override
  State<PassFieldWithLabel> createState() => _PassFieldWithLabelState();
}

class _PassFieldWithLabelState extends State<PassFieldWithLabel> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldWithLabel(
      fillColor: context.primaryContainer,
      controller: widget.controller,
      maxLines: 1,
      validate: widget.validate,
      hidden: hidden,
      hint: widget.hint ?? LocaleKeys.passwordHint,
      inputType: TextInputType.visiblePassword,
      removeInit: true,
      action: widget.action,
      label: widget.label,
      onChange: widget.onChange,
      suffix: IconButton(
        onPressed: () {
          setState(() {
            hidden = !hidden;
          });
        },
        icon:
            hidden
                ? Icon(Icons.visibility_outlined, color: Colors.grey)
                : Icon(Icons.visibility_off_outlined, color: Colors.grey),
      ),
    );
  }
}
