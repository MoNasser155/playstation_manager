import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.strokeWidth = 2.0,
    this.dashWidth = 15.0,
    this.dashSpace = 8.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: context.colorScheme.secondaryFixed,
          strokeWidth: strokeWidth,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    _drawDashedRRect(canvas, rrect, paint);
  }

  void _drawDashedRRect(Canvas canvas, RRect rrect, Paint paint) {
    final Path path = Path()..addRRect(rrect);
    final PathMetric pathMetric = path.computeMetrics().first;

    double distance = 0;
    while (distance < pathMetric.length) {
      canvas.drawPath(
        pathMetric.extractPath(distance, distance + dashWidth),
        paint,
      );
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
