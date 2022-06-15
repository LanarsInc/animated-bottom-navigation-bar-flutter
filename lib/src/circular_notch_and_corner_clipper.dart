import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircularNotchedAndCorneredRectangleClipper extends CustomClipper<Path> {
  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;

  CircularNotchedAndCorneredRectangleClipper({
    required this.geometry,
    required this.shape,
    required this.notchMargin,
  }) : super(reclip: geometry);

  @override
  Path getClip(Size size) {
    final Rect? button = geometry.value.floatingActionButtonArea?.translate(
      0.0,
      geometry.value.bottomNavigationBarTop! * -1.0,
    );

    return shape.getOuterPath(Offset.zero & size, button?.inflate(notchMargin));
  }

  @override
  bool shouldReclip(CircularNotchedAndCorneredRectangleClipper oldClipper) {
    return oldClipper.geometry != geometry ||
        oldClipper.shape != shape ||
        oldClipper.notchMargin != notchMargin;
  }
}
