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
