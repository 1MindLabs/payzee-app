import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[100],
    primaryColor: Colors.black,
    splashFactory: NoSplash.splashFactory,

    colorScheme: ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.grey[600]!,
      background: Colors.grey[100]!,
      surface: Colors.white,
      onPrimary: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(fontSize: 34, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
    ),

    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1.5,
      shadowColor: Colors.grey.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),

    iconTheme: const IconThemeData(color: Colors.black),
    dividerColor: Colors.grey[300],
  );
}
