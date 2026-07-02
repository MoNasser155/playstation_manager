import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: BouncingDots()));
  }
}

class BouncingDots extends StatelessWidget {
  const BouncingDots({super.key});

  static const dotColor = Color(0xFF0062DB); // 0,0.384,0.859 -> approx blue

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        // stagger: 8 frames per dot at 60fps = 133ms
        final delay = (index * 133).ms;
        // up: 14 frames ~233ms, down: 16 frames ~267ms
        const upDuration = Duration(milliseconds: 233);
        const downDuration = Duration(milliseconds: 267);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(
                delay: delay,
                duration: upDuration,
                begin: 0.25,
                curve: Curves.easeInOut,
              )
              .then(curve: Curves.easeInOut)
              .fadeOut(duration: downDuration, begin: 1.0)
              .animate(onPlay: (controller) => controller.repeat())
              .scaleXY(
                delay: delay,
                duration: upDuration,
                begin: 0.5,
                end: 0.75,
                curve: Curves.easeInOut,
              )
              .then(curve: Curves.easeInOut)
              .scaleXY(duration: downDuration, begin: 0.75, end: 0.5)
              .animate(onPlay: (controller) => controller.repeat())
              .moveY(
                delay: delay,
                duration: upDuration,
                begin: 0,
                end: -40,
                curve: Curves.easeInOut,
              )
              .then(curve: Curves.easeInOut)
              .moveY(duration: downDuration, begin: -40, end: 0),
        );
      }),
    );
  }
}
