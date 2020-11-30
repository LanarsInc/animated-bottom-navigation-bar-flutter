import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animated_bottom_navigation_bar/src/bubble_selection_painter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NavigationBarItem extends StatelessWidget {
  final bool isActive;
  final double bubbleRadius;
  final double maxBubbleRadius;
  final Color bubbleColor;
  final Color activeColor;
  final Color inactiveColor;
  final IconData iconData;
  final double iconScale;
  final double iconSize;
  final AutoSizeGroup autoSizeGroup;
  final String labelData;
  final LabelOptions labelOptions;
  final VoidCallback onTap;

  NavigationBarItem({
    this.isActive,
    this.bubbleRadius,
    this.maxBubbleRadius,
    this.bubbleColor,
    this.activeColor,
    this.inactiveColor,
    this.iconData,
    this.iconScale,
    this.iconSize,
    this.onTap,
    this.autoSizeGroup,
    this.labelData,
    this.labelOptions,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final hasLabel = labelData != null;

    final labelStyle = labelOptions.mutateLabelColor
        ? labelOptions.textStyle.copyWith(
            color: isActive ? activeColor : inactiveColor,
          )
        : labelOptions.textStyle;

    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: CustomPaint(
          painter: BubblePainter(
            bubbleRadius: isActive ? bubbleRadius : 0,
            bubbleColor: bubbleColor,
            maxBubbleRadius: maxBubbleRadius,
          ),
          child: InkWell(
            child: Transform.scale(
              scale: isActive ? iconScale : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: isActive ? activeColor : inactiveColor,
                    size: iconSize,
                  ),
                  hasLabel
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: 8,
                            top: 4,
                            right: 8,
                          ),
                          child: AutoSizeText(
                            labelData,
                            maxLines: 1,
                            style: labelStyle,
                            minFontSize: labelOptions.minFontSize,
                            overflow: labelOptions.textOverflow,
                            group: autoSizeGroup,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class GapItem extends StatelessWidget {
  final double width;

  GapItem({this.width});

  @override
  Widget build(BuildContext context) => Container(width: width);
}
