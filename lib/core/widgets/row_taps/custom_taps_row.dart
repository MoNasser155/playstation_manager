import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../constants/app_values.dart';
import '../../languages/languages.dart';

class CustomTapsRow extends StatefulWidget {
  const CustomTapsRow({
    super.key,
    required this.selectedIndex,
    required this.itemsCount,
    this.itemsName,
    this.itemsIcon,
    required this.onTap,
    this.onDoubleTap,
    this.textColor,
    this.indicatorColor,
    this.height,
    this.decoration,
    this.selectedTextStyle,
    this.unSelectedTextStyle,
  });
  final int selectedIndex;
  final int itemsCount;
  final List<String>? itemsName;
  final List<Widget>? itemsIcon;
  final void Function(int index)? onTap;
  final void Function(int index)? onDoubleTap;
  final Color? textColor, indicatorColor;
  final double? height;
  final Decoration? decoration;
  final TextStyle? selectedTextStyle, unSelectedTextStyle;
  @override
  State<CustomTapsRow> createState() => _CustomTapsRowState();
}

class _CustomTapsRowState extends State<CustomTapsRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<double>(
      begin: widget.selectedIndex.toDouble(),
      end: widget.selectedIndex.toDouble(),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateToIndex(int newIndex) {
    _slideAnimation = Tween<double>(
      begin: _slideAnimation.value,
      end: newIndex.toDouble(),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant CustomTapsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _animateToIndex(widget.selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / widget.itemsCount;
        return SizedBox(
          height: widget.height ?? 40,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Positioned(
                    left:
                        Languages.currentLanguage.isEnglish
                            ? _slideAnimation.value * tabWidth
                            : null,
                    right:
                        Languages.currentLanguage.isEnglish
                            ? null
                            : _slideAnimation.value * tabWidth,
                    top: 0,
                    bottom: 0,
                    width: tabWidth,
                    child: Container(
                      decoration:
                          widget.decoration ??
                          BoxDecoration(
                            color: context.colorScheme.primary,
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                    ),
                  );
                },
              ),
              Row(
                children: List.generate(
                  widget.itemsCount,
                  (index) => Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      onTap: widget.onTap != null ? () => widget.onTap!(index) : null,
                      onDoubleTap: widget.onDoubleTap != null ? () => widget.onDoubleTap!(index) : null,
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style:
                              index == widget.selectedIndex
                                  ? widget.selectedTextStyle ??
                                      context.textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            widget.textColor ??
                                            context.colorScheme.onPrimary,
                                      )
                                  : widget.unSelectedTextStyle ??
                                      context.textTheme.bodySmall!.copyWith(
                                        color:
                                            context.colorScheme.secondaryFixed,
                                      ),
                          child:
                              widget.itemsName != null
                                  ? Text(
                                    widget.itemsName![index],
                                    style:
                                        index == widget.selectedIndex
                                            ? widget.selectedTextStyle ??
                                                context.textTheme.titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          widget.textColor ??
                                                          Colors.white,
                                                    )
                                            : widget.unSelectedTextStyle ??
                                                context.textTheme.titleSmall!
                                                    .copyWith(
                                                      color:
                                                          context
                                                              .colorScheme
                                                              .secondaryFixed,
                                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                  : widget.itemsIcon![index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
