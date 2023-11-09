import 'package:flutter/material.dart';

class DarkGreenTheme {
  static const Color primaryColor = Color(0xFF006400); // Dark Green
  static const Color hintColor = Color(0xFFFFFFFF);  // Bright Green
  static const Color backgroundColor = Color(0xFF121212); // Dark Background
  static const Color textColor = Color(0xFFFFFFFF); // White Text
  static const Color secondaryTextColor = Color(0xFFA0A0A0); // Light Gray Text

  static ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    hintColor: hintColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'consolas', 
    
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        color: secondaryTextColor,
        fontSize: 14.0,
      ),),
    appBarTheme: const AppBarTheme(
      color: primaryColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: hintColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}