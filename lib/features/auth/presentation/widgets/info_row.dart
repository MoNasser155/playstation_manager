import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';
import 'package:playstation_manager/core/widgets/custom_snack_bar.dart';

import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gaps.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool copyable;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.colorScheme.secondaryFixed),
        gapW(10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: context.colorScheme.secondaryFixed,
              letterSpacing: 1.3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (copyable)
          Tooltip(
            message: LocaleKeys.machineId,
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                CustomSnackBar.top(
                  context: context,
                  msg: LocaleKeys.machineIdCopied,
                  color: AppColors.successColor,
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.copy_rounded,
                  size: 15,
                  color: context.colorScheme.secondaryFixed,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
