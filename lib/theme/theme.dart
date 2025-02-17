import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.teal,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.openSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Add default text color
      ),
      displayMedium: GoogleFonts.openSans(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.openSans(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      bodySmall: GoogleFonts.openSans(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    ),
    useMaterial3: true, // Enable Material 3
  );
}
