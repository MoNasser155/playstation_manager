import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../features/reports/data/models/reports_model.dart';
import '../../constants/app_values.dart';
import '../../extentions/theme_extensions.dart';
import '../../languages/local_keys.g.dart';
import '../../utils/gaps.dart';

class CustomPieChart extends StatefulWidget {
  final List<ProductSale> products;
  final bool isArabic;

  const CustomPieChart({
    super.key,
    required this.products,
    required this.isArabic,
  });

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
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

    final double totalQuantity = widget.products.fold<double>(
      0.0,
      (sum, p) => sum + p.quantitySold,
    );

    return Container(
      padding: EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: context.appShadow,
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double size = math.min(constraints.maxWidth, 200.0);
              void updateHover(Offset localPos) {
                final double cx = constraints.maxWidth / 2;
                final double cy = size / 2;
                final double dx = localPos.dx - cx;
                final double dy = localPos.dy - cy;
                final double distance = math.sqrt(dx * dx + dy * dy);

                final double outerRadius = size / 2;
                // Donut inner hole check
                const double innerRadius = 30.0;

                if (distance > outerRadius || distance < innerRadius) {
                  if (_hoveredIndex != -1) {
                    setState(() {
                      _hoveredIndex = -1;
                    });
                  }
                  return;
                }

                double angle = math.atan2(dy, dx);
                if (angle < 0) {
                  angle += 2 * math.pi;
                }

                double currentStartAngle = -math.pi / 2; // start from top
                int hoveredIdx = -1;

                for (int i = 0; i < widget.products.length; i++) {
                  final p = widget.products[i];
                  final double sweepAngle =
                      totalQuantity > 0
                          ? (p.quantitySold / totalQuantity) * 2 * math.pi
                          : 0.0;

                  // Normalize start angle
                  double start = currentStartAngle;
                  while (start < 0) {
                    start += 2 * math.pi;
                  }
                  start = start % (2 * math.pi);

                  double end = start + sweepAngle;

                  // Check if angle is inside [start, end]
                  bool inside = false;
                  if (end > 2 * math.pi) {
                    inside = angle >= start || angle <= (end % (2 * math.pi));
                  } else {
                    inside = angle >= start && angle <= end;
                  }

                  if (inside) {
                    hoveredIdx = i;
                    break;
                  }

                  currentStartAngle += sweepAngle;
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
                    size: Size(constraints.maxWidth, size),
                    painter: _PieChartPainter(
                      products: widget.products,
                      totalQuantity: totalQuantity,
                      hoveredIndex: _hoveredIndex,
                      isArabic: widget.isArabic,
                      theme: context.theme,
                    ),
                  ),
                ),
              );
            },
          ),
          gapH(AppSpacing.v16),
          // Elegant layout legend list below the chart
          _LegendList(products: widget.products, totalQuantity: totalQuantity),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<ProductSale> products;
  final double totalQuantity;
  final int hoveredIndex;
  final bool isArabic;
  final ThemeData theme;

  _PieChartPainter({
    required this.products,
    required this.totalQuantity,
    required this.hoveredIndex,
    required this.isArabic,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double radius = math.min(size.width, size.height) / 2;

    // Curated sleek colors matching success, warning, primary, info, and a purple tint
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      Colors.teal,
      Colors.deepPurpleAccent,
    ];

    double currentStartAngle = -math.pi / 2;

    for (int i = 0; i < products.length; i++) {
      final p = products[i];
      final double sweepAngle =
          totalQuantity > 0
              ? (p.quantitySold / totalQuantity) * 2 * math.pi
              : 0.0;

      final isHovered = hoveredIndex == i;
      final color = colors[i % colors.length];

      // Draw active slice popped out along its bisector angle
      double dx = 0;
      double dy = 0;
      if (isHovered) {
        final double bisectorAngle = currentStartAngle + sweepAngle / 2;
        dx = math.cos(bisectorAngle) * 8;
        dy = math.sin(bisectorAngle) * 8;
      }

      final sliceRect = Rect.fromCircle(
        center: Offset(cx + dx, cy + dy),
        radius: radius,
      );

      final slicePaint =
          Paint()
            ..color = color
            ..style = PaintingStyle.fill;

      // Draw filled arc slice
      canvas.drawArc(
        sliceRect,
        currentStartAngle,
        sweepAngle,
        true,
        slicePaint,
      );

      // Draw sleek donut center hole overlay
      final centerHolePaint =
          Paint()
            ..color = theme.colorScheme.surfaceContainerLow
            ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(cx + dx, cy + dy),
        radius * 0.45,
        centerHolePaint,
      );

      // Draw hover tooltip over the center if hovered
      if (isHovered) {
        final double percentage =
            totalQuantity > 0 ? (p.quantitySold / totalQuantity) * 100 : 0.0;
        final tooltipTextPainter = TextPainter(
          text: TextSpan(
            text:
                '${p.productName}\n${p.quantitySold.toStringAsFixed(0)} ${isArabic ? 'وحدات' : 'pcs'}\n${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1.3,
              fontFamily: 'NotoSansArabic',
            ),
          ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        );
        tooltipTextPainter.layout();
        tooltipTextPainter.paint(
          canvas,
          Offset(
            cx + dx - tooltipTextPainter.width / 2,
            cy + dy - tooltipTextPainter.height / 2,
          ),
        );
      }

      currentStartAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.products != products ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.theme != theme ||
        oldDelegate.isArabic != isArabic;
  }
}

class _LegendList extends StatelessWidget {
  final List<ProductSale> products;
  final double totalQuantity;

  const _LegendList({required this.products, required this.totalQuantity});

  @override
  Widget build(BuildContext context) {
    final colors = [
      context.colorScheme.primary,
      context.colorScheme.secondary,
      context.colorScheme.tertiary,
      Colors.teal,
      Colors.deepPurpleAccent,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(products.length, (index) {
        final p = products[index];
        final color = colors[index % colors.length];
        final double pct =
            totalQuantity > 0 ? (p.quantitySold / totalQuantity) * 100 : 0.0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              '${p.productName} (${pct.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 11,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }),
    );
  }
}
