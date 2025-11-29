import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark theme colors
  static const Color sageGreen = Color(0xFF2D9B87);
  static const Color darkGreen = Color(0xFF1A2F23);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color error = Color(0xFFCF6679);
  
  // Light theme colors - Brighter, more vibrant greens for light mode
  static const Color mintGreen = Color(0xFF4ECDC4); // Vibrant turquoise-mint
  static const Color lightMint = Color(0xFFF0FFFE); // Very light mint background
  static const Color softWhite = Color(0xFFFAFDFC); // Soft white with hint of mint
  static const Color darkText = Color(0xFF1A2F23);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color accentGreen = Color(0xFF2ECC71); // Bright accent green for light mode

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: sageGreen,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        primary: sageGreen,
        secondary: sageGreen,
        surface: darkGreen,
        error: error,
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
        onError: black,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sageGreen,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: mintGreen,
      scaffoldBackgroundColor: softWhite,
      colorScheme: const ColorScheme.light(
        primary: mintGreen,
        secondary: mintGreen,
        surface: lightMint,
        error: error,
        onPrimary: white,
        onSecondary: darkText,
        onSurface: darkText,
        onError: white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mintGreen,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static BoxDecoration get backgroundGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [darkGreen, black],
      ),
    );
  }

  static BoxDecoration get lightBackgroundGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lightMint, softWhite],
      ),
    );
  }
}

