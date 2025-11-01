import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

import '../../../Models/ActsModels/myduty.dart';
import '../../../helpers/constants.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';

class Cardeduty extends StatelessWidget {
  const Cardeduty({super.key, required this.duty});

  final MyDuty duty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppTheme.getWidth(iphoneSize: 55, ipadsize: 65),
          height: AppTheme.getWidth(iphoneSize: 80, ipadsize: 93),
          color: (AppTheme.isDark != true) ? Colors.white : AppColors.darkBackground,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppTheme.h(x: 4), horizontal: AppTheme.w(x: 8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(dateFormatEE.format(duty.startTime), style: AppStylingConstant.dutyDayStyle),
                    Text(dateFormatdd.format(duty.startTime), style: AppStylingConstant.dutyDateStyle),
                    Text(dateFormatMM.format(duty.startTime), style: AppStylingConstant.dutyMonthStyle),
                  ],
                ),
              ),
              if (duty.typ.target != null) Container(width: 5, color: HexColor(duty.typ.target!.color)),
            ],
          ),
        ),
        if (duty.typ.target != null)
          Container(
            margin: EdgeInsets.only(left: AppTheme.w(x: 5), right: AppTheme.w(x: 10)),
            height: AppTheme.getheight(iphoneSize: 50, ipadsize: 52),
            width: AppTheme.getWidth(iphoneSize: 50, ipadsize: 52),
            // (boxGet.read(getDevice) == getIphone) ? MyStyling.r(x: 50) : MyStyling.r(x: 52),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(),
                  blurRadius: 1.0,
                  offset: const Offset(2.0, 2.0),
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage('$cheminImage${duty.typ.target!.icon}.jpg'),
              radius: AppTheme.r(x: 2),
            ),
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(duty.dateLabel, style: AppStylingConstant.dateLabelStyle, overflow: TextOverflow.fade),
            Text(
              duty.typ.target?.label ?? duty.typeLabel,
              style: AppStylingConstant.dutyLabelStyle,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              width: AppTheme.w(x: 186),
              child: Text(
                duty.detailLabel,
                style: AppStylingConstant.dutyDetailStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
