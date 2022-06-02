import 'package:flutter/widgets.dart';

/// A widget that will animate in by growing to its full size
/// and shrinking away depending on `showing`.
/// - Usually `showing` is stored in the view model to show or hide a widget.
///
/// Example:
/// {@tool snippet}
/// ```dart
/// ShowHide(
///     showing: model.showHiddenWidget,
///     child: HiddenWidget(),
/// ),
/// ```
/// {@end-tool}

class ShowHide extends StatefulWidget {
  const ShowHide({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    required this.showing,
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  /// The [Widget] on which the animation is applied.
  final Widget child;

  /// How long it takes to show/hide
  final Duration duration;

  ///The [Curve] that the size animation will follow.
  ///Defaults to [Curves.fastOutSlowIn]
  final Curve curve;

  /// Whether the [Widget] is visible.
  final bool showing;

  @override
  State<ShowHide> createState() => _ShowHideState();
}

class _ShowHideState extends State<ShowHide>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    if (widget.showing) {
      _controller.value = _controller.upperBound;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ShowHide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showing != oldWidget.showing) {
      if (widget.showing) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}
