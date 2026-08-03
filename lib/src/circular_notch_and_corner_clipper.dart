import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircularNotchedAndCorneredRectangleClipper extends CustomClipper<Path> {
  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;
  final NotchAreaCache notchAreaCache;

  CircularNotchedAndCorneredRectangleClipper({
    required this.geometry,
    required this.shape,
    required this.notchMargin,
    required this.notchAreaCache,
  }) : super(reclip: geometry);

  @override
  Path getClip(Size size) {
    final notchArea = _resolveNotchArea();

    return shape.getOuterPath(
      Offset.zero & size,
      notchArea?.inflate(notchMargin),
    );
  }

  /// Area occupied by the [FloatingActionButton], relative to the top left
  /// corner of the navigation bar, or `null` when there is nothing to notch
  /// around.
  Rect? _resolveNotchArea() {
    try {
      final geometryValue = geometry.value;
      final notchArea = geometryValue.floatingActionButtonArea?.translate(
        0.0,
        geometryValue.bottomNavigationBarTop! * -1.0,
      );
      notchAreaCache.update(notchArea);

      return notchArea;
    } on FlutterError {
      return notchAreaCache.area;
    }
  }

  @override
  bool shouldReclip(CircularNotchedAndCorneredRectangleClipper oldClipper) {
    return oldClipper.geometry != geometry ||
        oldClipper.shape != shape ||
        oldClipper.notchMargin != notchMargin;
  }
}

/// Keeps the area the notch was last built around.
///
/// The area comes from [ScaffoldGeometry], which the framework only allows to
/// be read while painting. Clip paths however are also built outside of the
/// paint phase, so the last painted area is remembered to build the very same
/// path in that case.
class NotchAreaCache {
  Rect? _area;

  Rect? get area => _area;

  void update(Rect? area) => _area = area;
}
