library animatedbottomnavigationbar;

import 'package:animated_bottom_navigation_bar/src/navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/circular_notch_and_corner_clipper.dart';
import 'src/circular_notched_and_cornered_shape.dart';
import 'src/exceptions.dart';

class AnimatedBottomNavigationBar extends StatefulWidget {
  /// Icon data to render in the tab bar.
  final List<IconData> icons;

  /// Handler which is passed every updated active index.
  final Function(int) onTap;

  /// Current index of selected tab bar item.
  final int activeIndex;

  /// Optional custom size for each tab bar icon.
  final double iconSize;

  /// Optional custom tab bar height.
  final double height;

  /// Optional custom tab bar elevation.
  final double elevation;

  /// Optional custom notch margin for Floating
  final double notchMargin;

  /// Optional custom maximum spread radius for splash selection animation.
  final double splashRadius;

  /// Optional custom splash selection animation speed.
  final int splashSpeedInMilliseconds;

  /// Optional custom tab bar top-left corner radius.
  final double leftCornerRadius;

  /// Optional custom tab bar top-right corner radius. Useless with [GapLocation.end].
  final double rightCornerRadius;

  /// Optional custom tab bar background color.
  final Color backgroundColor;

  /// Optional custom splash selection animation color.
  final Color splashColor;

  /// Optional custom currently selected tab bar [IconData] color.
  final Color activeColor;

  /// Optional custom currently unselected tab bar [IconData] color.
  final Color inactiveColor;

  /// Optional custom [Animation] to animate corners and notch appearing.
  final Animation<double> notchAndCornersAnimation;

  /// Optional custom type of notch.
  final NotchSmoothness notchSmoothness;

  /// Location of the free space between tab bar items for notch.
  /// Must have the same location if [FloatingActionButtonLocation.centerDocked] or [FloatingActionButtonLocation.endDocked].
  final GapLocation gapLocation;

  /// Free space width between tab bar items.
  final double gapWidth;

  AnimatedBottomNavigationBar({
    Key key,
    @required this.icons,
    @required this.activeIndex,
    @required this.onTap,
    this.height = 56,
    this.elevation = 8,
    this.splashRadius = 24,
    this.splashSpeedInMilliseconds = 300,
    this.notchMargin = 8,
    this.backgroundColor = Colors.white,
    this.splashColor = Colors.purple,
    this.activeColor = Colors.deepPurpleAccent,
    this.inactiveColor = Colors.black,
    this.notchAndCornersAnimation,
    this.leftCornerRadius = 0,
    this.rightCornerRadius = 0,
    this.iconSize = 24,
    this.notchSmoothness = NotchSmoothness.softEdge,
    this.gapLocation = GapLocation.none,
    this.gapWidth = 64,
  })  : assert(icons != null),
        assert(icons.length >= 2 && icons.length <= 5),
        assert(activeIndex != null),
        assert(onTap != null),
        super(key: key) {
    if (gapLocation == GapLocation.end) {
      if (rightCornerRadius != 0)
        throw NonAppropriatePathException(
            'RightCornerRadius along with ${GapLocation.end} or/and ${FloatingActionButtonLocation.endDocked} causes render issue => '
            'consider set rightCornerRadius to 0.');
    }
    if (gapLocation == GapLocation.center) {
      if (icons.length % 2 != 0)
        throw NonAppropriatePathException('Odd count of icons along with $gapLocation causes render issue => '
            'consider set gapLocation to ${GapLocation.end}');
    }
  }

  @override
  _AnimatedBottomNavigationBarState createState() => _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  ValueListenable<ScaffoldGeometry> geometryListenable;
  AnimationController _bubbleController;
  double _bubbleRadius = 0;
  double _iconScale = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);
    if (widget.notchAndCornersAnimation != null) {
      widget.notchAndCornersAnimation..addListener(() => setState(() {}));
    }
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
      duration: Duration(milliseconds: widget.splashSpeedInMilliseconds),
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
      elevation: widget.elevation,
      color: Colors.transparent,
      clipper: CircularNotchedAndCorneredRectangleClipper(
        shape: CircularNotchedAndCorneredRectangle(
          animation: widget.notchAndCornersAnimation,
          notchSmoothness: widget.notchSmoothness,
          gapLocation: widget.gapLocation,
          leftCornerRadius: widget.leftCornerRadius,
          rightCornerRadius: widget.rightCornerRadius,
        ),
        geometry: geometryListenable,
        notchMargin: widget.notchMargin,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: widget.backgroundColor,
        child: SafeArea(
          child: Container(
            height: widget.height,
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
    List items = <Widget>[];
    for (var i = 0; i < widget.icons.length; i++) {
      if (widget.gapLocation == GapLocation.center && i == widget.icons.length / 2) {
        items.add(
          GapItem(
            width: widget.gapWidth * widget.notchAndCornersAnimation.value,
          ),
        );
      }

      items.add(
        NavigationBarItem(
          isActive: i == widget.activeIndex,
          bubbleRadius: _bubbleRadius,
          maxBubbleRadius: widget.splashRadius,
          bubbleColor: widget.splashColor,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          iconData: widget.icons[i],
          iconScale: _iconScale,
          iconSize: widget.iconSize,
          onTap: () => widget.onTap(widget.icons.indexOf(widget.icons[i])),
        ),
      );

      if (widget.gapLocation == GapLocation.end && i == widget.icons.length - 1) {
        items.add(
          GapItem(
            width: widget.gapWidth * widget.notchAndCornersAnimation.value,
          ),
        );
      }
    }
    return items;
  }
}

enum NotchSmoothness { defaultEdge, softEdge, smoothEdge, verySmoothEdge }

enum GapLocation { none, center, end }
