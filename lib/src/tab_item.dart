import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Widget child;

  const TabItem({
    Key key,
    this.iconData,
    this.iconSize,
    this.isActive,
    this.activeColor,
    this.inactiveColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCustomTab = child != null;

    return isCustomTab ? child : _buildDefaultTab();
  }

  Widget _buildDefaultTab() {
    return Icon(
      iconData,
      color: isActive ? activeColor : inactiveColor,
      size: iconSize,
    );
  }
}
