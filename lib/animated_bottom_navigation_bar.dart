library animatedbottomnavigationbar;

import 'package:animatedbottomnavigationbar/src/navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/circular_notch_and_corner_clipper.dart';
import 'src/circular_notched_and_cornered_shape.dart';
import 'src/exceptions.dart';

class AnimatedBottomNavigationBar extends StatefulWidget {
  final List<IconData> icons;
  final Function(int) onPressed;
  final int activeIndex;
  final double iconSize;
  final double height;
  final double elevation;
  final double notchMargin;
  final double maxSelectionBubbleRadius;
  final int bubbleAnimationSpeedInMilliseconds;
  final double leftCornerRadius;
  final double rightCornerRadius;
  final Color backgroundColor;
  final Color bubbleColor;
  final Color activeColor;
  final Color inactiveColor;
  final Animation<double> notchAndCornersAnimation;
  final NotchSmoothness notchSmoothness;
  final GapLocation gapLocation;
  final double gapWidth;

  AnimatedBottomNavigationBar({
    Key key,
    @required this.icons,
    @required this.activeIndex,
    @required this.onPressed,
    this.height = 56,
    this.elevation = 8,
    this.maxSelectionBubbleRadius = 24,
    this.bubbleAnimationSpeedInMilliseconds = 300,
    this.notchMargin = 8,
    this.backgroundColor = Colors.white,
    this.bubbleColor = Colors.purple,
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
        assert(onPressed != null),
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
      duration: Duration(milliseconds: widget.bubbleAnimationSpeedInMilliseconds),
      vsync: this,
    );

    final bubbleCurve = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.linear,
    );

    Tween<double>(begin: 0, end: 1).animate(bubbleCurve)
      ..addListener(() {
        setState(() {
          _bubbleRadius = widget.maxSelectionBubbleRadius * bubbleCurve.value;
          if (_bubbleRadius == widget.maxSelectionBubbleRadius) {
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
          maxBubbleRadius: widget.maxSelectionBubbleRadius,
          bubbleColor: widget.bubbleColor,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          iconData: widget.icons[i],
          iconScale: _iconScale,
          iconSize: widget.iconSize,
          onPressed: () => widget.onPressed(widget.icons.indexOf(widget.icons[i])),
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
