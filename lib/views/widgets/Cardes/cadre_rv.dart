import 'package:flutter/material.dart';

import '../../../Models/ActsModels/myduty.dart';
import '../../../theming/app_theme.dart';
import 'carde_duty.dart';
import 'crewtable.dart';

class CardeRv extends StatelessWidget {
  const CardeRv({super.key, required this.duty});

  final MyDuty duty;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: null,
      title: Cardeduty(duty: duty),
      iconColor: Colors.red,
      collapsedIconColor: Colors.blue,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      trailing: Icon(Icons.keyboard_arrow_down, size: AppTheme.r(x: 20.0)),
      children: [CrewTable(crews: duty.crews)],
    );
  }
}
