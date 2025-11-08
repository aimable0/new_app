import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 5, 7, 21);
  static const Color primaryAccent = Color(0xFFE9B44C);

  static const Color lightText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFA9A9A9);

  // Tag colors for "New", "Used", etc.
  static const Color tagBackground = Color(0xFFFFF8E1);
  static Color? tagTextAccent = Colors.blue[500];
  static const Color tagTextDark = Color(0xFF616161);

  // Chat bubble color
  static const Color chatBubbleDark = Color(0xFF3A3E4E);

  // General colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.tagTextAccent!),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.lightText,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),


  // text theme
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
      letterSpacing: 1,
    ),
    headlineMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  ),
);
