import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import '../../../../core/utils/gaps.dart';

class SessionTimerDisplay extends StatelessWidget {
  const SessionTimerDisplay({
    super.key,
    required this.duration,
    this.label,
  });

  final Duration duration;
  final String? label;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          gapH(8),
        ],
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              _formatDuration(duration),
              style: context.textTheme.headlineLarge?.copyWith(
                fontSize: 96, // Large base size to allow stretching to container width
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
