import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../features/reports/data/models/reports_model.dart';
import '../../constants/app_values.dart';
import '../../extentions/theme_extensions.dart';
import '../../languages/local_keys.g.dart';

class CustomBarChart extends StatefulWidget {
  final List<DeviceUsage> devices;
  final bool isArabic;
  final String tooltipLabel;

  const CustomBarChart({
    super.key,
    required this.devices,
    required this.isArabic,
    required this.tooltipLabel,
  });

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.devices.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Center(
          child: Text(
            LocaleKeys.noDataAvailable,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final int maxCount = widget.devices
        .map((d) => d.sessionCount)
        .reduce(math.max);
    // Avoid division by zero
    final int adjustedMax = maxCount > 0 ? maxCount : 1;

    return Container(
      padding: EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: context.appShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          const double height = 220.0;
          const double leftPadding = 45.0;
          const double rightPadding = 15.0;
          const double topPadding = 25.0;
          const double bottomPadding = 30.0;

          final double chartWidth = width - leftPadding - rightPadding;
          final int numBars = widget.devices.length;
          final double barWidth = (chartWidth / numBars) * 0.5;
          final double barSpacing = chartWidth / numBars;

          void updateHover(Offset localPos) {
            int hoveredIdx = -1;
            for (int i = 0; i < numBars; i++) {
              final double barX =
                  leftPadding + i * barSpacing + (barSpacing - barWidth) / 2;
              final double xMin = barX - (barWidth * 0.25);
              final double xMax = barX + barWidth + (barWidth * 0.25);

              if (localPos.dx >= xMin && localPos.dx <= xMax) {
                hoveredIdx = i;
                break;
              }
            }
            if (hoveredIdx != _hoveredIndex) {
              setState(() {
                _hoveredIndex = hoveredIdx;
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
                painter: _BarChartPainter(
                  devices: widget.devices,
                  maxCount: adjustedMax,
                  hoveredIndex: _hoveredIndex,
                  tooltipLabel: widget.tooltipLabel,
                  isArabic: widget.isArabic,
                  theme: context.theme,
                  leftPadding: leftPadding,
                  rightPadding: rightPadding,
                  topPadding: topPadding,
                  bottomPadding: bottomPadding,
                  barWidth: barWidth,
                  barSpacing: barSpacing,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<DeviceUsage> devices;
  final int maxCount;
  final int hoveredIndex;
  final String tooltipLabel;
  final bool isArabic;
  final ThemeData theme;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double barWidth;
  final double barSpacing;

  _BarChartPainter({
    required this.devices,
    required this.maxCount,
    required this.hoveredIndex,
    required this.tooltipLabel,
    required this.isArabic,
    required this.theme,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.barWidth,
    required this.barSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double chartHeight = size.height - topPadding - bottomPadding;
    final double chartBottom = size.height - bottomPadding;

    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final gridColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.3);
    final textStyle = TextStyle(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: 10,
      fontFamily: 'NotoSansArabic',
    );

    // 1. Draw Grid and Y-Axis Labels
    const int gridLines = 4;
    final double yStep = maxCount / gridLines;
    final paintGrid =
        Paint()
          ..color = gridColor
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    for (int i = 0; i <= gridLines; i++) {
      final double yVal = yStep * i;
      final double yPos = chartBottom - (yVal / maxCount) * chartHeight;

      // Draw dashed horizontal lines
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

      // Draw Y value labels
      final labelPainter = TextPainter(
        text: TextSpan(text: yVal.toStringAsFixed(0), style: textStyle),
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

    // 2. Draw bars
    for (int i = 0; i < devices.length; i++) {
      final d = devices[i];
      final double barHeight = (d.sessionCount / maxCount) * chartHeight;
      final double barX =
          leftPadding + i * barSpacing + (barSpacing - barWidth) / 2;
      final double barY = chartBottom - barHeight;

      final isHovered = hoveredIndex == i;

      // Create rounded rectangle rect for the bar
      final rect = Rect.fromLTWH(barX, barY, barWidth, barHeight);
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );

      final barPaint =
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  isHovered
                      ? [primaryColor, primaryColor.withValues(alpha: 0.6)]
                      : [secondaryColor, secondaryColor.withValues(alpha: 0.5)],
            ).createShader(rect)
            ..style = PaintingStyle.fill;

      canvas.drawRRect(rrect, barPaint);

      // Draw bar border/outline
      if (isHovered) {
        final borderPaint =
            Paint()
              ..color = primaryColor
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke;
        canvas.drawRRect(rrect, borderPaint);
      }

      // Draw label under the bar (Device Name)
      final deviceLabel = d.deviceName;
      final namePainter = TextPainter(
        text: TextSpan(
          text:
              deviceLabel.length > 8
                  ? '${deviceLabel.substring(0, 7)}..'
                  : deviceLabel,
          style: textStyle.copyWith(
            fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      );
      namePainter.layout();
      namePainter.paint(
        canvas,
        Offset(barX + barWidth / 2 - namePainter.width / 2, chartBottom + 8),
      );
    }

    // 3. Draw hover tooltip
    if (hoveredIndex >= 0 && hoveredIndex < devices.length) {
      final d = devices[hoveredIndex];
      final double barHeight = (d.sessionCount / maxCount) * chartHeight;
      final double barX =
          leftPadding + hoveredIndex * barSpacing + (barSpacing - barWidth) / 2;
      final double barY = chartBottom - barHeight;

      final tooltipTextPainter = TextPainter(
        text: TextSpan(
          text: '${d.deviceName}\n$tooltipLabel: ${d.sessionCount}',
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

      final double tooltipWidth = tooltipTextPainter.width + 16;
      final double tooltipHeight = tooltipTextPainter.height + 12;
      double tooltipX = barX + barWidth / 2 - tooltipWidth / 2;
      double tooltipY = barY - tooltipHeight - 10;

      // Bound clamp tooltip
      tooltipX = tooltipX.clamp(
        leftPadding,
        size.width - rightPadding - tooltipWidth,
      );
      if (tooltipY < 0) {
        tooltipY =
            barY + barHeight + 10; // Draw below if it overflows above chart
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
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.devices != devices ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.theme != theme ||
        oldDelegate.isArabic != isArabic;
  }
}
