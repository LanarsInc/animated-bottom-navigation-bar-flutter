import 'package:flutter/material.dart';

class GapItem extends StatelessWidget {
  final double width;

  GapItem({required this.width});

  @override
  Widget build(BuildContext context) => Container(width: width);
}
