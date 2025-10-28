import 'package:flutter/material.dart';

import '../../../../../Models/VolsModels/vol_traite.dart';
import '../../../../../theming/app_color.dart';
import '../../../../../theming/app_theme.dart';

import '../../2_volsDetails/cardesVols/volwidget.dart';
import '../../2_volsDetails/vot_controller.dart';

class DutyCard extends StatelessWidget {
  final VolTraiteModel vol;
  final VolController controller;

  const DutyCard({super.key, required this.vol, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.h(x: 12)),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
        border: Border.all(
          width: 1,
          color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VolTraiteWidget.builDutydDateHeader(vol.dtDebut, vol.sDebut),
          VolTraiteWidget.buildDutyAirportsSection(vol),
          VolTraiteWidget.builDutydDateHeader(vol.dtFin, vol.sFin),
          if (vol.crewsList.isNotEmpty) VolTraiteWidget.buildCrewSection(vol.crewsList, vol),
        ],
      ),
    );
  }
}
