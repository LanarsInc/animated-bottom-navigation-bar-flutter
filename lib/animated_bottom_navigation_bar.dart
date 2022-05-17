library animated_bottom_navigation_bar;

import 'package:animated_bottom_navigation_bar/src/navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/circular_notch_and_corner_clipper.dart';
import 'src/circular_notched_and_cornered_shape.dart';
import 'src/exceptions.dart';
import 'src/gap_item.dart';

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

  /// Optional custom tab bar elevation. Default is 8.
  final double? elevation;

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

  /// Whether to avoid system intrusions on the left.
  final bool safeAreaLeft;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool safeAreaTop;

  /// Whether to avoid system intrusions on the right.
  final bool safeAreaRight;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool safeAreaBottom;

  AnimatedBottomNavigationBar._internal({
    Key? key,
    required this.activeIndex,
    required this.onTap,
    this.tabBuilder,
    this.itemCount,
    this.icons,
    this.height,
    this.elevation,
    this.splashRadius = 24,
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
    this.safeAreaLeft = true,
    this.safeAreaTop = true,
    this.safeAreaRight = true,
    this.safeAreaBottom = true,
  })  : assert(icons != null || itemCount != null),
        assert(((itemCount ?? icons!.length) >= 2) &&
            ((itemCount ?? icons!.length) <= 5)),
        super(key: key) {
    if (gapLocation == GapLocation.end) {
      if (rightCornerRadius != 0)
        throw NonAppropriatePathException(
            'RightCornerRadius along with ${GapLocation.end} or/and ${FloatingActionButtonLocation.endDocked} causes render issue => '
            'consider set rightCornerRadius to 0.');
    }
    if (gapLocation == GapLocation.center) {
      if ((itemCount ?? icons!.length) % 2 != 0)
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
    double? elevation,
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
    bool safeAreaLeft = true,
    bool safeAreaTop = true,
    bool safeAreaRight = true,
    bool safeAreaBottom = true,
  }) : this._internal(
          key: key,
          icons: icons,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          elevation: elevation,
          splashRadius: splashRadius ?? 24,
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
          safeAreaLeft: safeAreaLeft,
          safeAreaTop: safeAreaTop,
          safeAreaRight: safeAreaRight,
          safeAreaBottom: safeAreaBottom,
        );

  AnimatedBottomNavigationBar.builder({
    Key? key,
    required int itemCount,
    required IndexedWidgetBuilder tabBuilder,
    required int activeIndex,
    required Function(int) onTap,
    double? height,
    double? elevation,
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
    bool safeAreaLeft = true,
    bool safeAreaTop = true,
    bool safeAreaRight = true,
    bool safeAreaBottom = true,
  }) : this._internal(
          key: key,
          tabBuilder: tabBuilder,
          itemCount: itemCount,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          elevation: elevation,
          splashRadius: splashRadius ?? 24,
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
          safeAreaLeft: safeAreaLeft,
          safeAreaTop: safeAreaTop,
          safeAreaRight: safeAreaRight,
          safeAreaBottom: safeAreaBottom,
        );

  @override
  _AnimatedBottomNavigationBarState createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  late ValueListenable<ScaffoldGeometry> geometryListenable;
  late AnimationController _bubbleController;
  double _bubbleRadius = 0;
  double _iconScale = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);

    widget.notchAndCornersAnimation?..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(AnimatedBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex) {
      _startBubbleAnimation();
    }
  }

  _startBubbleAnimation() {
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
            _iconScale = 1 + bubbleCurve.value;
          } else {
            _iconScale = 2 - bubbleCurve.value;
          }
        });
      });

    if (_bubbleController.isAnimating) {
      _bubbleController.reset();
    }
    _bubbleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      elevation: widget.elevation ?? 8,
      color: Colors.transparent,
      clipper: CircularNotchedAndCorneredRectangleClipper(
        shape: CircularNotchedAndCorneredRectangle(
          animation: widget.notchAndCornersAnimation,
          notchSmoothness:
              widget.notchSmoothness ?? NotchSmoothness.defaultEdge,
          gapLocation: widget.gapLocation ?? GapLocation.end,
          leftCornerRadius: widget.leftCornerRadius ?? 0.0,
          rightCornerRadius: widget.rightCornerRadius ?? 0.0,
        ),
        geometry: geometryListenable,
        notchMargin: widget.notchMargin ?? 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: widget.backgroundColor ?? Colors.white,
        child: SafeArea(
          left: widget.safeAreaLeft,
          top: widget.safeAreaTop,
          right: widget.safeAreaRight,
          bottom: widget.safeAreaBottom,
          child: Container(
            height: widget.height ?? 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: _buildItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    final gapWidth = widget.gapWidth ?? 72;
    final gapItemWidth = widget.notchAndCornersAnimation != null
        ? gapWidth * widget.notchAndCornersAnimation!.value
        : gapWidth;
    final itemCount = widget.itemCount ?? widget.icons!.length;

    List items = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      final isActive = i == widget.activeIndex;

      if (widget.gapLocation == GapLocation.center && i == itemCount / 2) {
        items.add(
          GapItem(
            width: gapItemWidth,
          ),
        );
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
        items.add(
          GapItem(
            width: gapItemWidth,
          ),
        );
      }
    }
    return items as List<Widget>;
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
