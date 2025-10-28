import 'package:flutter/material.dart';

import '../../../../../Models/VolsModels/vol_traite.dart';

import '../../../../../theming/app_color.dart';
import '../../../../../theming/app_theme.dart';

import '../vot_controller.dart';
import 'volwidget.dart';

class HtlCard extends StatelessWidget {
  final VolTraiteModel vol;
  final VolController controller;

  const HtlCard({super.key, required this.vol, required this.controller});

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
          VolTraiteWidget.buildHtlAirportsSection(vol),
          VolTraiteWidget.builDutydDateHeader(vol.dtFin, vol.sFin),
        ],
      ),
    );
  }
}
