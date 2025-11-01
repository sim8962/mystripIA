import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../../../Models/ActsModels/typ_const.dart';
import '../../../Models/stringvols/svolmodel.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';
import 'string_vol_model_widget.dart';

/// Widget de carte pour afficher les détails d'un StringVolModel avec UI style FlightCard/HtlCard/DutyCard
/// Exactly matches _buildVolTraiteCard logic (no crews, HTL different, etc.)
class CardStringVolModelCompare extends StatelessWidget {
  final StringVolModel stringVol;

  const CardStringVolModelCompare({super.key, required this.stringVol});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 5, ipadsize: 5)),
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.getRadius(iphoneSize: 8, ipadsize: 8)),
        border: Border.all(
          color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Determine card type based on flight type - exactly like _buildVolTraiteCard
          if (stringVol.typ == tVol.typ || stringVol.typ == tMEP.typ || stringVol.typ == tTAX.typ) ...[
            // FlightCard style for Vol/MEP/TAX
            StringVolModelWidget.buildFlightDateHeader(stringVol),
            StringVolModelWidget.buildFlightAirportsSection(stringVol),
            StringVolModelWidget.buildFlightInfoSection(stringVol),
            StringVolModelWidget.buildDurationsSection(stringVol),
            // Display crews if available
            if (_getCrewsList().isNotEmpty) _buildCrewsSection(),
          ] else if (stringVol.typ == tHTL.typ) ...[
            // HtlCard style for HTL - different from others
            StringVolModelWidget.buildDutyDateHeader(stringVol, stringVol.sDebut),
            StringVolModelWidget.buildHtlAirportsSection(stringVol),
            StringVolModelWidget.buildDutyDateHeader(stringVol, stringVol.sFin),
          ] else if (stringVol.typ == tRV.typ) ...[
            // DutyCard style for RV
            StringVolModelWidget.buildDutyDateHeader(stringVol, stringVol.sDebut),
            StringVolModelWidget.buildDutyAirportsSection(stringVol),
            StringVolModelWidget.buildDutyDateHeader(stringVol, stringVol.sFin),
            if (_getCrewsList().isNotEmpty) _buildCrewsSection(),
          ] else ...[
            // DutyCard style for other types
            StringVolModelWidget.buildDutyDateHeader(stringVol, stringVol.sDebut),
            StringVolModelWidget.buildDutyAirportsSection(stringVol),
            StringVolModelWidget.buildDutyDateHeader(stringVol, stringVol.sFin),
          ],
        ],
      ),
    );
  }

  /// Parse crews from JSON string
  List<Map<String, dynamic>> _getCrewsList() {
    try {
      if (stringVol.crews.isEmpty || stringVol.crews == '[]') {
        return [];
      }
      final List<dynamic> crewsJson = jsonDecode(stringVol.crews);
      return crewsJson.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Build crews section (displayed as table)
  Widget _buildCrewsSection() {
    final crews = _getCrewsList();
    if (crews.isEmpty) return SizedBox.shrink();

    double space1 = 55;
    double space2 = 40;

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
          // Header row
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
          // Crew rows
          ...crews.asMap().entries.map((entry) {
            final member = entry.value;
            final crewId = member['crewId'] ?? '';
            final pos = member['pos'] ?? '';
            final name = '${member['firstname'] ?? ''} ${member['lastname'] ?? ''}'.trim();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppTheme.getheight(iphoneSize: 6, ipadsize: 6)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppTheme.getWidth(iphoneSize: space1, ipadsize: space1),
                        child: Text(crewId, style: AppStylingConstant.volCrew),
                      ),
                      SizedBox(
                        width: AppTheme.getWidth(iphoneSize: space2, ipadsize: space2),
                        child: Text(pos, style: AppStylingConstant.volCrew),
                      ),
                      Expanded(child: Text(name, style: AppStylingConstant.volCrew)),
                    ],
                  ),
                ),
                if (entry.key < crews.length - 1)
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
}
