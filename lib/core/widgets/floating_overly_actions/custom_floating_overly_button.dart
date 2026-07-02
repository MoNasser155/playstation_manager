import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_values.dart';
import '../../extentions/theme_extensions.dart';
import '../../utils/gaps.dart';
import 'model/floating_action_model.dart';

part 'floating_action_overlay.dart';

class CustomFloatingOverlayButton extends StatefulWidget {
  final List<FloatingActionModel> actions;
  final Color? primaryColor;
  final IconData icon;
  final bool isRtl;

  const CustomFloatingOverlayButton({
    super.key,
    required this.actions,
    this.primaryColor,
    this.icon = Icons.add,
    required this.isRtl,
  });

  @override
  State<CustomFloatingOverlayButton> createState() =>
      _CustomFloatingOverlayButtonState();
}

class _CustomFloatingOverlayButtonState
    extends State<CustomFloatingOverlayButton>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _iconController.dispose();
    super.dispose();
  }

  void _openOverlay() {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    _iconController.forward();

    _overlayEntry = OverlayEntry(
      builder: (_) => _FloatingActionsOverlay(
        actions: widget.actions,
        primaryColor: widget.primaryColor ?? context.colorScheme.primary,
        buttonPosition: buttonPosition,
        buttonSize: buttonSize,
        onClose: _removeOverlay,
        isRtl: widget.isRtl,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_iconController.isCompleted) _iconController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.primaryColor ?? context.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _overlayEntry == null ? _openOverlay : _removeOverlay,
          child: Container(
            key: _buttonKey,
            padding: EdgeInsets.all(AppPadding.p12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _iconController,
              builder: (_, __) => Transform.rotate(
                angle: _iconController.value * 0.785398, // 45°
                child: Icon(widget.icon, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
        gapH(kBottomNavigationBarHeight + 12),
      ],
    );
  }
}
