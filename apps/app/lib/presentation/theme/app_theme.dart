import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.light,
    );

    return base.copyWith(
      visualDensity: VisualDensity.standard,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
    );
  }
}
