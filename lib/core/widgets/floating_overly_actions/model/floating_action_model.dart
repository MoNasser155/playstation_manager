import 'package:flutter/material.dart';

class FloatingActionModel {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const FloatingActionModel({
    required this.label,
    required this.icon,
    this.color,
     this.onTap,
  });
}