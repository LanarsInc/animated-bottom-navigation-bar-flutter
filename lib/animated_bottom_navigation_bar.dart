library animated_bottom_navigation_bar;

import 'package:animated_bottom_navigation_bar/src/navigation_bar_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/circular_notch_and_corner_clipper.dart';
import 'src/circular_notched_and_cornered_shape.dart';
import 'src/exceptions.dart';

part 'src/model/label_options.dart';

class AnimatedBottomNavigationBar extends StatefulWidget {
  /// Icon data to render in the tab bar.
  final List<IconData> icons;

  /// Optional label data to render in the tab bar.
  final List<String> labels;

  /// Optional set of the label options.
  final LabelOptions labelOptions;

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

  /// Free space width between tab bar items. The preferred width is equal to total width of [FloatingActionButton] and double [notchMargin].
  final double gapWidth;

  AnimatedBottomNavigationBar._internal({
    Key key,
    @required this.icons,
    @required this.activeIndex,
    @required this.onTap,
    this.labels,
    this.labelOptions,
    this.height,
    this.elevation,
    this.splashRadius,
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
  })  : assert(icons != null),
        assert(icons.length >= 2 && icons.length <= 5),
        assert(labels == null || (icons.length == labels.length)),
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

  AnimatedBottomNavigationBar({
    Key key,
    @required List<IconData> icons,
    @required int activeIndex,
    @required Function(int) onTap,
    List<String> labels,
    LabelOptions labelOptions,
    double height = 56,
    double elevation = 8,
    double splashRadius = 24,
    int splashSpeedInMilliseconds = 300,
    double notchMargin = 8,
    Color backgroundColor = Colors.white,
    Color splashColor = Colors.purple,
    Color activeColor = Colors.deepPurpleAccent,
    Color inactiveColor = Colors.black,
    Animation<double> notchAndCornersAnimation,
    double leftCornerRadius = 0,
    double rightCornerRadius = 0,
    double iconSize = 24,
    NotchSmoothness notchSmoothness = NotchSmoothness.defaultEdge,
    GapLocation gapLocation = GapLocation.end,
    double gapWidth = 72,
  }) : this._internal(
          key: key,
          icons: icons,
          activeIndex: activeIndex,
          onTap: onTap,
          labels: labels,
          labelOptions: labelOptions,
          height: height,
          elevation: elevation,
          splashRadius: splashRadius,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          notchMargin: notchMargin,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          notchAndCornersAnimation: notchAndCornersAnimation,
          leftCornerRadius: leftCornerRadius,
          rightCornerRadius: rightCornerRadius,
          iconSize: iconSize,
          notchSmoothness: notchSmoothness,
          gapLocation: gapLocation,
          gapWidth: gapWidth,
        );

  @override
  _AnimatedBottomNavigationBarState createState() => _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  ValueListenable<ScaffoldGeometry> geometryListenable;
  AnimationController _bubbleController;
  double _bubbleRadius = 0;
  double _iconScale = 1;
  final autoSizeLabelGroup = AutoSizeGroup();

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
    final gapItemWidth = widget.notchAndCornersAnimation != null ? widget.gapWidth * widget.notchAndCornersAnimation.value : widget.gapWidth;

    List items = <Widget>[];
    for (var i = 0; i < widget.icons.length; i++) {
      if (widget.gapLocation == GapLocation.center && i == widget.icons.length / 2) {
        items.add(
          GapItem(
            width: gapItemWidth,
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
          labelData: widget.labels?.elementAt(i),
          labelOptions: widget.labelOptions ?? LabelOptions(),
          iconScale: _iconScale,
          iconSize: widget.iconSize,
          autoSizeGroup: autoSizeLabelGroup,
          onTap: () => widget.onTap(widget.icons.indexOf(widget.icons[i])),
        ),
      );

      if (widget.gapLocation == GapLocation.end && i == widget.icons.length - 1) {
        items.add(
          GapItem(
            width: gapItemWidth,
          ),
        );
      }
    }
    return items;
  }
}

enum NotchSmoothness { sharpEdge, defaultEdge, softEdge, smoothEdge, verySmoothEdge }

enum GapLocation { none, center, end }
