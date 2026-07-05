import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/utils/gaps.dart';

class SessionTimerDisplay extends StatelessWidget {
  const SessionTimerDisplay({
    super.key,
    required this.duration,
    this.startTime,
    this.label,
  });

  final Duration duration;
  final DateTime? startTime;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.textTheme.displayLarge?.copyWith(
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
            child: SessionTimerText(
              duration: duration,
              startTime: startTime,
              style: context.textTheme.headlineLarge?.copyWith(
                fontSize:
                    96, // Large base size to allow stretching to container width
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SessionTimerText extends StatefulWidget {
  const SessionTimerText({
    super.key,
    required this.duration,
    this.startTime,
    this.style,
  });

  final Duration duration;
  final DateTime? startTime;
  final TextStyle? style;

  @override
  State<SessionTimerText> createState() => _SessionTimerTextState();
}

class _SessionTimerTextState extends State<SessionTimerText> {
  Timer? _timer;
  late final ValueNotifier<Duration> _durationNotifier;

  @override
  void initState() {
    super.initState();
    _durationNotifier = ValueNotifier<Duration>(_calculateDuration());
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant SessionTimerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.startTime != widget.startTime) {
      _durationNotifier.value = _calculateDuration();
      _startTimer();
    }
  }

  Duration _calculateDuration() {
    if (widget.startTime != null) {
      return clock.now().difference(widget.startTime!);
    }
    return widget.duration;
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.startTime != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _durationNotifier.value = _calculateDuration();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationNotifier.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: _durationNotifier,
      builder: (context, elapsed, _) {
        return Text(_formatDuration(elapsed), style: widget.style);
      },
    );
  }
}
