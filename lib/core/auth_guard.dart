import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme = ThemeData(
  primaryColor: Colors.indigo,
  scaffoldBackgroundColor: const Color(0xfff5f6fa),
  textTheme: GoogleFonts.poppinsTextTheme(),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
);
