import 'package:flutter/material.dart';

import '../../../Models/ActsModels/myetape.dart';
import '../../../helpers/constants.dart';

import '../../../theming/app_theme.dart';

import '../../../theming/apptheme_constant.dart';

class CardeEtape extends StatelessWidget {
  const CardeEtape({super.key, required this.etape});

  final MyEtape etape;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height:
      //     (etape.volTraite.target != null) ? AppTheme.getheight(iphoneSize: 150.0, ipadsize: 155.0) : null,
      margin: EdgeInsets.only(
        left: AppTheme.h(x: 10.0),
        right: AppTheme.w(x: 4.0),
        // top: Theming.h(x: 2.0),
        bottom: AppTheme.h(x: 0.0),
      ),
      decoration: AppTheme.fondDuty,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              SizedBox(width: AppTheme.getWidth(iphoneSize: 20, ipadsize: 20)),
              Container(
                margin: EdgeInsets.only(left: AppTheme.w(x: 5), right: AppTheme.w(x: 10)),
                height: AppTheme.getheight(iphoneSize: 40.0, ipadsize: 52.0),
                width: AppTheme.getheight(iphoneSize: 40.0, ipadsize: 52.0),
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
                  backgroundImage: AssetImage('$cheminImage${etape.typ.target!.icon}.jpg'),
                  radius: AppTheme.s(x: 2),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppTheme.getWidth(iphoneSize: 228, ipadsize: 228),
                    child: Text(
                      etape.dateLabel,
                      style: AppStylingConstant.dateEtapeStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      width: AppTheme.w(x: 228),
                      child: Text(
                        etape.translatedTypeLabel,
                        style: AppStylingConstant.titleEtapeStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (etape.detailLabel.isNotEmpty)
                    SizedBox(
                      width: boxGet.read(getDevice) == getIphone ? AppTheme.w(x: 228) : AppTheme.w(x: 240),
                      child: Text(
                        etape.translatedDetailLabel,
                        style: AppStylingConstant.titleEtapeStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ],
          ),
          //  if (etape.volTraite.target != null) CardeHeure(volTraite: etape.volTraite.target!),
        ],
      ),
    );
  }
}
