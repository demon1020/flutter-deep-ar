import 'package:flutter/material.dart';
import 'material_color.dart';

class AppTheme {

  static MaterialColor primary = CustomMaterialColor.generate(0xFF00BED6);
  static MaterialColor primaryDark = CustomMaterialColor.generate(0xFF27374D);

  static Color primaryLight = Color(0xFFE5F8FB);
  static Color lightGrey = Color(0xFFA2A7AD);
  static Color darkGrey = Color(0xFF4A4846);
  static Color white = Colors.white;

  static ThemeData get lightTheme => _lightThemeData;
  static ThemeData get darkTheme => _darkThemeData;

  static final _lightThemeData = _getThemeData(primary);
  static final _darkThemeData = _getThemeData(primaryDark);

  static ThemeData _getThemeData(MaterialColor color) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: color,
      // primarySwatch: color,
      appBarTheme: const AppBarTheme(
        elevation: 1,
      ),
    );
  }
}
