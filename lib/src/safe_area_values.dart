/// An immutable set of values, specifying whether to avoid system intrusions for specific sides
class SafeAreaValues {
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;

  const SafeAreaValues({
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
  });
}
