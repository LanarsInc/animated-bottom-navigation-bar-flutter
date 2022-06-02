import 'package:flutter/widgets.dart';

class ShowHide extends StatefulWidget {
  const ShowHide({
    Key? key,
    required this.child,
    required this.showController,
    this.curve,
  }) : super(key: key);

  /// The [Widget] on which the animation is applied.
  final Widget child;

  ///The [Curve] that the size animation will follow.
  ///Defaults to [Curves.fastOutSlowIn]
  final Curve? curve;

  final AnimationController showController;

  @override
  State<ShowHide> createState() => _ShowHideState();
}

class _ShowHideState extends State<ShowHide> {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.showController,
        curve: widget.curve ?? Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}
