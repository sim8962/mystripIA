import 'package:flutter/material.dart';

import '../../../Models/ActsModels/myduty.dart';
import '../../../Models/ActsModels/typ_const.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';

import 'cadre_rv.dart';
import 'carde_duty.dart';
import 'carde_typ.dart';
import 'crewtable.dart';

class CardDutys extends StatelessWidget {
  const CardDutys({required this.duty, super.key});
  final MyDuty duty;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 5), vertical: AppTheme.h(x: 3)),
      padding: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 5), vertical: AppTheme.h(x: 1)),
      decoration: AppTheme.fondDuty,
      child: ListTileTheme(
        contentPadding: EdgeInsets.all(AppTheme.s(x: 2)),
        horizontalTitleGap: 3 * AppTheme.s(x: 2),
        child: (duty.typ.target != tVols && duty.typ.target != tRotation)
            ? (duty.crews.isEmpty)
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: AppTheme.h(x: 4.0)),
                      child: Cardeduty(duty: duty),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: AppTheme.h(x: 4.0)),
                      child: CardeRv(duty: duty),
                    )
            : ExpansionTile(
                onExpansionChanged: null,
                title: Cardeduty(duty: duty),
                iconColor: Colors.red,
                collapsedIconColor: Colors.blue,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.centerLeft,
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  size: AppTheme.r(x: 25.0),
                  color: AppColors.primaryLightColor,
                ),
                children: [
                  Container(
                    color: AppTheme.fonfColor,
                    child: Column(
                      children: duty.etapes.map((myEtape) {
                        if (myEtape.crews.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: CardeTyp(etape: myEtape),
                          );
                        } else {
                          return ExpansionTile(
                            onExpansionChanged: null,
                            title: CardeTyp(etape: myEtape),
                            iconColor: Colors.red,
                            collapsedIconColor: Colors.blue,
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            expandedAlignment: Alignment.centerLeft,
                            trailing: Icon(
                              Icons.keyboard_arrow_down,
                              size: AppTheme.r(x: 20.0),
                              color: AppColors.primaryLightColor,
                            ),
                            children: [
                              Column(children: [CrewTable(crews: myEtape.crews)]),
                            ],
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
