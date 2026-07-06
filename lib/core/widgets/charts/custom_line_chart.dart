import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_values.dart';
import '../../languages/local_keys.g.dart';

class CustomLineChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final int? highlightIndex;
  final String tooltipLabel;
  final bool isArabic;

  const CustomLineChart({
    super.key,
    required this.values,
    required this.labels,
    this.highlightIndex,
    required this.tooltipLabel,
    this.isArabic = false,
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.values.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: const Center(
          child: Text(
            LocaleKeys.noDataAvailable,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final double maxValue = widget.values.reduce(math.max);
    // Ensure maxValue is at least 1.0 to avoid division by zero
    final double adjustedMax = maxValue > 0 ? maxValue : 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          const double height = 220.0;
          const double leftPadding = 55.0;
          const double rightPadding = 20.0;
          const double topPadding = 25.0;
          const double bottomPadding = 30.0;

          final double chartWidth = width - leftPadding - rightPadding;
          final int numPoints = widget.values.length;
          final double spacing =
              numPoints > 1 ? chartWidth / (numPoints - 1) : chartWidth;

          void updateHover(Offset localPos) {
            final int index = ((localPos.dx - leftPadding) / spacing)
                .round()
                .clamp(0, numPoints - 1);
            if (index != _hoveredIndex) {
              setState(() {
                _hoveredIndex = index;
              });
            }
          }

          return MouseRegion(
            onHover: (event) => updateHover(event.localPosition),
            onExit:
                (_) => setState(() {
                  _hoveredIndex = -1;
                }),
            child: GestureDetector(
              onPanUpdate: (details) => updateHover(details.localPosition),
              onPanEnd:
                  (_) => setState(() {
                    _hoveredIndex = -1;
                  }),
              onTapDown: (details) => updateHover(details.localPosition),
              child: CustomPaint(
                size: Size(width, height),
                painter: _LineChartPainter(
                  values: widget.values,
                  labels: widget.labels,
                  maxValue: adjustedMax,
                  hoveredIndex: _hoveredIndex,
                  highlightIndex: widget.highlightIndex,
                  tooltipLabel: widget.tooltipLabel,
                  isArabic: widget.isArabic,
                  theme: Theme.of(context),
                  leftPadding: leftPadding,
                  rightPadding: rightPadding,
                  topPadding: topPadding,
                  bottomPadding: bottomPadding,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final int hoveredIndex;
  final int? highlightIndex;
  final String tooltipLabel;
  final bool isArabic;
  final ThemeData theme;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  _LineChartPainter({
    required this.values,
    required this.labels,
    required this.maxValue,
    required this.hoveredIndex,
    this.highlightIndex,
    required this.tooltipLabel,
    required this.isArabic,
    required this.theme,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double chartWidth = size.width - leftPadding - rightPadding;
    final double chartHeight = size.height - topPadding - bottomPadding;
    final double chartBottom = size.height - bottomPadding;

    final primaryColor = theme.colorScheme.primary;
    final gridColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.3);
    final textStyle = TextStyle(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: 10,
      fontFamily: 'NotoSansArabic',
    );

    // 1. Draw Grid and Y-Axis Labels
    const int gridLines = 4;
    final double yStep = maxValue / gridLines;
    final paintGrid =
        Paint()
          ..color = gridColor
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    for (int i = 0; i <= gridLines; i++) {
      final double yVal = yStep * i;
      final double yPos = chartBottom - (yVal / maxValue) * chartHeight;

      // Draw horizontal dashed line
      final path = Path();
      path.moveTo(leftPadding, yPos);
      path.lineTo(size.width - rightPadding, yPos);

      // Dash drawing
      const double dashWidth = 4;
      const double dashSpace = 4;
      double distance = leftPadding;
      final dashPath = Path();
      while (distance < size.width - rightPadding) {
        dashPath.moveTo(distance, yPos);
        dashPath.lineTo(
          math.min(distance + dashWidth, size.width - rightPadding),
          yPos,
        );
        distance += dashWidth + dashSpace;
      }
      canvas.drawPath(dashPath, paintGrid);

      // Draw Y label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: '${yVal.toStringAsFixed(0)} ${isArabic ? 'ج.م' : 'EGP'}',
          style: textStyle,
        ),
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      );
      labelPainter.layout();
      final double labelX =
          isArabic
              ? size.width - rightPadding + 5
              : leftPadding - labelPainter.width - 8;
      labelPainter.paint(
        canvas,
        Offset(labelX, yPos - labelPainter.height / 2),
      );
    }

    // 2. Map data points to screen coordinates
    final numPoints = values.length;
    final double spacing =
        numPoints > 1 ? chartWidth / (numPoints - 1) : chartWidth;
    final List<Offset> points = [];

    for (int i = 0; i < numPoints; i++) {
      final double xPos = leftPadding + i * spacing;
      final double yPos = chartBottom - (values[i] / maxValue) * chartHeight;
      points.add(Offset(xPos, yPos));
    }

    if (points.isEmpty) return;

    // 3. Draw curved line and gradient fill
    final linePaint =
        Paint()
          ..color = primaryColor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final fillPath = Path();
    final linePath = Path();

    linePath.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, chartBottom);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY1 = p0.dy;
      final controlX2 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY2 = p1.dy;

      linePath.cubicTo(
        controlX1,
        controlY1,
        controlX2,
        controlY2,
        p1.dx,
        p1.dy,
      );
      fillPath.cubicTo(
        controlX1,
        controlY1,
        controlX2,
        controlY2,
        p1.dx,
        p1.dy,
      );
    }

    fillPath.lineTo(points.last.dx, chartBottom);
    fillPath.close();

    // Draw gradient fill
    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.3),
              primaryColor.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromLTRB(
              leftPadding,
              topPadding,
              size.width - rightPadding,
              chartBottom,
            ),
          )
          ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    // 4. Draw X axis labels and standard node dots
    for (int i = 0; i < numPoints; i++) {
      final p = points[i];

      // Draw X axis label
      final xLabelPainter = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      );
      xLabelPainter.layout();
      xLabelPainter.paint(
        canvas,
        Offset(p.dx - xLabelPainter.width / 2, chartBottom + 8),
      );

      // Draw standard node dot
      final dotPaint =
          Paint()
            ..color = primaryColor
            ..style = PaintingStyle.fill;
      final bgDotPaint =
          Paint()
            ..color = theme.colorScheme.surface
            ..style = PaintingStyle.fill;

      canvas.drawCircle(p, 5, bgDotPaint);
      canvas.drawCircle(p, 3, dotPaint);

      // Draw special highlight for specific index (e.g. current month)
      if (highlightIndex == i) {
        final glowPaint =
            Paint()
              ..color = primaryColor.withValues(alpha: 0.3)
              ..style = PaintingStyle.fill;
        canvas.drawCircle(p, 10, glowPaint);
        canvas.drawCircle(p, 5, dotPaint);
      }
    }

    // 5. Draw Hover State and Tooltip Overlay
    if (hoveredIndex >= 0 && hoveredIndex < numPoints) {
      final p = points[hoveredIndex];

      // Draw vertical indicator line
      final hoverLinePaint =
          Paint()
            ..color = primaryColor.withValues(alpha: 0.4)
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(p.dx, topPadding),
        Offset(p.dx, chartBottom),
        hoverLinePaint,
      );

      // Draw enlarged hover node
      final hoverDotPaint =
          Paint()
            ..color = primaryColor
            ..style = PaintingStyle.fill;
      final hoverOuterDotPaint =
          Paint()
            ..color = theme.colorScheme.surface
            ..style = PaintingStyle.fill;
      final hoverRingPaint =
          Paint()
            ..color = primaryColor.withValues(alpha: 0.2)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(p, 12, hoverRingPaint);
      canvas.drawCircle(p, 6, hoverOuterDotPaint);
      canvas.drawCircle(p, 4, hoverDotPaint);

      // Prepare Tooltip text
      final tooltipTextPainter = TextPainter(
        text: TextSpan(
          text:
              '${labels[hoveredIndex]}\n$tooltipLabel: ${values[hoveredIndex].toStringAsFixed(0)} ${isArabic ? 'ج.م' : 'EGP'}',
          style: TextStyle(
            color: theme.colorScheme.onInverseSurface,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            height: 1.4,
            fontFamily: 'NotoSansArabic',
          ),
        ),
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      );
      tooltipTextPainter.layout();

      // Tooltip positioning
      final double tooltipWidth = tooltipTextPainter.width + 16;
      final double tooltipHeight = tooltipTextPainter.height + 12;
      double tooltipX = p.dx - tooltipWidth / 2;
      double tooltipY = p.dy - tooltipHeight - 12;

      // Bound clamp tooltips
      tooltipX = tooltipX.clamp(
        leftPadding,
        size.width - rightPadding - tooltipWidth,
      );
      if (tooltipY < 0) {
        tooltipY = p.dy + 12; // Draw below if it overflows above chart
      }

      final tooltipRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
        const Radius.circular(8),
      );

      final tooltipBgPaint =
          Paint()
            ..color = theme.colorScheme.inverseSurface
            ..style = PaintingStyle.fill;

      final tooltipBorderPaint =
          Paint()
            ..color = primaryColor.withValues(alpha: 0.5)
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke;

      canvas.drawRRect(tooltipRect, tooltipBgPaint);
      canvas.drawRRect(tooltipRect, tooltipBorderPaint);

      tooltipTextPainter.paint(canvas, Offset(tooltipX + 8, tooltipY + 6));
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.labels != labels ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.highlightIndex != highlightIndex ||
        oldDelegate.isArabic != isArabic ||
        oldDelegate.theme != theme;
  }
}
