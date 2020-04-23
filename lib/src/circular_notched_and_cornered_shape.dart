import 'dart:math' as math;

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import 'exceptions.dart';

class CircularNotchedAndCorneredRectangle extends NotchedShape {
  /// Creates a [CircularNotchedAndCorneredRectangle].
  ///
  /// The same object can be used to create multiple shapes.
  final Animation<double> animation;
  final NotchSmoothness notchSmoothness;
  final GapLocation gapLocation;
  final double leftCornerRadius;
  final double rightCornerRadius;

  CircularNotchedAndCorneredRectangle({
    this.animation,
    this.notchSmoothness,
    this.gapLocation,
    this.leftCornerRadius,
    this.rightCornerRadius,
  });

  /// Creates a [Path] that describes a rectangle with a smooth circular notch.
  ///
  /// `host` is the bounding box for the returned shape. Conceptually this is
  /// the rectangle to which the notch will be applied.
  ///
  /// `guest` is the bounding box of a circle that the notch accommodates. All
  /// points in the circle bounded by `guest` will be outside of the returned
  /// path.
  ///
  /// The notch is curve that smoothly connects the host's top edge and
  /// the guest circle.
  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (guest == null || !host.overlaps(guest)) {
      if (this.rightCornerRadius > 0 || this.leftCornerRadius > 0) {
        double leftCornerRadius = this.leftCornerRadius * (animation?.value ?? 1);
        double rightCornerRadius = this.rightCornerRadius * (animation?.value ?? 1);
        return Path()
          ..moveTo(host.left, host.top)
          ..arcTo(
            Rect.fromLTWH(host.left, host.top, leftCornerRadius * 2, leftCornerRadius * 2),
            _degreeToRadians(180),
            _degreeToRadians(90),
            false,
          )
          ..lineTo(host.right - host.height, host.top)
          ..arcTo(
            Rect.fromLTWH(host.right - rightCornerRadius * 2, host.top, rightCornerRadius * 2, rightCornerRadius * 2),
            _degreeToRadians(270),
            _degreeToRadians(90),
            false,
          )
          ..lineTo(host.right, host.bottom)
          ..lineTo(host.left, host.bottom)
          ..close();
      }
      return Path()..addRect(host);
    }

    if (guest.center.dx == host.width / 2) {
      if (gapLocation != GapLocation.center)
        throw GapLocationException('Wrong gap location in $AnimatedBottomNavigationBar towards FloatingActionButtonLocation => '
            'consider use ${GapLocation.center} instead of $gapLocation or change FloatingActionButtonLocation');
    }

    if (guest.center.dx != host.width / 2) {
      if (gapLocation != GapLocation.end)
        throw GapLocationException('Wrong gap location in $AnimatedBottomNavigationBar towards FloatingActionButtonLocation => '
            'consider use ${GapLocation.end} instead of $gapLocation or change FloatingActionButtonLocation');
    }

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    double notchRadius = guest.width / 2 * (animation?.value ?? 1);
    double leftCornerRadius = this.leftCornerRadius * (animation?.value ?? 1);
    double rightCornerRadius = this.rightCornerRadius * (animation?.value ?? 1);

    // We build a path for the notch from 3 segments:
    // Segment A - a Bezier curve from the host's top edge to segment B.
    // Segment B - an arc with radius notchRadius.
    // Segment C - a Bezier curve from segment B back to the host's top edge.
    //
    // A detailed explanation and the derivation of the formulas below is
    // available at: https://goo.gl/Ufzrqn

    final double s1 = notchSmoothness.s1;
    final double s2 = notchSmoothness.s2;

    double r = notchRadius;
    double a = -1.0 * r - s2;
    double b = host.top - guest.center.dy;

    double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    double p2yA = math.sqrt(r * r - p2xA * p2xA);
    double p2yB = math.sqrt(r * r - p2xB * p2xB);

    List<Offset> p = List<Offset>(6);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1) p[i] += guest.center;

    return Path()
      ..moveTo(host.left, host.top)
      ..arcTo(
        Rect.fromLTWH(host.left, host.top, leftCornerRadius * 2, leftCornerRadius * 2),
        _degreeToRadians(180),
        _degreeToRadians(90),
        false,
      )
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right - host.height, host.top)
      ..arcTo(
        Rect.fromLTWH(host.right - rightCornerRadius * 2, host.top, rightCornerRadius * 2, rightCornerRadius * 2),
        _degreeToRadians(270),
        _degreeToRadians(90),
        false,
      )
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

double _degreeToRadians(double degree) {
  final double radian = (math.pi / 180) * degree;
  return radian;
}

extension on NotchSmoothness {
  static const curveS1 = {
    NotchSmoothness.defaultEdge: 15.0,
    NotchSmoothness.softEdge: 20.0,
    NotchSmoothness.smoothEdge: 30.0,
    NotchSmoothness.verySmoothEdge: 40.0,
  };

  static const curveS2 = {
    NotchSmoothness.defaultEdge: 1.0,
    NotchSmoothness.softEdge: 5.0,
    NotchSmoothness.smoothEdge: 15.0,
    NotchSmoothness.verySmoothEdge: 25.0,
  };

  double get s1 => curveS1[this];

  double get s2 => curveS2[this];
}
