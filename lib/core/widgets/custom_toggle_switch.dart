import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../theme/app_colors.dart';

class CustomToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomToggle({
    super.key,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle>
    with SingleTickerProviderStateMixin {
  late bool isToggled;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    isToggled = widget.initialValue;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    if (isToggled) {
      _controller.forward();
    }
  }

  void _toggle() {
    setState(() {
      isToggled = !isToggled;
      isToggled ? _controller.forward() : _controller.reverse();
      widget.onChanged(isToggled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 36,

              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: Color.lerp(
                  AppColors.grey300,
                  AppColors.grey200,
                  _animation.value,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment:
                    Alignment.lerp(
                      Alignment.centerLeft,
                      Alignment.centerRight,
                      _animation.value,
                    )!,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        _animation.value > 0.5
                            ? context.colorScheme.primary
                            : context.colorScheme.secondaryFixed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
