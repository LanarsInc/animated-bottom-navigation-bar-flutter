import 'package:flutter/material.dart';

@immutable
class AroundCustomPainter extends StatelessWidget {
  final CustomClipper<Path> clipper;

  final Shadow? shadow;

  final double borderWidth;
  final Color borderColor;

  final Widget child;

  AroundCustomPainter({
    required this.clipper,
    required this.borderWidth,
    required this.borderColor,
    required this.child,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _AroundCustomPainter(
        clipper: this.clipper,
        shadow: this.shadow,
        borderColor: this.borderColor,
        borderWidth: this.borderWidth,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _AroundCustomPainter extends CustomPainter {
  final CustomClipper<Path> clipper;

  final Shadow? shadow;
  final double borderWidth;
  final Color borderColor;

  _AroundCustomPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.clipper,
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
      if (borderPaint.color.value != Colors.transparent.value) {
        canvas.drawPath(clipPath, borderPaint);
      }
      if (shadow != null && shadow!.color.value != Colors.transparent.value) {
        canvas.drawPath(clipPath.shift(shadow!.offset), shadowPaint!);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
