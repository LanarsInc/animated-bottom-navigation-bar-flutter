part of animated_bottom_navigation_bar;

class LabelOptions {
  /// Optional minimal label font size to scale down. Default is '10'.
  final double minFontSize;

  /// Optional text overflow behavior. Default is [TextOverflow.clip]
  final TextOverflow textOverflow;

  /// Optional label textStyle. If [mutateLabelColor] is omitted or 'true' then
  /// [AnimatedBottomNavigationBar.activeColor] and [AnimatedBottomNavigationBar.inactiveColor] will be used
  /// for an appropriate label state instead of [textStyle.color]. Otherwise [textStyle.color] will be used. Default is [TextStyle].
  final TextStyle textStyle;

  /// Optional key. If [mutateLabelColor] is omitted or 'true' then
  /// [AnimatedBottomNavigationBar.activeColor] and [AnimatedBottomNavigationBar.inactiveColor] will be used
  /// for an appropriate label state instead of [textStyle.color]. Otherwise [textStyle.color] will be used. Default is 'true'.
  final bool mutateLabelColor;

  LabelOptions({
    this.minFontSize = 10,
    this.textStyle = const TextStyle(),
    this.textOverflow = TextOverflow.clip,
    this.mutateLabelColor = true,
  });
}
