import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

class CustomScrollableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration pauseDuration;
  final double velocity;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const CustomScrollableText({
    super.key,
    required this.text,
    this.style,
    this.pauseDuration = const Duration(seconds: 1),
    this.velocity = 30.0, // Pixels per second
    this.maxLines,
    this.textAlign,
    this.overflow,
  });

  @override
  State<CustomScrollableText> createState() => _CustomScrollableTextState();
}

class _CustomScrollableTextState extends State<CustomScrollableText> {
  late ScrollController _scrollController;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void didUpdateWidget(covariant CustomScrollableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    }
  }

  @override
  void dispose() {
    _isRunning = false;
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startScrolling() async {
    while (_isRunning && mounted) {
      if (!_scrollController.hasClients) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }

      final maxScrollExtent = _scrollController.position.maxScrollExtent;

      if (maxScrollExtent > 0) {
        await Future.delayed(widget.pauseDuration);
        if (!_isRunning || !mounted) break;

        final durationInSeconds = maxScrollExtent / widget.velocity;
        final duration = Duration(
          milliseconds: (durationInSeconds * 1000).toInt(),
        );

        await _scrollController.animateTo(
          maxScrollExtent,
          duration: duration,
          curve: Curves.linear,
        );

        if (!_isRunning || !mounted) break;

        await Future.delayed(widget.pauseDuration);
        if (!_isRunning || !mounted) break;

        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style ?? context.textTheme.bodyMedium,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}
