import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircularNotchedAndCorneredRectangleClipper extends CustomClipper<Path> {
  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;
  final GlobalKey navigationBarKey;
  final BuildContext? scaffoldContext;

  CircularNotchedAndCorneredRectangleClipper({
    required this.geometry,
    required this.shape,
    required this.notchMargin,
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
    final geometryValue = geometry.value;
    final buttonArea = geometryValue.floatingActionButtonArea;
    if (buttonArea == null) {
      return null;
    }

    final navigationBarOffset = _navigationBarOffsetInScaffold;
    if (navigationBarOffset == null) {
      return buttonArea.translate(
        0.0,
        geometryValue.bottomNavigationBarTop! * -1.0,
      );
    }

    return buttonArea.translate(
      navigationBarOffset.dx * -1.0,
      navigationBarOffset.dy * -1.0,
    );
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
