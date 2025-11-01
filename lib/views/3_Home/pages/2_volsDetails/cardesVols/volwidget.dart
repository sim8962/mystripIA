import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Models/VolsModels/vol_traite.dart';
import '../../../../../controllers/database_controller.dart';
import '../../../../../helpers/constants.dart';
import '../../../../../theming/app_color.dart';
import '../../../../../theming/app_theme.dart';
import '../../../../../theming/apptheme_constant.dart';

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

class VolTraiteWidget {
  /// Date header avec bouton +
  static Widget buildFlightDateHeader(VolTraiteModel vol) {
    final weekday = weekdays[vol.dtDebut.weekday - 1];
    final day = vol.dtDebut.day;
    final month = months[vol.dtDebut.month - 1];

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
          if (vol.tsv.isNotEmpty)
            Text(
              vol.tsv.toUpperCase(),
              style: AppStylingConstant.volDetailMonthStyle.copyWith(fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }

  /// Section aéroports avec codes IATA en grand
  static Widget buildFlightAirportsSection(VolTraiteModel vol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 20, ipadsize: 20),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      child: Row(
        children: [
          // Départ
          buildAiroportDateInfo(
            icao: vol.depIcao.isNotEmpty ? vol.depIcao : '',
            iata: vol.depIata.isNotEmpty ? vol.depIata : '',
            hour: vol.sDebut,
          ),
          buildAiroportDateInfo(
            icao: vol.arrIcao.isNotEmpty ? vol.arrIcao : '',
            iata: vol.arrIata.isNotEmpty ? vol.arrIata : '',
            hour: vol.sFin,
          ),

          // Arrivée
        ],
      ),
    );
  }

  static Expanded buildAiroportDateInfo({required String icao, required String iata, required String hour}) {
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

  /// Section info vol (numéro, compagnie, durée)
  static Widget buildFlightInfoSection(VolTraiteModel vol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 8, ipadsize: 8),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      decoration: BoxDecoration(
        //color: AppColors.volCardSecondary.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(color: AppColors.volCardText.withValues(alpha: 0.3), width: 1),
          bottom: BorderSide(color: AppColors.volCardText.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Durée départ avec icône
          Row(
            children: [
              Text(vol.sSunrise, style: AppStylingConstant.volNumeriq.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
              buidImage(urlImage: urlSunrise),
            ],
          ),
          // Divider gauche
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          ),
          // Numéro de vol et compagnie
          Column(
            children: [
              Text(vol.nVol.isNotEmpty ? vol.nVol : '', style: AppStylingConstant.volNvol),
              Text(
                vol.sAvion,
                style: AppStylingConstant.volDetailICAOStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 16),
                ),
              ),
            ],
          ),
          // Divider droit
          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          ),

          // Durée arrivée avec icône
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(vol.sSunset, style: AppStylingConstant.volNumeriq),
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

  /// Section durées (D, F, N, T.D, T.F, T.N)
  static Widget buildDurationsSection(VolTraiteModel vol) {
    final isVol = vol.sDureevol.isNotEmpty;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 12, ipadsize: 12)),
      //decoration: BoxDecoration(color: C),
      child: Column(
        children: [
          // Première ligne: D, F, N
          Row(
            children: [
              Expanded(
                child: buildDurationItem(
                  label: '${'flight_duration_label'.tr}: ${isVol ? vol.sDureevol : vol.sDureeMep}',
                ),
              ),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
              Expanded(
                child: buildDurationItem(
                  label: '${'flight_forfait_label'.tr}: ${isVol ? vol.sDureeForfait : vol.sMepForfait}',
                ),
              ),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
              Expanded(
                child: buildDurationItem(
                  label: '${'flight_night_label'.tr}: ${isVol ? vol.sNuitVol : "00h00"}',
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.getheight(iphoneSize: 8, ipadsize: 8)),
          // Deuxième ligne: T.D, T.F, T.N
          Row(
            children: [
              Expanded(
                child: buildDurationItem(
                  label:
                      '${'flight_total_duration_label'.tr}: ${isVol ? vol.sCumulDureeVol : vol.sCumulDureeMep}',
                ),
              ),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
              Expanded(
                child: buildDurationItem(
                  label:
                      '${'flight_total_forfait_label'.tr}: ${isVol ? vol.sCumulDureeForfait : vol.sCumulMepForfait}',
                ),
              ),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
              Expanded(
                child: buildDurationItem(
                  label: '${'flight_total_night_label'.tr}: ${isVol ? vol.sCumulNuitVol : "00h00"}',
                ),
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
      padding: EdgeInsets.symmetric(
        // vertical: AppTheme.getheight(iphoneSize: 8, ipadsize: 8),
        // horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 8),
      ),
      decoration: BoxDecoration(
        // color: AppColors.colorWhite.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppTheme.getRadius(iphoneSize: 6, ipadsize: 6)),
      ),
      child: Text(label, textAlign: TextAlign.center, style: AppStylingConstant.volNumeriq),
    );
  }

  /// Section équipage
  static Widget buildCrewSection(List<Map<String, String>> crewMembers, VolTraiteModel vol) {
    // Récupérer les données de l'équipage depuis vol.crewsList
    var crewMembers = vol.crewsList;
    double space1 = 55;
    double space2 = 40;

    // TEMPORAIRE: Données de test si vide (à retirer quand les crews seront chargés)

    return Container(
      margin: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 5, ipadsize: 5)),
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 8, ipadsize: 5)),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
        border: Border.all(
          width: 1,
          color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
        ),
      ),
      child: Column(
        children: [
          // En-tête du tableau
          Row(
            children: [
              SizedBox(
                width: AppTheme.getWidth(iphoneSize: space1, ipadsize: space1),
                child: Text('crew_sen'.tr, style: AppStylingConstant.volTitreCrew),
              ),
              SizedBox(
                width: AppTheme.getWidth(iphoneSize: space2, ipadsize: space2),
                child: Text('crew_position'.tr, style: AppStylingConstant.volTitreCrew),
              ),
              Expanded(child: Text('crew_name'.tr, style: AppStylingConstant.volTitreCrew)),
            ],
          ),
          Divider(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            thickness: 1,
            height: AppTheme.getheight(iphoneSize: 16, ipadsize: 16),
          ),
          // Lignes du tableau
          ...crewMembers.asMap().entries.map((entry) {
            final member = entry.value;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppTheme.getheight(iphoneSize: 6, ipadsize: 6)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppTheme.getWidth(iphoneSize: space1, ipadsize: space1),
                        child: Text(member['sen'] ?? '', style: AppStylingConstant.volCrew),
                      ),
                      SizedBox(
                        width: AppTheme.getWidth(iphoneSize: space2, ipadsize: space2),
                        child: Text(member['pos'] ?? '', style: AppStylingConstant.volCrew),
                      ),
                      Expanded(child: Text(member['name'] ?? '', style: AppStylingConstant.volCrew)),
                    ],
                  ),
                ),
                if (entry.key < crewMembers.length - 1)
                  Divider(
                    color: AppTheme.isDark
                        ? AppColors.errorColor.withValues(alpha: 0.3)
                        : AppColors.primaryLightColor.withValues(alpha: 0.3),
                    thickness: 0.5,
                    height: 1,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Date header avec bouton +
  static Widget builDutydDateHeader(DateTime date, String hour) {
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
          Text('$weekday $day, $month $hour z', style: AppStylingConstant.volDetailMonthStyle),

          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  /// Section aéroports avec codes IATA en grand
  static Widget buildDutyAirportsSection(VolTraiteModel vol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 20, ipadsize: 20),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // Text(vol.depIcao.isNotEmpty ? vol.depIcao : '', style: AppStylingConstant.volDetailICAOStyle),
                // SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
                Text(vol.nVol, style: AppStylingConstant.volDetailIATAStyle),
                SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
                Text(
                  vol.sDureeBrute,
                  style: AppStylingConstant.volNumeriq.copyWith(
                    fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 16),
                  ),
                ),
              ],
            ),
          ),
          // Arrivée
        ],
      ),
    );
  }

  /// Section aéroports avec codes IATA en grand
  static Widget buildHtlAirportsSection(VolTraiteModel vol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.getheight(iphoneSize: 20, ipadsize: 20),
        horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(vol.depIcao.isNotEmpty ? vol.depIcao : '', style: AppStylingConstant.volDetailICAOStyle),
                SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
                Text(
                  getAirportCity(vol.depIata),
                  style: AppStylingConstant.volDetailIATAStyle.copyWith(
                    fontSize: AppTheme.getfontSize(iphoneSize: 26, ipadsize: 26),
                  ),
                ),
                SizedBox(height: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
                Text(
                  vol.sDureeBrute,
                  style: AppStylingConstant.volNumeriq.copyWith(
                    fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 16),
                  ),
                ),
              ],
            ),
          ),
          // Arrivée
        ],
      ),
    );
  }

  static String getAirportCity(String icao) => DatabaseController.instance.getAirportCity(icao);
}
