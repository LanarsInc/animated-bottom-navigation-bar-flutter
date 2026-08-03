import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircularNotchedAndCorneredRectangleClipper extends CustomClipper<Path> {
  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;
  final NotchAreaCache notchAreaCache;
  final GlobalKey navigationBarKey;
  final BuildContext? scaffoldContext;

  CircularNotchedAndCorneredRectangleClipper({
    required this.geometry,
    required this.shape,
    required this.notchMargin,
    required this.notchAreaCache,
    required this.navigationBarKey,
    this.scaffoldContext,
  }) : super(reclip: geometry);

  @override
  Path getClip(Size size) {
    final notchArea = _resolveNotchArea();

    return shape.getOuterPath(
      Offset.zero & size,
      notchArea?.inflate(notchMargin),
    );
  }

  Rect? _resolveNotchArea() {
    try {
      final geometryValue = geometry.value;
      final buttonArea = geometryValue.floatingActionButtonArea;
      final navigationBarOffset = _navigationBarOffsetInScaffold;

      Rect? notchArea;

      if (navigationBarOffset == null) {
        notchArea = buttonArea?.translate(
          0.0,
          geometryValue.bottomNavigationBarTop! * -1.0,
        );
      } else {
        notchArea = buttonArea?.translate(
          navigationBarOffset.dx * -1.0,
          navigationBarOffset.dy * -1.0,
        );
      }
      notchAreaCache.update(notchArea);

      return notchArea;
    } on FlutterError {
      return notchAreaCache.area;
    }
  }

  Offset? get _navigationBarOffsetInScaffold {
    final navigationBarObject =
        navigationBarKey.currentContext?.findRenderObject();
    final scaffoldObject = scaffoldContext?.findRenderObject();

    if ((navigationBarObject is! RenderBox) ||
        (scaffoldObject is! RenderBox) ||
        (!navigationBarObject.hasSize) ||
        (!scaffoldObject.hasSize)) {
      return null;
    }

    return navigationBarObject.localToGlobal(
      Offset.zero,
      ancestor: scaffoldObject,
    );
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
