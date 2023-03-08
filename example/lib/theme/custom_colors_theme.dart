import 'package:flutter/material.dart';

@immutable
class CustomColorsTheme extends ThemeExtension<CustomColorsTheme> {
  const CustomColorsTheme({
    required this.bottomNavigationBarBackgroundColor,
    required this.colorLabelColor,
  });

  final Color bottomNavigationBarBackgroundColor;
  final Color colorLabelColor;

  @override
  CustomColorsTheme copyWith({
    Color? darkShadowColor,
    Color? lightShadowColor,
    Color? colorLabelColor,
  }) {
    return CustomColorsTheme(
      bottomNavigationBarBackgroundColor:
          darkShadowColor ?? this.bottomNavigationBarBackgroundColor,
      colorLabelColor: colorLabelColor ?? this.colorLabelColor,
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
              bottomNavigationBarBackgroundColor, other.bottomNavigationBarBackgroundColor, t) ??
          bottomNavigationBarBackgroundColor,
      colorLabelColor: Color.lerp(colorLabelColor, other.colorLabelColor, t) ?? colorLabelColor,
    );
  }
}
