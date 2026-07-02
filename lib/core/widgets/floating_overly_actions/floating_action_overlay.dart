part of 'custom_floating_overly_button.dart';

class _FloatingActionsOverlay extends StatefulWidget {
  final List<FloatingActionModel> actions;
  final Color primaryColor;
  final Offset buttonPosition;
  final Size buttonSize;
  final VoidCallback onClose;
  final bool isRtl;

  const _FloatingActionsOverlay({
    required this.actions,
    required this.primaryColor,
    required this.buttonPosition,
    required this.buttonSize,
    required this.onClose,
    required this.isRtl,
  });

  @override
  State<_FloatingActionsOverlay> createState() =>
      _FloatingActionsOverlayState();
}

class _FloatingActionsOverlayState extends State<_FloatingActionsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _blurAnimation = Tween<double>(
      begin: 0,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            // ── Blurred backdrop ──
            GestureDetector(
              onTap: _dismiss,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.35 * _fadeAnimation.value,
                  ),
                ),
              ),
            ),

            // ── Actions List ──
            Positioned(
              bottom: kBottomNavigationBarHeight * 3,
              right: widget.isRtl ? null : AppPadding.pf20,
              left: widget.isRtl ? AppPadding.pf20 : null,
              child: ActionItemList(
                actions: widget.actions,
                controller: _controller,
                buttonSize: widget.buttonSize,
                buttonPosition: widget.buttonPosition,
                primaryColor: widget.primaryColor,
                onDismiss: _dismiss,
                isRtl: widget.isRtl,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ActionItemList extends StatelessWidget {
  const ActionItemList({
    super.key,
    required this.actions,
    required this.controller,
    required this.buttonSize,
    required this.buttonPosition,
    required this.primaryColor,
    required this.onDismiss,
    this.isRtl = false,
  });

  final List<FloatingActionModel> actions;
  final AnimationController controller;
  final Size buttonSize;
  final Offset buttonPosition;
  final Color primaryColor;
  final Future<void> Function() onDismiss;
  final bool isRtl;

  Animation<double> _staggeredAnimation(int i) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          i * 0.08,
          (i * 0.08 + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppPadding.p12,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(actions.length, (i) {
        final action = actions[i];
        final animation = _staggeredAnimation(i);

        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - animation.value)),
              child: Opacity(
                opacity: animation.value.clamp(0.0, 1.0),
                child: _ActionItem(
                  action: action,
                  primaryColor: action.color ?? primaryColor,
                  onTap: () async {
                    await onDismiss();
                    action.onTap?.call();
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ─── Action Item ──────────────────────────────────────────────────────────────

class _ActionItem extends StatefulWidget {
  final FloatingActionModel action;
  final Color primaryColor;
  final VoidCallback onTap;

  const _ActionItem({
    required this.action,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  State<_ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<_ActionItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.action.color ?? widget.primaryColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label chip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p12,
                vertical: AppPadding.p8,
              ),
              decoration: BoxDecoration(
                color: context.mapCard,
                borderRadius: BorderRadius.circular(AppRadius.r8),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Text(
                widget.action.label,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            gapW(8),
            // Icon button
            Container(
              padding: EdgeInsets.all(AppPadding.p12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                widget.action.icon,
                color: Colors.white,
                size: AppSize.s20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
