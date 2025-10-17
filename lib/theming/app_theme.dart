import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../helpers/constants.dart';
import 'app_color.dart';

class AppTheme {
  AppTheme._();
  static bool get isDark => Get.isDarkMode;
  static ThemeData get appTheme => isDark ? appDarkTheme : appLightTheme;

  static double myHeightiphone = deviceHeight.h;
  static double myWidthiphone = deviceWidth.w;
  static double myHeightipad = deviceHeightIpad.h;
  static double myWidthipad = deviceWidthIpad.w;
  static double get myWidth => boxGet.read(getDevice) == getIphone ? myWidthiphone : myWidthipad;
  static double get myHeight => boxGet.read(getDevice) == getIphone ? myHeightiphone : myHeightipad;
  static double h({required double x}) => x.h;
  static double w({required double x}) => x.w;
  static double r({required double x}) => x.r;
  static double s({required double x}) => x.sp;
  static double getfontSize({required double iphoneSize, required double ipadsize}) =>
      boxGet.read(getDevice) == getIphone ? s(x: iphoneSize) : s(x: ipadsize);

  static double getheight({required double iphoneSize, required double ipadsize}) =>
      boxGet.read(getDevice) == getIphone ? h(x: iphoneSize) : h(x: ipadsize);

  static double getWidth({required double iphoneSize, required double ipadsize}) =>
      boxGet.read(getDevice) == getIphone ? w(x: iphoneSize) : w(x: ipadsize);

  static double getRadius({required double iphoneSize, required double ipadsize}) =>
      boxGet.read(getDevice) == getIphone ? r(x: iphoneSize) : r(x: ipadsize);

  static Color get fonfColor => (isDark != true) ? AppColors.colorWhite : AppColors.darkBackground;

  static BoxDecoration get fondDecoration => BoxDecoration(
    color: (isDark != true) ? AppColors.colorWhite : AppColors.darkBackground,
    border: Border.all(
      color: (isDark != true) ? AppColors.colorWhite : AppColors.errorColor, // Border color
      width: 1, // Border width
    ),
    borderRadius: BorderRadius.all(Radius.circular(r(x: 8.0))),
  );

  static BoxDecoration get fondDuty => BoxDecoration(
    color: (isDark != true) ? AppColors.colorWhite : AppColors.darkBackground,
    border: Border.all(
      color: (isDark != true) ? AppColors.primaryLightColor : AppColors.errorColor, // Border color
      width: 1, // Border width
    ),
    borderRadius: BorderRadius.all(Radius.circular(r(x: 8.0))),
  );

  static BoxDecoration buttonBoxDecoration() {
    Color c1 = const Color.fromARGB(255, 53, 79, 108);
    Color c2 = const Color.fromARGB(255, 29, 61, 97);
    Color c3 = Color.fromARGB(255, 156, 91, 92); //const Color(0xFFF72585);
    Color c4 = Color.fromARGB(255, 141, 71, 97); //const Color.fromARGB(255, 233, 52, 130);
    return BoxDecoration(
      boxShadow: [const BoxShadow(color: AppColors.colorblack87, offset: Offset(0, 4), blurRadius: 5.0)],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 1.0],
        colors: (isDark != true) ? [c1, c2] : [c3, c4],
      ),
      color: AppColors.primaryLightColor,
      borderRadius: BorderRadius.circular(30),
    );
  }

  static InputDecorationTheme getInputDecorationTheme({
    required BuildContext context,
    required bool isError,
    required String label,
    String? hint,
  }) {
    return InputDecorationTheme(
      // labelStyle: isDark ? lightlabelStyle : darklabelStyle, // Assuming you will create them later
      // hintStyle: isDark ? lighthintStyle : darkhintStyle,
      // errorStyle: isError ? lighterrorStyle : darkerrorStyle,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(r(x: 5))),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(r(x: 5)),
        borderSide: const BorderSide(color: AppColors.primaryLightColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(r(x: 5)),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(r(x: 5)),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(r(x: 5)),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      //    label:  Text(label),
      // hintText: hint
    );
  }

  // Constantes pour les tailles de police
  static const double kIphoneDisplayLargeFontSize = 18;
  static const double kIpadDisplayLargeFontSize = 28;
  static const double kIphoneDisplayMediumFontSize = 12;
  static const double kIpadDisplayMediumFontSize = 14;
  static const double kIphoneDisplaySmallFontSize = 13;
  static const double kIpadDisplaySmallFontSize = 14;
  static const double kIphoneHeadlineLargeFontSize = 18;
  static const double kIpadHeadlineLargeFontSize = 18;
  static const double kIphoneHeadlineMediumFontSize = 14;
  static const double kIpadHeadlineMediumFontSize = 14;
  static const double kIphoneHeadlineSmallFontSize = 14;
  static const double kIpadHeadlineSmallFontSize = 13;
  static const double kIphoneTitleLargeFontSize = 12.5;
  static const double kIpadTitleLargeFontSize = 13;
  static const double kIphoneTitleMediumFontSize = 13;
  static const double kIpadTitleMediumFontSize = 13;
  static const double kIphoneTitleSmallFontSize = 12;
  static const double kIpadTitleSmallFontSize = 14;
  static const double kIphoneBodyLargeFontSize = 12;
  static const double kIpadBodyLargeFontSize = 13;
  static const double kIphoneBodyMediumFontSize = 12;
  static const double kIpadBodyMediumFontSize = 13;
  static const double kIphoneBodySmallFontSize = 10;
  static const double kIpadBodySmallFontSize = 12;
  static const double kIphoneLabelLargeFontSize = 19;
  static const double kIpadLabelLargeFontSize = 20;
  static const double kIphoneLabelMediumFontSize = 12;
  static const double kIpadLabelMediumFontSize = 12;
  static const double kIphoneLabelSmallFontSize = 10;
  static const double kIpadLabelSmallFontSize = 12;

  // Fonction de base pour les styles de texte
  static TextStyle _baseTextStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    String fontFamily = 'Roboto',
    Color? color,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  // Styles pour le thème clair
  static TextStyle displayLargeTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneDisplayLargeFontSize, ipadsize: kIpadDisplayLargeFontSize),
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato',
      color: color ?? AppColors.colorWhite,
    );
  }

  static TextStyle displayMediumTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneDisplayMediumFontSize, ipadsize: kIpadDisplayMediumFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorblack87,
    );
  }

  static TextStyle displaySmallTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneDisplaySmallFontSize, ipadsize: kIpadDisplaySmallFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorblack45,
    );
  }

  static TextStyle headlineLargeTextStyleLight({Color? color, bool underline = true}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneHeadlineLargeFontSize, ipadsize: kIpadHeadlineLargeFontSize),
      fontWeight: FontWeight.w800,
      fontFamily: 'Lato',
      color: color ?? AppColors.primaryLightColor,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: AppColors.primaryLightColor,
    );
  }

  static TextStyle headlineMediumTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneHeadlineMediumFontSize, ipadsize: kIpadHeadlineMediumFontSize),
      fontWeight: FontWeight.w800,
      color: color ?? AppColors.primaryLightColor,
    );
  }

  static TextStyle headlineSmallTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneHeadlineSmallFontSize, ipadsize: kIpadHeadlineSmallFontSize),
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.colorblack87,
    );
  }

  static TextStyle titleLargeTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneTitleLargeFontSize, ipadsize: kIpadTitleLargeFontSize),
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
      fontFamily: 'Lato',
      color: color ?? AppColors.primaryLightColor,
    );
  }

  static TextStyle titleMediumTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneTitleMediumFontSize, ipadsize: kIpadTitleMediumFontSize),
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      fontFamily: 'Lato',
      color: color ?? AppColors.primaryLightColor,
    );
  }

  static TextStyle titleSmallTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneTitleSmallFontSize, ipadsize: kIpadTitleSmallFontSize),
      fontWeight: FontWeight.w700,
      fontFamily: 'Lato',
      color: color ?? AppColors.colorblack87.withAlpha(180),
    );
  }

  static TextStyle bodyLargeTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneBodyLargeFontSize, ipadsize: kIpadBodyLargeFontSize),
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.colorblack54,
    );
  }

  static TextStyle bodyMediumTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneBodyMediumFontSize, ipadsize: kIpadBodyMediumFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorblack87,
    );
  }

  static TextStyle bodySmallTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneBodySmallFontSize, ipadsize: kIpadBodySmallFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorblack87,
    );
  }

  static TextStyle labelLargeTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneLabelLargeFontSize, ipadsize: kIpadLabelLargeFontSize),
      fontWeight: FontWeight.w800,
      fontFamily: 'impact',
      color: color ?? AppColors.primaryLightColor,
    );
  }

  static TextStyle labelMediumTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneLabelMediumFontSize, ipadsize: kIpadLabelMediumFontSize),
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.colorblack87,
    );
  }

  static TextStyle labelSmallTextStyleLight({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneLabelSmallFontSize, ipadsize: kIpadLabelSmallFontSize),
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.colorblack87,
    );
  }

  // Styles pour le thème sombre
  static TextStyle displayLargeTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneDisplayLargeFontSize, ipadsize: kIpadDisplayLargeFontSize),
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato',
      color: color ?? AppColors.colorWhite,
    );
  }

  static TextStyle displayMediumTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneDisplayMediumFontSize, ipadsize: kIpadDisplayMediumFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorblack87,
    );
  }

  static TextStyle displaySmallTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneDisplaySmallFontSize, ipadsize: kIpadDisplaySmallFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorWhite,
    );
  }

  static TextStyle headlineLargeTextStyleDark({Color? color, bool underline = true}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneHeadlineLargeFontSize, ipadsize: kIpadHeadlineLargeFontSize),
      fontWeight: FontWeight.w800,
      fontFamily: 'Lato',
      color: color ?? AppColors.errorColor,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: AppColors.errorColor,
    );
  }

  static TextStyle headlineMediumTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneHeadlineMediumFontSize, ipadsize: kIpadHeadlineMediumFontSize),
      fontWeight: FontWeight.w800,
      color: color ?? AppColors.secondaryColor,
    );
  }

  static TextStyle headlineSmallTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneHeadlineSmallFontSize, ipadsize: kIpadHeadlineSmallFontSize),
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.colorWhite,
    );
  }

  static TextStyle titleLargeTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneTitleLargeFontSize, ipadsize: kIpadTitleLargeFontSize),
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
      fontFamily: 'Lato',
      color: color ?? AppColors.secondaryColor,
    );
  }

  static TextStyle titleMediumTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneTitleMediumFontSize, ipadsize: kIpadTitleMediumFontSize),
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      fontFamily: 'Lato',
      color: color ?? const Color(0xFF4CC9F0),
    );
  }

  static TextStyle titleSmallTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneTitleSmallFontSize, ipadsize: kIpadTitleSmallFontSize),
      fontWeight: FontWeight.w700,
      fontFamily: 'Lato',
      color: color ?? AppColors.colorWhite.withAlpha(180),
    );
  }

  static TextStyle bodyLargeTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneBodyLargeFontSize, ipadsize: kIpadBodyLargeFontSize),
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.colorblack54,
    );
  }

  static TextStyle bodyMediumTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneBodyMediumFontSize, ipadsize: kIpadBodyMediumFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorWhite,
    );
  }

  static TextStyle bodySmallTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneBodySmallFontSize, ipadsize: kIpadBodySmallFontSize),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.colorblack87,
    );
  }

  static TextStyle labelLargeTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneLabelLargeFontSize, ipadsize: kIpadLabelLargeFontSize),
      fontWeight: FontWeight.w800,
      fontFamily: 'impact',
      color: color ?? AppColors.secondaryColor,
    );
  }

  static TextStyle labelMediumTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneLabelMediumFontSize, ipadsize: kIpadLabelMediumFontSize),
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.colorWhite,
    );
  }

  static TextStyle labelSmallTextStyleDark({Color? color}) {
    return _baseTextStyle(
      fontSize: getfontSize(iphoneSize: kIphoneLabelSmallFontSize, ipadsize: kIpadLabelSmallFontSize),
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.colorblack87,
    );
  }

  // ########################################################################
  // Themes
  // ########################################################################
  static ThemeData get appLightTheme {
    return ThemeData(
      //fontFamily: 'Roboto',
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.colorSchemelight,
      textTheme: TextTheme(
        displayLarge: displayLargeTextStyleLight(),
        displayMedium: displayMediumTextStyleLight(),
        displaySmall: displaySmallTextStyleLight(),
        headlineLarge: headlineLargeTextStyleLight(),
        headlineMedium: headlineMediumTextStyleLight(),
        headlineSmall: headlineSmallTextStyleLight(),
        titleLarge: titleLargeTextStyleLight(),
        titleMedium: titleMediumTextStyleLight(),
        titleSmall: titleSmallTextStyleLight(),
        bodyLarge: bodyLargeTextStyleLight(),
        bodyMedium: bodyMediumTextStyleLight(),
        bodySmall: bodySmallTextStyleLight(),
        labelLarge: labelLargeTextStyleLight(),
        labelMedium: labelMediumTextStyleLight(),
        labelSmall: labelSmallTextStyleLight(),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppTheme.fonfColor,
        headerBackgroundColor: Colors.blue,
        headerForegroundColor: Colors.white,

        // todayTextStyle: TextStyle(color: Colors.red),
        dayStyle: TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static ThemeData get appDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.colorSchemeDark,
      textTheme: TextTheme(
        displayLarge: displayLargeTextStyleDark(),
        displayMedium: displayMediumTextStyleDark(),
        displaySmall: displaySmallTextStyleDark(),
        headlineLarge: headlineLargeTextStyleDark(),
        headlineMedium: headlineMediumTextStyleDark(),
        headlineSmall: headlineSmallTextStyleDark(),
        titleLarge: titleLargeTextStyleDark(),
        titleMedium: titleMediumTextStyleDark(),
        titleSmall: titleSmallTextStyleDark(),
        bodyLarge: bodyLargeTextStyleDark(),
        bodyMedium: bodyMediumTextStyleDark(),
        bodySmall: bodySmallTextStyleDark(),
        labelLarge: labelLargeTextStyleDark(),
        labelMedium: labelMediumTextStyleDark(),
        labelSmall: labelSmallTextStyleDark(),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppTheme.fonfColor,
        headerBackgroundColor: AppColors.errorColor,
        headerForegroundColor: Colors.white,
        // todayTextStyle: TextStyle(color: Colors.red),
        dayStyle: TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
