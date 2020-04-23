import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'exceptions.dart';

class CircularNotchedAndCorneredRectangleClipper extends CustomClipper<Path> {
  CircularNotchedAndCorneredRectangleClipper({
    @required this.geometry,
    @required this.shape,
    @required this.notchMargin,
  })  : assert(geometry != null),
        assert(shape != null),
        assert(notchMargin != null),
        super(reclip: geometry);

  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;

  @override
  Path getClip(Size size) {
    if (geometry.value.floatingActionButtonArea != null &&
        geometry.value.floatingActionButtonArea.width !=
            geometry.value.floatingActionButtonArea.height)
      throw IllegalFloatingActionButtonSizeException(
          'Floating action button must be a circle');

    final Rect button = geometry.value.floatingActionButtonArea?.translate(
      0.0,
      geometry.value.bottomNavigationBarTop * -1.0,
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
