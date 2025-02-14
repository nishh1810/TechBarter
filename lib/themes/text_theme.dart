import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextTheme customTextTheme = TextTheme(

  bodySmall:GoogleFonts.montserrat(
      fontSize: 13,fontWeight: FontWeight.w600),

  bodyMedium: GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w700),

  bodyLarge: GoogleFonts.montserrat(
      fontSize: 19,  fontWeight: FontWeight.w800),

  displayLarge: GoogleFonts.montserrat(
    fontSize: 57, // H1
    fontWeight: FontWeight.bold,
  ),
  displayMedium: GoogleFonts.montserrat(
    fontSize: 45, // H2
    fontWeight: FontWeight.w600,
  ),
  displaySmall: GoogleFonts.montserrat(
    fontSize: 36, // H3
    fontWeight: FontWeight.w600,
  ),
  headlineMedium: GoogleFonts.montserrat(
    fontSize: 28, // H4
    fontWeight: FontWeight.w500,
  ),
  headlineSmall: GoogleFonts.montserrat(
    fontSize: 24, // H5
    fontWeight: FontWeight.w500,
  ),
  titleLarge: GoogleFonts.montserrat(
    fontSize: 22, // H6
    fontWeight: FontWeight.w500,
  ),
  labelLarge: GoogleFonts.montserrat(
    fontSize: 14, // Button text
    fontWeight: FontWeight.w600,
  ),
);