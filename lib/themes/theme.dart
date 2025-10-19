
import 'package:flutter/material.dart';

// CSS değişkenlerinden çıkarılan renkler
const Color primaryColor = Color(0xFF2F57EF);
const Color secondaryColor = Color(0xFFB966E7);
const Color headingColor = Color(0xFF192335);
const Color bodyTextColor = Color(0xFF6B7385);
const Color backgroundColor = Color(0xFFF5F7FA);
const Color surfaceColor = Colors.white;
const Color errorColor = Color(0xFFFF0003);
const Color successColor = Color(0xFF3EB75E);
const Color warningColor = Color(0xFFFF8F3C);

// Yazı Tipi Ailesi (pubspec.yaml'a eklenmelidir)
const String primaryFontFamily = 'Euclid Circular';

class HiStudyTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: primaryFontFamily,
      colorScheme: const ColorScheme(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: headingColor,
        onBackground: headingColor,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: headingColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontWeight: FontWeight.w600, // semi-bold
          fontSize: 20,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: headingColor),
        displayMedium: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: headingColor),
        headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: headingColor),
        headlineSmall: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: headingColor),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: headingColor),
        bodyLarge: TextStyle(fontSize: 18, color: bodyTextColor, height: 1.45),
        bodyMedium: TextStyle(fontSize: 16, color: bodyTextColor, height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: bodyTextColor, height: 1.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontWeight: FontWeight.w500, // medium
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0), // --radius
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 8.0, // --shadow-1'e benzer bir etki için
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // --radius-10
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0), // --radius
          borderSide: const BorderSide(color: Color(0xFFE6E3F1)), // --color-border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: Color(0xFFE6E3F1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        labelStyle: const TextStyle(
          color: bodyTextColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      iconTheme: const IconThemeData(
        color: bodyTextColor,
        size: 24.0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: bodyTextColor,
        elevation: 10.0,
        showUnselectedLabels: true,
      ),
    );
  }
}
