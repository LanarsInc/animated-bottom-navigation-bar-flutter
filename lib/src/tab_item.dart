import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final IconData? iconData;
  final double? iconSize;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;
  final Widget? child;

  const TabItem({
    Key? key,
    required this.isActive,
    this.iconData,
    this.iconSize = 24,
    this.activeColor = Colors.deepPurpleAccent,
    this.inactiveColor = Colors.black,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => child ?? _buildDefaultTab();

  Widget _buildDefaultTab() {
    return Icon(
      iconData,
      color: isActive ? activeColor : inactiveColor,
      size: iconSize,
    );
  }
}
