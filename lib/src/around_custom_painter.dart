import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class AroundCustomPainter extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final Shadow? shadow;
  final double progress;
  final bool showLoading;
  final double borderWidth;
  final Color borderColor;
  final Widget child;

  AroundCustomPainter({
    required this.clipper,
    required this.borderWidth,
    required this.borderColor,
    required this.child,
    required this.showLoading,
    this.shadow,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _AroundCustomPainter(
        clipper: this.clipper,
        shadow: this.shadow,
        progress: this.progress,
        borderColor: this.borderColor,
        showLoading: this.showLoading,
        borderWidth: this.borderWidth,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _AroundCustomPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final double progress;
  final Shadow? shadow;
  final double borderWidth;
  final Color borderColor;
  final bool showLoading;
  _AroundCustomPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.clipper,
    required this.showLoading,
    required this.progress,
    this.shadow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clipPath = clipper.getClip(size);

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    final shadowPaint = shadow?.toPaint();

    if (size.height != 0) {
      if (shadow != null && shadow!.color.value != Colors.transparent.value) {
        canvas.drawPath(clipPath.shift(shadow!.offset), shadowPaint!);
      }
      if (showLoading) {
        final PathMetrics pathMetrics = clipPath.computeMetrics();
        for (PathMetric pathMetric in pathMetrics) {
          final double pathLength = pathMetric.length;
          final double start = pathLength * progress;
          final double end = start + pathLength * 0.05; // 5% of the path length
          final Path extractPath =
              pathMetric.extractPath(start, end % pathLength);
          canvas.drawPath(extractPath, borderPaint);
        }
      } else {
        if (borderPaint.color.value != Colors.transparent.value) {
          canvas.drawPath(clipPath, borderPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
