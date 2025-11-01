import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/stringvols/svolmodel.dart';
import '../../../controllers/database_controller.dart';
import '../../../helpers/constants.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';

final weekdays = [
  'weekday_monday'.tr,
  'weekday_tuesday'.tr,
  'weekday_wednesday'.tr,
  'weekday_thursday'.tr,
  'weekday_friday'.tr,
  'weekday_saturday'.tr,
  'weekday_sunday'.tr,
];

final months = [
  'month_jan'.tr,
  'month_feb'.tr,
  'month_mar'.tr,
  'month_apr'.tr,
  'month_may'.tr,
  'month_jun'.tr,
  'month_jul'.tr,
  'month_aug'.tr,
  'month_sep'.tr,
  'month_oct'.tr,
  'month_nov'.tr,
  'month_dec'.tr,
];

/// Widget utility class for StringVolModel display (similar to VolTraiteWidget)
class StringVolModelWidget {
  /// Flight date header (weekday, day, month, TSV)
  static Widget buildFlightDateHeader(StringVolModel stringVol) {
    final parts = stringVol.sDebut.split(' ');
    final dateParts = parts[0].split('/');
    final date = DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]), int.parse(dateParts[0]));
    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getWidth(iphoneSize: 12, ipadsize: 12),
        vertical: AppTheme.getheight(iphoneSize: 10, ipadsize: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$weekday $day, $month', style: AppStylingConstant.volDetailMonthStyle),
          Expanded(child: SizedBox()),
          if (stringVol.tsv.isNotEmpty)
            Text(
              stringVol.tsv.toUpperCase(),
              style: AppStylingConstant.volDetailMonthStyle.copyWith(fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }

  /// Flight airports section with IATA codes and times
  static Widget buildFlightAirportsSection(StringVolModel stringVol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 20, ipadsize: 20),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      child: Row(
        children: [
          // Departure
          buildAirportDateInfo(
            icao: stringVol.depIcao.isNotEmpty ? stringVol.depIcao : '',
            iata: stringVol.depIata.isNotEmpty ? stringVol.depIata : '',
            hour: stringVol.sDebut.split(' ').length > 1 ? stringVol.sDebut.split(' ')[1] : '00:00',
          ),
          // Arrival
          buildAirportDateInfo(
            icao: stringVol.arrIcao.isNotEmpty ? stringVol.arrIcao : '',
            iata: stringVol.arrIata.isNotEmpty ? stringVol.arrIata : '',
            hour: stringVol.sFin.split(' ').length > 1 ? stringVol.sFin.split(' ')[1] : '00:00',
          ),
        ],
      ),
    );
  }

  static Expanded buildAirportDateInfo({required String icao, required String iata, required String hour}) {
    return Expanded(
      child: Column(
        children: [
          Text(icao, style: AppStylingConstant.volDetailICAOStyle),
          SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
          Text(iata, style: AppStylingConstant.volDetailIATAStyle),
          SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
          Text('$hour z', style: AppStylingConstant.volNumeriq),
        ],
      ),
    );
  }

  /// Flight info section (flight number, aircraft, TSV)
  static Widget buildFlightInfoSection(StringVolModel stringVol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 8, ipadsize: 8),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Flight type
          Row(
            children: [
              Text(
                stringVol.sSunrise,
                style: AppStylingConstant.volNumeriq.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
              buidImage(urlImage: urlSunrise),
            ],
          ),
          // Divider left
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          ),
          // Aircraft
          Column(
            children: [
              Text(stringVol.nVol.isNotEmpty ? stringVol.nVol : '', style: AppStylingConstant.volNvol),
              Text(
                stringVol.sAvion,
                style: AppStylingConstant.volDetailICAOStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 16),
                ),
              ),
            ],
          ),
          // Divider right
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          ),
          // TSV if available
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(stringVol.sSunset, style: AppStylingConstant.volNumeriq),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
              buidImage(urlImage: urlSunset),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buidImage({required String urlImage}) => SizedBox(
    height: AppTheme.getheight(iphoneSize: 25, ipadsize: 30),
    width: AppTheme.getheight(iphoneSize: 25, ipadsize: 30),
    child: Image(
      color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
      image: AssetImage(urlImage),
    ),
  );

  /// Durations section (flight, forfait, night + cumuls)

  static Widget buildDurationsSection(StringVolModel stringVol) {
    final isVol = stringVol.typ == 'Vol';

    return Container(
      margin: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 5, ipadsize: 5)),
      //padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 8, ipadsize: 5)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            width: 1,
          ),
        ),
      ),
      // padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 12, ipadsize: 12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First row: D, F, N
          Column(
            children: [
              buildDurationItem(
                label: '${'flight_duration_label'.tr}: ${isVol ? stringVol.sDureevol : stringVol.sDureeMep}',
              ),
              SizedBox(width: AppTheme.getheight(iphoneSize: 8, ipadsize: 8)),
              buildDurationItem(
                label:
                    '${'flight_total_duration_label'.tr}: ${isVol ? stringVol.sCumulDureeVol : stringVol.sCumulDureeMep}',
              ),
            ],
          ),

          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          ),
          Column(
            children: [
              buildDurationItem(
                label: isVol ? '${'flight_forfait_label'.tr}: ${stringVol.sDureeForfait}' : '',
              ),
              SizedBox(width: AppTheme.getheight(iphoneSize: 8, ipadsize: 8)),
              buildDurationItem(
                label:
                    '${'flight_total_forfait_label'.tr}: ${isVol ? stringVol.sCumulDureeForfait : stringVol.sCumulMepForfait}',
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          ),
          Column(
            children: [
              buildDurationItem(label: isVol ? '${'flight_night_label'.tr}: ${stringVol.sNuitForfait}' : ''),
              SizedBox(width: AppTheme.getheight(iphoneSize: 8, ipadsize: 8)),
              buildDurationItem(
                label: '${'flight_total_night_label'.tr}: ${isVol ? stringVol.sCumulNuitForfait : "00h00"}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildDurationItem({required String label}) {
    if (label.contains('00h00')) label = label.replaceAll('00h00', 'flight_nil'.tr);
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.getRadius(iphoneSize: 6, ipadsize: 6)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppStylingConstant.volNumeriq.copyWith(
          fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Duty date header
  static Widget buildDutyDateHeader(StringVolModel stringVol, String dateStr) {
    final parts = dateStr.split(' ');
    final dateParts = parts[0].split('/');
    final date = DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]), int.parse(dateParts[0]));
    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final hour = parts.length > 1 ? parts[1] : '00:00';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getWidth(iphoneSize: 12, ipadsize: 12),
        vertical: AppTheme.getheight(iphoneSize: 10, ipadsize: 10),
      ),
      child: Text('$weekday $day, $hour z', style: AppStylingConstant.volDetailMonthStyle),
    );
  }

  /// HTL airports section
  static Widget buildHtlAirportsSection(StringVolModel stringVol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 20, ipadsize: 20),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              stringVol.depIcao.isNotEmpty ? stringVol.depIcao : '-',
              style: AppStylingConstant.volDetailICAOStyle,
            ),
            SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
            Text(
              getAirportCity(stringVol.depIata),
              style: AppStylingConstant.volDetailIATAStyle.copyWith(
                fontSize: AppTheme.getfontSize(iphoneSize: 28, ipadsize: 28),
              ),
            ),
            SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
            Text(
              _calculateHtlDuration(stringVol),
              style: AppStylingConstant.volNumeriq.copyWith(
                fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate HTL duration between sDebut and sFin
  static String _calculateHtlDuration(StringVolModel stringVol) {
    try {
      final parts1 = stringVol.sDebut.split(' ');
      final parts2 = stringVol.sFin.split(' ');

      final dateParts1 = parts1[0].split('/');
      final timeParts1 = parts1.length > 1 ? parts1[1].split(':') : ['00', '00'];

      final dateParts2 = parts2[0].split('/');
      final timeParts2 = parts2.length > 1 ? parts2[1].split(':') : ['00', '00'];

      final debut = DateTime(
        int.parse(dateParts1[2]),
        int.parse(dateParts1[1]),
        int.parse(dateParts1[0]),
        int.parse(timeParts1[0]),
        int.parse(timeParts1[1]),
      );

      final fin = DateTime(
        int.parse(dateParts2[2]),
        int.parse(dateParts2[1]),
        int.parse(dateParts2[0]),
        int.parse(timeParts2[0]),
        int.parse(timeParts2[1]),
      );

      final difference = fin.difference(debut);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      return '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00h00';
    }
  }

  /// Duty airports section
  static Widget buildDutyAirportsSection(StringVolModel stringVol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 20, ipadsize: 20),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              stringVol.depIcao.isNotEmpty ? stringVol.depIcao : '-',
              style: AppStylingConstant.volDetailICAOStyle,
            ),
            SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
            Text(
              stringVol.depIata.isNotEmpty ? stringVol.depIata : '-',
              style: AppStylingConstant.volDetailIATAStyle,
            ),
            SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
            Text(
              stringVol.sDebut.split(' ').length > 1 ? stringVol.sDebut.split(' ')[1] : '00:00',
              style: AppStylingConstant.volNumeriq.copyWith(
                fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String getAirportCity(String icao) => DatabaseController.instance.getAirportCity(icao);
}
