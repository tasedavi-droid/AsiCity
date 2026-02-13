import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  /// 🌌 CORES BASE
  static const primary = Color(0xFF6366F1);
  static const accent = Color(0xFF22D3EE);
  static const background = Color(0xFF020617);
  static const surface = Color(0xFF0F172A);
  static const glass = Color(0xFF1E293B);

  /// 🌑 DARK THEME PROFISSIONAL
  static ThemeData darkTheme = ThemeData(

    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
    ),

    /// 🔤 TIPOGRAFIA PREMIUM
    textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),

    /// 📦 CARDS GLASS STYLE
    cardTheme: CardThemeData(
      elevation: 10,
      color: glass.withOpacity(0.65),
      shadowColor: primary.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),

    /// 🔘 BOTÕES MODERNOS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: primary.withOpacity(0.6),
      ),
    ),

    /// 🧊 INPUTS MODERNOS
    inputDecorationTheme: InputDecorationTheme(

      filled: true,
      fillColor: surface,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: accent, width: 2),
      ),

      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
    ),

    /// 📱 APPBAR FUTURISTA
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    ),

    /// 🌊 BOTTOM NAV MODERNO
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: accent,
      unselectedItemColor: Colors.white38,
      type: BottomNavigationBarType.fixed,
      elevation: 20,
    ),
  );

  /// 🌈 GRADIENTE TECNOLÓGICO GLOBAL
  static LinearGradient mainGradient = const LinearGradient(
    colors: [
      Color(0xFF6366F1),
      Color(0xFF22D3EE),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}