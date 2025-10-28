import 'package:flutter/material.dart';
import '../helpers/constants.dart';
import 'app_color.dart';
import 'app_theme.dart';

class AppStylingConstant {
  static const String latoFontFamily = 'Lato';
  static const String robotoFontFamily = 'Roboto';
  static const String impactFontFamily = 'impact';
  static TextTheme get _textTheme => AppTheme.appTheme.textTheme;

  // ###################################################################################
  // Styles de bodyLarge : Cardeduty, CardeNextduty, CardeForfait
  // ###################################################################################
  // ===================================================================================
  // Cardeduty
  // ===================================================================================
  static TextStyle get dateLabelStyle => _textTheme.bodyLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
    fontWeight: FontWeight.w800,
    fontSize: AppTheme.getfontSize(iphoneSize: 12.5, ipadsize: 13),
  );
  // ===================================================================================
  // CardeNextduty
  // ===================================================================================
  static TextStyle get nextDutyTypeStyle => _textTheme.bodyLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 14),
  );
  // ===================================================================================
  // CardeForfait
  // ===================================================================================
  static TextStyle get forfaitLabelStyle => _textTheme.bodyLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 14),
  );
  static TextStyle get forfaitTotalStyle => _textTheme.bodyLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 14),
  );
  // ###################################################################################
  // Styles de VolDetailCard
  // ###################################################################################
  // ===================================================================================
  // VolDetailCard
  // ===================================================================================
  static TextStyle get volDetailMonthStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.volCardText,
    fontFamily: AppStylingConstant.robotoFontFamily,
    fontWeight: FontWeight.w600,
    //fontFamily: AppStylingConstant.latoFontFamily,
    fontSize: AppTheme.getfontSize(iphoneSize: 15, ipadsize: 15),
  );

  static TextStyle get volDetailICAOStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.myCustomColor : AppColors.volCardText,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 15, ipadsize: 15),
  );
  static TextStyle get volDetailIATAStyle => _textTheme.titleLarge!.copyWith(
    fontSize: AppTheme.getfontSize(iphoneSize: 58, ipadsize: 48),
    fontWeight: FontWeight.w700,
    fontFamily: AppStylingConstant.impactFontFamily,
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.volCardText,
    letterSpacing: 2,
    height: 1.0,
  );
  static TextStyle get volNvol => _textTheme.bodyMedium!.copyWith(
    fontSize: AppTheme.getfontSize(iphoneSize: 22, ipadsize: 22),
    // fontWeight: FontWeight.w700,
    fontFamily: AppStylingConstant.impactFontFamily,
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.volCardText,
    letterSpacing: 2,
    height: 1.0,
  );
  static TextStyle get volNumeriq => TextStyle(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.volCardText,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
    fontWeight: FontWeight.w600,
    fontFamily: AppStylingConstant.latoFontFamily,
  );
  static TextStyle get volTitreCrew => TextStyle(
    color: AppTheme.isDark ? AppColors.myCustomColor : AppColors.volCardText,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
    fontWeight: FontWeight.w600,
    fontFamily: AppStylingConstant.latoFontFamily,
  );
  static TextStyle get volCrew => TextStyle(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.volCardText,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
    fontWeight: FontWeight.w600,
    fontFamily: AppStylingConstant.latoFontFamily,
  );
  // ###################################################################################
  // Styles de bodyMedium : Cardeduty, CardeEtape, CardeNextduty, CardeTsv, CardeHeure, CadreSalaire
  // ###################################################################################
  // ===================================================================================
  // Cardeduty
  // ===================================================================================
  static TextStyle get dutyLabelStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.myCustomColor : AppColors.primaryLightColor,
    fontWeight: FontWeight.w700,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
  );
  static TextStyle get dutyDayStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );
  static TextStyle get dutyMonthStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );
  // ===================================================================================
  // CardeEtape
  // ===================================================================================
  static TextStyle get dateEtapeStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.myCustomColor : AppColors.primaryLightColor,
    fontWeight: FontWeight.w700,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
  );
  // ===================================================================================
  // CardeNextduty
  // ===================================================================================
  static TextStyle get nextDutyDateStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
    fontWeight: FontWeight.w700,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
  );
  static TextStyle get nextDutyStepStyle => _textTheme.bodyMedium!.copyWith(
    fontFamily: latoFontFamily,
    fontWeight: FontWeight.w700,
    color: AppTheme.isDark ? AppColors.myCustomColor : AppColors.primaryLightColor,
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 13),
  );
  // ===================================================================================
  // CardeTsv
  // ===================================================================================
  static TextStyle get tsvDateStyle => _textTheme.bodyMedium!.copyWith(
    color: AppColors.errorColor,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );

  static TextStyle get errorBigStyle => _textTheme.bodyMedium!.copyWith(
    color: AppColors.errorColor,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 14),
  );
  // ===================================================================================
  // CardeHeure
  // ===================================================================================
  static TextStyle get sunriseStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );
  static TextStyle get forfaitStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );
  static TextStyle get totalStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );
  // ===================================================================================
  // CadreSalaire
  // ===================================================================================
  static TextStyle get salaireStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );

  // ###################################################################################
  // Styles de bodySmall : Cardeduty,CardeEtape,CardeNextduty
  // ###################################################################################
  // ===================================================================================
  // Cardeduty
  // ===================================================================================
  static TextStyle get dutyDetailStyle => _textTheme.bodySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87.withAlpha(180),
    fontWeight: FontWeight.w700,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 14),
  );
  // ===================================================================================
  // CardeEtape
  // ===================================================================================
  static TextStyle get titleEtapeStyle => _textTheme.bodySmall!.copyWith(
    fontFamily: 'lato',
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87.withAlpha(180),
    fontWeight: FontWeight.w700,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 14),
  );
  // ===================================================================================
  // CardeNextduty
  // ===================================================================================
  static TextStyle get nextDutyDetailStyle => _textTheme.bodySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontWeight: FontWeight.w600,
    fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 12),
  );
  // ===================================================================================
  // dutyDateStyle
  // ===================================================================================
  static TextStyle get dutyDateStyle => _textTheme.bodyLarge!.copyWith(
    fontFamily: impactFontFamily,
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
    fontWeight: FontWeight.w800,
    fontSize: AppTheme.getfontSize(iphoneSize: 19, ipadsize: 20),
  );

  // ###################################################################################
  // Styles utilisant displayLarge : RegisterScreen
  // ###################################################################################
  static TextStyle get registerScreen => _textTheme.displayLarge!.copyWith(color: AppColors.colorWhite);

  // ###################################################################################
  // Styles utilisant displaySmall : MyTextFields, MySwitch
  // ###################################################################################
  // ===================================================================================
  // MyTextFields
  // ===================================================================================
  static TextStyle get textFiel => _textTheme.displaySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 14),
  );

  // ===================================================================================
  // MySwitch
  // ===================================================================================
  static TextStyle get switchStyleBig => _textTheme.displaySmall!;
  // ===================================================================================
  // MyTextFields
  // ===================================================================================
  static TextStyle get labelStyle => _textTheme.displaySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.colorblack87,
  );
  static TextStyle get hintStyle => _textTheme.displaySmall!;
  // ===================================================================================
  // MySwitch
  // ===================================================================================
  static TextStyle get switchStyleSmall => _textTheme.displaySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.colorblack87,
  );
  // ###################################################################################
  // Styles utilisant headlineLarge : TotalMois
  // ###################################################################################
  static TextStyle get monthTitleStyle => _textTheme.headlineLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
    decorationColor: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
  );
  // ###################################################################################
  // Styles utilisant headlineMedium : TotalMois, DutyWidget,MyTextWidget,MyDialogue
  // ###################################################################################
  // ===================================================================================
  // TotalMois
  // ===================================================================================
  static TextStyle get noDataStyle => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
  );
  static TextStyle get totalsValue => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
  );
  // ===================================================================================
  // DutyWidget
  // ===================================================================================
  static TextStyle get dutyTitre => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
  );
  // ===================================================================================
  // MyTextWidget
  // ===================================================================================
  static TextStyle get textWidgetStyle => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
  );
  // ===================================================================================
  // MyDialogue
  // ===================================================================================
  static TextStyle get dialogueTitleStyle => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
  );
  static TextStyle get dialogueMiddleTextStyle => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
  );
  // ###################################################################################
  // Styles utilisant headlineSmall : TotalMois, DutyWidget ,MtoSalatCard,MyChart,CardeNextduty
  // ###################################################################################
  // ===================================================================================
  // TotalMois
  // ===================================================================================
  static TextStyle get totalsTitre => _textTheme.headlineSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
  );
  // ===================================================================================
  // DutyWidget
  // ===================================================================================
  static TextStyle get dutyTotal => _textTheme.headlineSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
  );
  // ===================================================================================
  // MtoSalatCard
  // ===================================================================================
  static TextStyle get mtoInputStyle => _textTheme.headlineSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.primaryLightColor,
  );
  static TextStyle get mtoLabelStyle =>
      _textTheme.headlineSmall!.copyWith(color: AppColors.primaryLightColor);
  // ===================================================================================
  // MyChart
  // ===================================================================================
  static TextStyle get chartXAxisStyle => _textTheme.headlineSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 11, ipadsize: 12),
  );
  static TextStyle get chartYAxisStyle => _textTheme.headlineSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 12),
  );
  static TextStyle get chartYAxisTitleStyle => _textTheme.headlineSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 11, ipadsize: 12),
  );
  // ===================================================================================
  // MyChart
  // ===================================================================================
  static TextStyle get chartDataLabelStyle => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12),
  );

  // ###################################################################################
  // Styles utilisant titleMedium : MtoSalatCard,CrewTable,MyButton,ImportVolPage,MyTable
  // ###################################################################################
  // ===================================================================================
  // MtoSalatCard
  // ===================================================================================
  static TextStyle get mtoButtonStyle => _textTheme.titleMedium!.copyWith(color: AppColors.colorWhite);

  // ===================================================================================
  // CrewTable
  // ===================================================================================
  static TextStyle get crewTableHeaderStyle => _textTheme.titleMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.myCustomColor : AppColors.primaryLightColor,
  );
  // ===================================================================================
  // MyButton
  // ===================================================================================
  static TextStyle get buttonTextStyle => _textTheme.titleMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorblack87 : AppColors.colorWhite,
  );
  // ===================================================================================
  // ImportVolPage
  // ===================================================================================
  static TextStyle get importButtonStyle => _textTheme.titleMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.myCustomColor : AppColors.primaryLightColor,
  );
  static TextStyle get importTitleStyle => _textTheme.titleMedium!.copyWith(color: AppColors.colorWhite);
  // ===================================================================================
  // MyTable
  // ===================================================================================
  static TextStyle get tableHeaderStyle =>
      _textTheme.titleMedium!.copyWith(color: AppTheme.isDark ? AppColors.errorColor : AppColors.colorWhite);
  // ###################################################################################
  // Styles utilisant titleSmall : HomeScreen3 et MyTable,MyListFile,VersCalender
  // ###################################################################################
  // ===================================================================================
  // HomeScreen3 et MyTable
  // ===================================================================================
  static TextStyle get datePickerLabelStyle => _textTheme.titleSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.errorColor : AppColors.colorblack87.withAlpha(180),
  );
  // ===================================================================================
  // MyListFile
  // ===================================================================================
  static TextStyle get listFileNameStyle => _textTheme.titleSmall!.copyWith(color: AppColors.colorWhite);
  // ===================================================================================
  // VersCalender
  // ===================================================================================
  static TextStyle get calendarDialogTitleStyle =>
      _textTheme.titleSmall!.copyWith(color: AppColors.primaryLightColor);
  static TextStyle get verscalender => _textTheme.titleSmall!.copyWith(color: AppColors.primaryLightColor);
  static TextStyle get nomcalender => _textTheme.titleSmall!;
  // ###################################################################################
  // Styles utilisant displayMedium : MyTextFields, HomeScreen3 et MyTable
  // ###################################################################################
  // ===================================================================================
  // MyTextFields
  // ===================================================================================
  static TextStyle get errorStyle => _textTheme.displayMedium!.copyWith(color: AppColors.colorblack87);
  // ===================================================================================
  // HomeScreen3 et MyTable
  // ===================================================================================
  static TextStyle get tableEvenRowStyle => _textTheme.displayMedium!.copyWith(color: AppColors.colorblack87);
  static TextStyle get tableOddRowStyle => _textTheme.displayMedium!.copyWith(
    fontSize: AppTheme.s(x: boxGet.read(getDevice) == getIphone ? 11 : 14),
    color: AppTheme.isDark ? AppColors.errorColor : Colors.white,
  );
  // ###################################################################################
  // Styles utilisant labelMedium : CrewTable
  // ###################################################################################

  // ===================================================================================
  // CrewTable
  // ===================================================================================
  static TextStyle get crewTableCellStyle => _textTheme.labelMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
  );

  // ###################################################################################
  // Autres Styles :  MtoSalatCard , ImportVolPage
  // ###################################################################################
  static TextStyle get mtoDialogTitleStyle =>
      TextStyle(color: AppColors.primaryLightColor, fontSize: 14, fontWeight: FontWeight.bold);
  static TextStyle get importFileNameStyle =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.colorWhite);
  static TextStyle get webScreen =>
      _textTheme.headlineLarge!.copyWith(color: AppColors.colorWhite, decoration: TextDecoration.none);

  static TextStyle get importFileSizeStyle => const TextStyle(fontSize: 14);

  // ###################################################################################
  // Styles pour VolScreen et VolDetailCard
  // ###################################################################################

  // Vol Screen - Search
  static TextStyle get volSearchHintStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 15),
  );

  // Vol Screen - Empty State
  static TextStyle get volEmptyStateStyle => _textTheme.bodyLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 17),
    fontWeight: FontWeight.w500,
  );

  static TextStyle get volEmptySubtitleStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(130) : AppColors.colorblack87.withAlpha(120),
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 15),
  );

  // Vol Card - Airport Codes (IATA)
  static TextStyle get volAirportIataStyle => _textTheme.headlineLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 22, ipadsize: 24),
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  // Vol Card - Airport Codes (ICAO)
  static TextStyle get volAirportIcaoStyle => _textTheme.bodySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
    fontSize: AppTheme.getfontSize(iphoneSize: 11, ipadsize: 12),
    fontWeight: FontWeight.w600,
  );

  // Vol Card - Flight Number
  static TextStyle get volFlightNumberStyle => _textTheme.titleLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 15),
    fontWeight: FontWeight.bold,
  );

  // Vol Card - Duration Labels
  static TextStyle get volDurationLabelStyle => _textTheme.bodySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
    fontWeight: FontWeight.w500,
  );

  // Vol Card - Duration Values
  static TextStyle get volDurationValueStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 15),
    fontWeight: FontWeight.bold,
  );

  // Vol Card - Monthly Cumuls Title
  static TextStyle get volCumulsTitleStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 13),
    fontWeight: FontWeight.bold,
  );

  // Vol Card - Cumuls Values
  static TextStyle get volCumulsValueStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 14),
    fontWeight: FontWeight.bold,
  );

  // Vol Detail Card - Section Headers
  static TextStyle get volDetailHeaderStyle => _textTheme.labelMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 9, ipadsize: 10),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Vol Detail Card - Date Header
  static TextStyle get volDetailDateStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 14),
    fontWeight: FontWeight.w600,
  );

  // Vol Detail Card - Large Airport Codes
  static TextStyle get volDetailAirportLargeStyle => _textTheme.displayLarge!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 32, ipadsize: 36),
    fontWeight: FontWeight.w300,
    letterSpacing: -1,
  );

  // Vol Detail Card - Time Display
  static TextStyle get volDetailTimeStyle => _textTheme.headlineSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 20, ipadsize: 22),
    fontWeight: FontWeight.w300,
  );

  // Vol Detail Card - Time Suffix (z)
  static TextStyle get volDetailTimeSuffixStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(150) : AppColors.colorblack87.withAlpha(130),
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 15),
    fontWeight: FontWeight.w300,
  );

  // Vol Detail Card - Flight Number Large
  static TextStyle get volDetailFlightNumberStyle => _textTheme.headlineMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 24, ipadsize: 26),
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  // Vol Detail Card - Duration Item Label
  static TextStyle get volDetailDurationLabelStyle => _textTheme.labelSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 8, ipadsize: 9),
    fontWeight: FontWeight.w600,
  );

  // Vol Detail Card - Duration Item Value
  static TextStyle get volDetailDurationValueStyle => _textTheme.titleMedium!.copyWith(
    fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 17),
    fontWeight: FontWeight.bold,
  );

  // Vol Detail Card - Cumul Label
  static TextStyle get volDetailCumulLabelStyle => _textTheme.labelSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 8, ipadsize: 9),
    fontWeight: FontWeight.w500,
  );

  // Vol Detail Card - Cumul Value
  static TextStyle get volDetailCumulValueStyle => _textTheme.bodySmall!.copyWith(
    fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
    fontWeight: FontWeight.bold,
  );

  // Vol Detail Card - Aircraft Name
  static TextStyle get volDetailAircraftStyle => _textTheme.bodyMedium!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
    fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 15),
    fontWeight: FontWeight.w500,
  );

  // Vol Detail Card - Aircraft Type
  static TextStyle get volDetailAircraftTypeStyle => _textTheme.bodySmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 11, ipadsize: 12),
    fontWeight: FontWeight.w400,
  );

  // Vol Detail Card - Sun Times Label
  static TextStyle get volDetailSunLabelStyle => _textTheme.labelSmall!.copyWith(
    color: AppTheme.isDark ? AppColors.colorWhite.withAlpha(180) : AppColors.colorblack87.withAlpha(150),
    fontSize: AppTheme.getfontSize(iphoneSize: 8, ipadsize: 9),
    fontWeight: FontWeight.w500,
  );

  // Vol Detail Card - Sun Times Value
  static TextStyle get volDetailSunValueStyle => _textTheme.bodySmall!.copyWith(
    fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 13),
    fontWeight: FontWeight.bold,
  );
}
// voila une liste de textthemes flutter:
// Cardeduty

// static TextStyle get dateLabelStyle: Utilise _textTheme.titleLarge

// static TextStyle get dutyLabelStyle: Utilise _textTheme.titleMedium

// static TextStyle get dutyDetailStyle: Utilise _textTheme.titleSmall

// static TextStyle get dutyDateStyle: Utilise _textTheme.labelLarge

// static TextStyle get dutyDayStyle: Utilise _textTheme.labelMedium

// static TextStyle get dutyMonthStyle: Utilise _textTheme.labelMedium

// CardeEtape

// static TextStyle get dateEtapeStyle: Utilise _textTheme.titleMedium

// static TextStyle get titleEtapeStyle: Utilise _textTheme.titleSmall

// CardeNextduty

// static TextStyle get nextDutyDateStyle: Utilise _textTheme.headlineSmall

// static TextStyle get nextDutyStepStyle: Utilise _textTheme.headlineSmall

// static TextStyle get nextDutyTypeStyle: Utilise _textTheme.displayMedium

// static TextStyle get nextDutyDetailStyle: Utilise _textTheme.labelSmall

// CardeForfait

// static TextStyle get forfaitLabelStyle: Utilise _textTheme.displayMedium

// static TextStyle get forfaitTotalStyle: Utilise _textTheme.displayMedium

// CardeTsv

// static TextStyle get tsvDateStyle: Utilise _textTheme.labelMedium

// CardeHeure

// static TextStyle get sunriseStyle: Utilise _textTheme.labelMedium

// static TextStyle get forfaitStyle: Utilise _textTheme.labelMedium

// static TextStyle get totalStyle: Utilise _textTheme.labelMedium

// CadreSalaire

// static TextStyle get salaireStyle: Utilise _textTheme.labelMedium
// j'aimerais l'extraires du fichier :
// Cardeduty

// static TextStyle get dateLabelStyle: Utilise _textTheme.titleLarge

// static TextStyle get dutyLabelStyle: Utilise _textTheme.titleMedium

// static TextStyle get dutyDetailStyle: Utilise _textTheme.titleSmall

// static TextStyle get dutyDateStyle: Utilise _textTheme.labelLarge

// static TextStyle get dutyDayStyle: Utilise _textTheme.labelMedium

// static TextStyle get dutyMonthStyle: Utilise _textTheme.labelMedium

// CardeEtape

// static TextStyle get dateEtapeStyle: Utilise _textTheme.titleMedium

// static TextStyle get titleEtapeStyle: Utilise _textTheme.titleSmall

// CardeNextduty

// static TextStyle get nextDutyDateStyle: Utilise _textTheme.headlineSmall

// static TextStyle get nextDutyStepStyle: Utilise _textTheme.headlineSmall

// static TextStyle get nextDutyTypeStyle: Utilise _textTheme.displayMedium

// static TextStyle get nextDutyDetailStyle: Utilise _textTheme.labelSmall

// CardeForfait

// static TextStyle get forfaitLabelStyle: Utilise _textTheme.displayMedium

// static TextStyle get forfaitTotalStyle: Utilise _textTheme.displayMedium

// CardeTsv

// static TextStyle get tsvDateStyle: Utilise _textTheme.labelMedium

// CardeHeure

// static TextStyle get sunriseStyle: Utilise _textTheme.labelMedium

// static TextStyle get forfaitStyle: Utilise _textTheme.labelMedium

// static TextStyle get totalStyle: Utilise _textTheme.labelMedium

// CadreSalaire

// static TextStyle get salaireStyle: Utilise _textTheme.labelMedium
