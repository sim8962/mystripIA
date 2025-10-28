import 'package:flutter/material.dart';

import '../../../Models/ActsModels/myetape.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';

class CardeTsv extends StatelessWidget {
  const CardeTsv({super.key, required this.etape});

  final MyEtape etape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MyStyling.w(x: 340),
      height: AppTheme.h(x: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 1,
            width: AppTheme.getWidth(iphoneSize: 310, ipadsize: 340),
            color: AppColors.primaryLightColor,
          ),
          Center(
            child: Text(
              etape.translatedDateLabel,
              style: AppStylingConstant.tsvDateStyle,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // if (etape.volTraite != null) CardeHeure(volTraite: etape.volTraite!),
          // if (etape.volTransit != null) CardeForfait(volTransit: etape.volTransit!)
        ],
      ),
    );
  }
}
