import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF01683F);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _primaryColor,
      onPrimary: Colors.white,
      secondary: Color(0xFF65a30d),
      onSecondary: Colors.white,
      error: Color(0xFFb91c1c),
      onError: Colors.white,
      background: Color(0xFFf8fafc),
      onBackground: Color(0xFF020617),
      surface: Colors.white,
      onSurface: Color(0xFF020617),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF020617)),
      titleTextStyle: TextStyle(
        color: Color(0xFF020617),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      modalBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primaryColor,
      onPrimary: Colors.white,
      secondary: Color(0xFFa3e635),
      onSecondary: Color(0xFF020617),
      error: Color(0xFFef4444),
      onError: Colors.white,
      background: Color(0xFF0f172a),
      onBackground: Color(0xFFf1f5f9),
      surface: Color(0xFF1e293b),
      onSurface: Color(0xFFf1f5f9),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFFf1f5f9)),
      titleTextStyle: TextStyle(
        color: Color(0xFFf1f5f9),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      modalBackgroundColor: const Color(0xFF1e293b),
      backgroundColor: const Color(0xFF1e293b),
    ),
  );
}
