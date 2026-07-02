import 'package:flutter/material.dart';

class SwipeHintAnimation extends StatefulWidget {
  final Widget child;
  final bool animate;
  final VoidCallback? onAnimationComplete;

  const SwipeHintAnimation({
    super.key,
    required this.child,
    this.animate = true,
    this.onAnimationComplete,
  });

  @override
  State<SwipeHintAnimation> createState() => _SwipeHintAnimationState();
}

class _SwipeHintAnimationState extends State<SwipeHintAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _offsetAnimation = TweenSequence<Offset>([
      // Swipe Right
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0.15, 0.0))
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      // Pause/Slight bounce back
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0.15, 0.0), end: const Offset(0.1, 0.0))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      // Swipe Left (crossing center)
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0.1, 0.0), end: const Offset(-0.15, 0.0))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      // Return to Zero
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(-0.15, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 25,
      ),
    ]).animate(_controller);

    if (widget.animate) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _controller.forward().then((_) {
          if (mounted && widget.onAnimationComplete != null) {
            widget.onAnimationComplete!();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(SwipeHintAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return FractionalTranslation(
          translation: _offsetAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
