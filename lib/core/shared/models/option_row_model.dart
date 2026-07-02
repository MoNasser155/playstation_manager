import 'package:flutter/material.dart';

class OptionRowModel {
  final String title;
  final Function()? onTap;
  final Widget? suffix;

  OptionRowModel({required this.title, this.onTap, this.suffix});
}
