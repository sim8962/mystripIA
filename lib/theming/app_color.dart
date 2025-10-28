import 'package:flutter/material.dart';

const Color myColorDark = Color.fromARGB(255, 27, 28, 30);
const Color myColorWhite = Color(0xFFfcf8f7);
const Color myColorRed = Color(0xFFec2b4b);
const Color myColorOrg = Color(0xFFffa50a);
const String latoFontFamily = 'Lato';
const String robotoFontFamily = 'Roboto';
const String impactFontFamily = 'impact';

class AppColors {
  AppColors._();

  // ########################################################################
  // Constantes de couleur et de taille
  // ######################################################################
  static const Color darkBackground = Color.fromARGB(0xFF, 40, 51, 70);
  static const Color lightBackground = Colors.white60;
  static const Color colorWhite = Colors.white;
  static const Color colorblack87 = Colors.black87;
  static const Color colorblack54 = Colors.black54;
  static const Color colorblack45 = Colors.black45;
  static const Color primaryLightColor = Color(0xFF467db8);
  static const Color errorColor = Color.fromARGB(0xFF, 254, 96, 105);
  static const Color secondaryColor = Color.fromARGB(0xFF, 3, 255, 251);
  static const Color tertiaryColor = Color.fromARGB(0xFF, 217, 222, 226);
  static const Color primaryDarkColor = Color(0xFFF72585);
  // Add the hardcoded color here
  static const Color myCustomColor = Color(0xFF4CC9F0);

  // Couleurs pour les cartes de vol
  static const Color volCardText = Color.fromARGB(255, 17, 89, 167); // Bleu foncé pour texte

  static const ColorScheme colorSchemelight = ColorScheme.light(
    primary: errorColor, // Bleu moyen (color01)
    onPrimary: colorWhite, // Blanc (colorWhite)
    primaryContainer: Color(0xFFD2E4FF),
    onPrimaryContainer: Color(0xFF001C3A),
    secondary: secondaryColor, // Cyan vif (color02)
    onSecondary: colorblack87, // Noir transparent (colorblack87)
    secondaryContainer: Color(0xFF71FFF8),
    onSecondaryContainer: Color(0xFF001D1B),
    tertiary: tertiaryColor, // Gris clair (color03)
    onTertiary: colorblack87, // Noir transparent (colorblack87)
    surface: darkBackground, // Blanc cassé (backgroundlight)
    onSurface: colorblack87,
    error: errorColor, // Rouge/Rose (color04)
    onError: colorWhite, // Blanc (colorWhite)
  );

  static const ColorScheme colorSchemeDark = ColorScheme.dark(
    primary: primaryLightColor, // Bleu moyen (color01)
    onPrimary: colorWhite, // Blanc (colorWhite)
    primaryContainer: Color(0xFF12456D),
    onPrimaryContainer: Color(0xFFD2E4FF),
    secondary: secondaryColor, // Cyan vif (color02)
    onSecondary: colorblack87, // Noir transparent (colorblack87)
    secondaryContainer: Color(0xFF004E4A),
    onSecondaryContainer: Color(0xFF71FFF8),
    tertiary: tertiaryColor, // Gris clair (color03)
    onTertiary: colorblack87, // Noir transparent (colorblack87)
    surface: darkBackground, // Bleu foncé (darkBackground)
    onSurface: colorWhite, // Blanc (colorWhite)
    error: errorColor, // Rouge/Rose (color04)
    onError: colorWhite, // Blanc (colorWhite)
  );
}
