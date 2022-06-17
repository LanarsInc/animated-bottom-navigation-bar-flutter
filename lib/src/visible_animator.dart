import 'package:flutter/widgets.dart';

class VisibleAnimator extends StatefulWidget {
  const VisibleAnimator({
    Key? key,
    required this.child,
    required this.showController,
    required this.curve,
  }) : super(key: key);

  final Widget child;
  final Curve curve;

  final AnimationController showController;

  @override
  State<VisibleAnimator> createState() => _VisibleAnimatorState();
}

class _VisibleAnimatorState extends State<VisibleAnimator> {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: widget.showController, curve: widget.curve),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: -1,
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}
