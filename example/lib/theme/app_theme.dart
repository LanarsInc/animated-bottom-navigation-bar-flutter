import 'package:flutter/material.dart';

import 'custom_colors_theme.dart';

class AppTheme {
  static HexColor colorOrange = HexColor('#FFA400');
  static HexColor colorGray = HexColor('#373A36');

  static ThemeData get({required bool isLight}) {
    final base = isLight ? ThemeData.light() : ThemeData.dark();
    return base.copyWith(
      extensions: [
        CustomColorsTheme(
          colorLabelColor: isLight ? Colors.grey : const Color(0xFF7A7FB0),
          bottomNavigationBarBackgroundColor: isLight ? Colors.blue : colorGray,
          activeNavigationBarColor: isLight ? Colors.yellow : colorOrange,
          notActiveNavigationBarColor: Colors.white,
          shadowNavigationBarColor: isLight ? Colors.blue : colorOrange,
        )
      ],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isLight ? Colors.yellow : colorOrange,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? Colors.blue : colorGray,
      ),
      colorScheme: base.colorScheme.copyWith(
        surface: isLight ? Colors.blue : colorGray,
        background: isLight ? Colors.white : colorGray,
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
