library animated_bottom_navigation_bar;

import 'dart:ui';

import 'package:animated_bottom_navigation_bar/src/around_custom_painter.dart';
import 'package:animated_bottom_navigation_bar/src/circular_notch_and_corner_clipper.dart';
import 'package:animated_bottom_navigation_bar/src/circular_notched_and_cornered_shape.dart';
import 'package:animated_bottom_navigation_bar/src/exceptions.dart';
import 'package:animated_bottom_navigation_bar/src/gap_item.dart';
import 'package:animated_bottom_navigation_bar/src/navigation_bar_item.dart';
import 'package:animated_bottom_navigation_bar/src/safe_area_values.dart';
import 'package:animated_bottom_navigation_bar/src/visible_animator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

export 'package:animated_bottom_navigation_bar/src/safe_area_values.dart';

/// Signature for a function that creates a widget for a given index & state.
/// Used by [AnimatedBottomNavigationBar.builder].
typedef IndexedWidgetBuilder = Widget Function(int index, bool isActive);

class AnimatedBottomNavigationBar extends StatefulWidget {
  /// Widgets to render in the tab bar.
  final IndexedWidgetBuilder? tabBuilder;

  /// Total item count.
  final int? itemCount;

  /// Icon data to render in the tab bar.
  final List<IconData>? icons;

  /// Handler which is passed every updated active index.
  final Function(int) onTap;

  /// Current index of selected tab bar item.
  final int activeIndex;

  /// Optional custom size for each tab bar icon. Default is 24.
  final double? iconSize;

  /// Optional custom tab bar height. Default is 56.
  final double? height;

  /// Optional custom notch margin for Floating. Default is 8.
  final double? notchMargin;

  /// Optional custom maximum spread radius for splash selection animation. Default is 24.
  final double splashRadius;

  /// Optional custom splash selection animation speed. Default is 300 milliseconds.
  final int? splashSpeedInMilliseconds;

  /// Optional custom tab bar top-left corner radius. Default is 0.
  final double? leftCornerRadius;

  /// Optional custom tab bar top-right corner radius. Useless with [GapLocation.end]. Default is 0.
  final double? rightCornerRadius;

  /// Optional custom tab bar background color. Default is [Colors.white].
  final Color? backgroundColor;

  /// Optional custom splash selection animation color. Default is [Colors.purple].
  final Color? splashColor;

  /// Optional custom currently selected tab bar [IconData] color. Default is [Colors.deepPurpleAccent]
  final Color? activeColor;

  /// Optional custom currently unselected tab bar [IconData] color. Default is [Colors.black]
  final Color? inactiveColor;

  /// Optional custom [Animation] to animate corners and notch appearing.
  final Animation<double>? notchAndCornersAnimation;

  /// Optional custom type of notch. Default is [NotchSmoothness.defaultEdge].
  final NotchSmoothness? notchSmoothness;

  /// Location of the free space between tab bar items for notch.
  /// Must have the same location if [FloatingActionButtonLocation.centerDocked] or [FloatingActionButtonLocation.endDocked].
  /// Default is [GapLocation.end].
  final GapLocation? gapLocation;

  /// Free space width between tab bar items. The preferred width is equal to total width of [FloatingActionButton] and double [notchMargin].
  /// Default is 72.
  final double? gapWidth;

  /// Optional custom tab bar elevation. Default is 8.
  final double? elevation;

  /// Optional custom shadow around the navigation bar.
  final Shadow? shadow;

  /// Specifies whether to avoid system intrusions for specific sides
  final SafeAreaValues safeAreaValues;

  ///The [Curve] that the hide animation will follow.
  ///Defaults to [Curves.fastOutSlowIn],
  final Curve? hideAnimationCurve;

  /// Optional custom border color around the navigation bar. Default is [Colors.transparent].
  final Color? borderColor;

  /// Optional custom border width around the navigation bar. Default is 2.0.
  final double? borderWidth;

  /// Optional hide bottom bar animation controller
  final AnimationController? hideAnimationController;

  /// Optional background gradient.
  ///
  /// If this is specified, [backgroundColor] has no effect.
  final Gradient? backgroundGradient;

  /// Whether blur effect should be applied.
  ///
  /// Makes sense only if [backgroundColor] opacity is < 1.
  final bool blurEffect;

  /// Filter to apply blurring effect.
  final ImageFilter? blurFilter;

  /// Optional scale effect factor. Default is 1.
  ///
  /// To disable scale effect set value of 0.
  final double scaleFactor;

  static const _defaultSplashRadius = 24.0;

  AnimatedBottomNavigationBar._internal(
      {Key? key,
      required this.activeIndex,
      required this.onTap,
      this.tabBuilder,
      this.itemCount,
      this.icons,
      this.height,
      this.splashRadius = _defaultSplashRadius,
      this.splashSpeedInMilliseconds,
      this.notchMargin,
      this.backgroundColor,
      this.splashColor,
      this.activeColor,
      this.inactiveColor,
      this.notchAndCornersAnimation,
      this.leftCornerRadius,
      this.rightCornerRadius,
      this.iconSize,
      this.notchSmoothness,
      this.gapLocation,
      this.gapWidth,
      this.elevation,
      this.shadow,
      this.borderColor,
      this.borderWidth,
      this.safeAreaValues = const SafeAreaValues(),
      this.hideAnimationCurve,
      this.hideAnimationController,
      this.backgroundGradient,
      this.blurEffect = false,
      this.blurFilter,
      this.scaleFactor = 1.0})
      : assert(icons != null || itemCount != null),
        assert(
          ((itemCount ?? icons!.length) >= 2) &&
              ((itemCount ?? icons!.length) <= 5),
        ),
        super(key: key) {
    if (gapLocation == GapLocation.end) {
      if (rightCornerRadius != 0)
        throw NonAppropriatePathException(
            'RightCornerRadius along with ${GapLocation.end} or/and ${FloatingActionButtonLocation.endDocked} causes render issue => '
            'consider set rightCornerRadius to 0.');
    }
    if (gapLocation == GapLocation.center) {
      final iconsCountIsOdd = (itemCount ?? icons!.length).isOdd;
      if (iconsCountIsOdd)
        throw NonAppropriatePathException(
            'Odd count of icons along with $gapLocation causes render issue => '
            'consider set gapLocation to ${GapLocation.end}');
    }
  }

  AnimatedBottomNavigationBar({
    Key? key,
    required List<IconData> icons,
    required int activeIndex,
    required Function(int) onTap,
    double? height,
    double? splashRadius,
    int? splashSpeedInMilliseconds,
    double? notchMargin,
    Color? backgroundColor,
    Color? splashColor,
    Color? activeColor,
    Color? inactiveColor,
    Animation<double>? notchAndCornersAnimation,
    double? leftCornerRadius,
    double? rightCornerRadius,
    double? iconSize,
    NotchSmoothness? notchSmoothness,
    GapLocation? gapLocation,
    double? gapWidth,
    double? elevation,
    Shadow? shadow,
    Color? borderColor,
    double? borderWidth,
    SafeAreaValues safeAreaValues = const SafeAreaValues(),
    Curve? hideAnimationCurve,
    AnimationController? hideAnimationController,
    Gradient? backgroundGradient,
    ImageFilter? imageFilter,
    bool blurEffect = false,
    double scaleFactor = 1.0,
  }) : this._internal(
          key: key,
          icons: icons,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          splashRadius: splashRadius ?? _defaultSplashRadius,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          notchMargin: notchMargin,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          notchAndCornersAnimation: notchAndCornersAnimation,
          leftCornerRadius: leftCornerRadius ?? 0,
          rightCornerRadius: rightCornerRadius ?? 0,
          iconSize: iconSize,
          notchSmoothness: notchSmoothness,
          gapLocation: gapLocation ?? GapLocation.end,
          gapWidth: gapWidth,
          elevation: elevation,
          shadow: shadow,
          borderColor: borderColor,
          borderWidth: borderWidth,
          safeAreaValues: safeAreaValues,
          hideAnimationCurve: hideAnimationCurve,
          hideAnimationController: hideAnimationController,
          backgroundGradient: backgroundGradient,
          blurFilter: imageFilter,
          blurEffect: blurEffect,
          scaleFactor: scaleFactor,
        );

  AnimatedBottomNavigationBar.builder({
    Key? key,
    required int itemCount,
    required IndexedWidgetBuilder tabBuilder,
    required int activeIndex,
    required Function(int) onTap,
    double? height,
    double? splashRadius,
    int? splashSpeedInMilliseconds,
    double? notchMargin,
    Color? backgroundColor,
    Color? splashColor,
    Animation<double>? notchAndCornersAnimation,
    double? leftCornerRadius,
    double? rightCornerRadius,
    NotchSmoothness? notchSmoothness,
    GapLocation? gapLocation,
    double? gapWidth,
    double? elevation,
    Shadow? shadow,
    Color? borderColor,
    double? borderWidth,
    SafeAreaValues safeAreaValues = const SafeAreaValues(),
    Curve? hideAnimationCurve,
    AnimationController? hideAnimationController,
    Gradient? backgroundGradient,
    bool blurEffect = false,
    ImageFilter? imageFilter,
    double scaleFactor = 1.0,
  }) : this._internal(
          key: key,
          tabBuilder: tabBuilder,
          itemCount: itemCount,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          splashRadius: splashRadius ?? _defaultSplashRadius,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          notchMargin: notchMargin,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          notchAndCornersAnimation: notchAndCornersAnimation,
          leftCornerRadius: leftCornerRadius ?? 0,
          rightCornerRadius: rightCornerRadius ?? 0,
          notchSmoothness: notchSmoothness,
          gapLocation: gapLocation ?? GapLocation.end,
          gapWidth: gapWidth,
          elevation: elevation,
          shadow: shadow,
          borderColor: borderColor,
          borderWidth: borderWidth,
          safeAreaValues: safeAreaValues,
          hideAnimationCurve: hideAnimationCurve,
          hideAnimationController: hideAnimationController,
          backgroundGradient: backgroundGradient,
          blurEffect: blurEffect,
          blurFilter: imageFilter,
          scaleFactor: scaleFactor,
        );

  @override
  _AnimatedBottomNavigationBarState createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  late ValueListenable<ScaffoldGeometry> geometryListenable;

  late final AnimationController _bubbleController;

  double _bubbleRadius = 0;
  double _iconScale = 1;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      duration: Duration(milliseconds: widget.splashSpeedInMilliseconds ?? 300),
      vsync: this,
    );

    final bubbleCurve = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.linear,
    );

    Tween<double>(begin: 0, end: 1).animate(bubbleCurve)
      ..addListener(() {
        setState(() {
          _bubbleRadius = widget.splashRadius * bubbleCurve.value;
          if (_bubbleRadius == widget.splashRadius) {
            _bubbleRadius = 0;
          }

          if (bubbleCurve.value < 0.5) {
            _iconScale = 1 + bubbleCurve.value * widget.scaleFactor;
          } else {
            _iconScale =
                1 + widget.scaleFactor - bubbleCurve.value * widget.scaleFactor;
          }
        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);

    widget.notchAndCornersAnimation?..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(AnimatedBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeIndex != oldWidget.activeIndex) {
      _startBubbleAnimation();
    }
  }

  _startBubbleAnimation() {
    // Stop animation if it's currently running
    if (_bubbleController.isAnimating) {
      _bubbleController.reset();
    }
    _bubbleController.forward(from: 0);
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clipper = CircularNotchedAndCorneredRectangleClipper(
      shape: CircularNotchedAndCorneredRectangle(
        animation: widget.notchAndCornersAnimation,
        notchSmoothness: widget.notchSmoothness ?? NotchSmoothness.defaultEdge,
        gapLocation: widget.gapLocation ?? GapLocation.end,
        leftCornerRadius: widget.leftCornerRadius ?? 0.0,
        rightCornerRadius: widget.rightCornerRadius ?? 0.0,
      ),
      geometry: geometryListenable,
      notchMargin: widget.notchMargin ?? 8,
    );

    return PhysicalShape(
      elevation: widget.elevation ?? 8,
      color: Colors.transparent,
      clipper: clipper,
      child: AroundCustomPainter(
        clipper: clipper,
        shadow: widget.shadow,
        borderColor: widget.borderColor ?? Colors.transparent,
        borderWidth: widget.borderWidth ?? 2,
        child: widget.hideAnimationController != null
            ? VisibleAnimator(
                showController: widget.hideAnimationController!,
                curve: widget.hideAnimationCurve ?? Curves.fastOutSlowIn,
                child: _buildBottomBar(context),
              )
            : _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: widget.backgroundGradient),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: widget.backgroundGradient != null
            ? Colors.transparent
            : widget.backgroundColor ?? Colors.white,
        child: SafeArea(
          top: widget.safeAreaValues.top,
          bottom: widget.safeAreaValues.bottom,
          left: widget.safeAreaValues.left,
          right: widget.safeAreaValues.right,
          child: widget.blurEffect
              ? ClipRect(
                  child: BackdropFilter(
                    filter: widget.blurFilter ??
                        ImageFilter.blur(sigmaX: 5, sigmaY: 10),
                    child: _buildBody(context),
                  ),
                )
              : _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final bottomPadding =
        widget.safeAreaValues.bottom ? 0 : MediaQuery.paddingOf(context).bottom;
    return Container(
      height: (widget.height ?? kBottomNavigationBarHeight) + bottomPadding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        gradient: widget.backgroundGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: _buildItems(),
      ),
    );
  }

  List<Widget> _buildItems() {
    final gapWidth = widget.gapWidth ?? 72;
    final gapItemWidth = widget.notchAndCornersAnimation != null
        ? gapWidth * widget.notchAndCornersAnimation!.value
        : gapWidth;
    final itemCount = widget.itemCount ?? widget.icons!.length;

    final items = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      final isActive = i == widget.activeIndex;

      if (widget.gapLocation == GapLocation.center && i == itemCount / 2) {
        items.add(GapItem(width: gapItemWidth));
      }

      items.add(
        NavigationBarItem(
          isActive: isActive,
          bubbleRadius: _bubbleRadius,
          maxBubbleRadius: widget.splashRadius,
          bubbleColor: widget.splashColor,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          child: widget.tabBuilder?.call(i, isActive),
          iconData: widget.icons?.elementAt(i),
          iconScale: _iconScale,
          iconSize: widget.iconSize,
          onTap: () => widget.onTap(i),
        ),
      );

      if (widget.gapLocation == GapLocation.end && i == itemCount - 1) {
        items.add(GapItem(width: gapItemWidth));
      }
    }
    return items;
  }
}

enum NotchSmoothness {
  sharpEdge,
  defaultEdge,
  softEdge,
  smoothEdge,
  verySmoothEdge
}

enum GapLocation { none, center, end }
