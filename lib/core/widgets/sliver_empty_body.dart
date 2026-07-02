
import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

class SliverEmptyBody extends StatelessWidget {
  final String title;
  const SliverEmptyBody({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(
            color: context.colorScheme.secondaryFixed,
          ),
        ),
      ),
    );
  }
}