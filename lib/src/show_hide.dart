import 'package:flutter/widgets.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

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
class ShowHide extends HookWidget {
  // ignore: public_member_api_docs
  const ShowHide({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    required this.showing,
  }) : super(key: key);

  /// The [Widget] on which the animation is applied.
  final Widget child;

  /// How long it takes to show/hide
  final Duration duration;

  /// Whether the [Widget] is visible.
  final bool showing;

  /* @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    var _hide = useAnimationController(
      duration: duration,
      initialValue: 1.0,
    );

    if (!showing) {
      _hide.reverse();
    } else {
      _hide.forward();
    }
    return SizeTransition(
      sizeFactor: _hide,
      child: child,
    );
  }
}
