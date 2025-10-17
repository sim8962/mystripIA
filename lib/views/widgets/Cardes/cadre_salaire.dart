import 'package:flutter/material.dart';

import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';

class CadreSalaire extends StatelessWidget {
  const CadreSalaire({required this.titre, required this.total, super.key});
  //final String myColor;
  final String titre;
  final String total;
  @override
  Widget build(BuildContext context) {
    return titre == '0'
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   height: MyStyling.h(x: 26),
              //   width: MyStyling.w(x: 2),
              //   decoration: BoxDecoration(
              //     color: HexColor(myColor).withOpacity(0.5),
              //     //  HexColor('#87A0E5').withOpacity(0.5),
              //     borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(AppTheme.s(x: 2)),
                child: Padding(
                  padding: EdgeInsets.only(left: AppTheme.w(x: 2), bottom: AppTheme.h(x: 2)),
                  child: Text(
                    '${total.toUpperCase()} $titre',
                    textAlign: TextAlign.center,
                    style: AppStylingConstant.salaireStyle,
                  ),
                ),
              ),
            ],
          );
  }
}
