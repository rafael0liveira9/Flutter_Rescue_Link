import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF49C9AA);
const Color secondaryColor = Color(0xFFCDEEBC);
const Color thirdColor = Color(0xFF507B61);
const Color fourthColor = Color(0xFF40463F);
const Color whiteSecondary = Color(0xFFF8F8F8);
const Color accent = Color(0xFF507AE4);
const Color greyPrimary = Color(0xFF6B736A);
const Color greyLight = Color.fromARGB(255, 185, 185, 185);
const Color redUrgency = Color.fromARGB(255, 255, 85, 85);
const Color yellowUrgency = Color.fromARGB(255, 189, 170, 0);
const Color blueUrgency = Color.fromARGB(255, 0, 126, 199);
const Color greenUrgency = Color.fromARGB(255, 46, 174, 0);
const Color oneSituation = Color.fromARGB(255, 205, 218, 64);
const Color twoSituation = Color.fromARGB(255, 46, 174, 0);
const Color threSituation = Color.fromARGB(255, 255, 122, 122);

// Crie um tema personalizado
final ThemeData customTheme = ThemeData(
  primaryColor: primaryColor,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: fourthColor),
    bodyMedium: TextStyle(color: fourthColor),
  ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          background: whiteSecondary,
          tertiary: thirdColor,
          shadow: fourthColor)
      .copyWith(surface: whiteSecondary, scrim: accent),
);
