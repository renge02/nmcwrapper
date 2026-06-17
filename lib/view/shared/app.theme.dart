import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Colors.white;
  static const Color lightBlue = Color(0xFFE8F0FE);
  static const Color background = Colors.white;
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color cursorColor = Color(0xFF7A1236);
  static const Color appBarColor = Color(0xFF7A1236);
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    fontFamily: 'Poppins',
    primaryColor: primaryBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      iconTheme: IconThemeData(color: textDark),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textGrey,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
        focusColor: cursorColor,
        prefixIconColor: const Color(0xffBCBCBC),
        suffixIconColor: const Color(0xffBCBCBC),
        labelStyle: TextStyle(
          fontSize: 18,
          color: Color(0xFF7A1236),
        ),
        hintStyle: TextStyle(fontSize: 15, color: const Color(0xffBCBCBC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cursorColor),
        )),
  );
}
