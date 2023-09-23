import 'package:flutter/material.dart';

@immutable
class CustomColorsTheme extends ThemeExtension<CustomColorsTheme> {
  const CustomColorsTheme({
    required this.bottomNavigationBarBackgroundColor,
    required this.colorLabelColor,
    required this.activeNavigationBarColor,
    required this.notActiveNavigationBarColor,
    required this.shadowNavigationBarColor,
  });

  final Color bottomNavigationBarBackgroundColor;
  final Color colorLabelColor;
  final Color activeNavigationBarColor;
  final Color notActiveNavigationBarColor;
  final Color shadowNavigationBarColor;

  @override
  CustomColorsTheme copyWith({
    Color? bottomNavigationBarBackgroundColor,
    Color? colorLabelColor,
    Color? activeNavigationBarColor,
    Color? notActiveNavigationBarColor,
    Color? shadowNavigationBarColor,
  }) {
    return CustomColorsTheme(
      bottomNavigationBarBackgroundColor: bottomNavigationBarBackgroundColor ??
          this.bottomNavigationBarBackgroundColor,
      colorLabelColor: colorLabelColor ?? this.colorLabelColor,
      activeNavigationBarColor:
          activeNavigationBarColor ?? this.activeNavigationBarColor,
      notActiveNavigationBarColor:
          notActiveNavigationBarColor ?? this.notActiveNavigationBarColor,
      shadowNavigationBarColor:
          shadowNavigationBarColor ?? this.shadowNavigationBarColor,
    );
  }

  @override
  CustomColorsTheme lerp(
    ThemeExtension<CustomColorsTheme>? other,
    double t,
  ) {
    if (other is! CustomColorsTheme) {
      return this;
    }
    return CustomColorsTheme(
      bottomNavigationBarBackgroundColor: Color.lerp(
              bottomNavigationBarBackgroundColor,
              other.bottomNavigationBarBackgroundColor,
              t) ??
          bottomNavigationBarBackgroundColor,
      colorLabelColor: Color.lerp(colorLabelColor, other.colorLabelColor, t) ??
          colorLabelColor,
      activeNavigationBarColor: Color.lerp(
              activeNavigationBarColor, other.activeNavigationBarColor, t) ??
          activeNavigationBarColor,
      notActiveNavigationBarColor: Color.lerp(notActiveNavigationBarColor,
              other.notActiveNavigationBarColor, t) ??
          notActiveNavigationBarColor,
      shadowNavigationBarColor: Color.lerp(
              shadowNavigationBarColor, other.shadowNavigationBarColor, t) ??
          shadowNavigationBarColor,
    );
  }
}
