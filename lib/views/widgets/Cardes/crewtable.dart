import 'package:flutter/material.dart';

import '../../../Models/ActsModels/crew.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';

class CrewTable extends StatelessWidget {
  const CrewTable({super.key, required this.crews});
  final List<Crew> crews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: AppTheme.fondDuty,
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(color: AppColors.primaryLightColor, width: 0.5),
          ),
          columnWidths: {
            0: FixedColumnWidth(AppTheme.w(x: 60.0)),
            1: FixedColumnWidth(AppTheme.w(x: 55.0)),
            2: FixedColumnWidth(AppTheme.w(x: 210.0)),
          },
          children: [
            TableRow(
              children: [
                tableHeaderCell(context, 'Mat', alignment: Alignment.centerRight),
                tableHeaderCell(context, 'pos'),
                tableHeaderCell(context, 'name', alignment: Alignment.centerLeft),
              ],
            ),
            for (var crew in crews)
              TableRow(
                children: [
                  tableCell(context, crew.crewId, alignment: Alignment.centerRight),
                  tableCell(context, crew.pos),
                  tableCell(context, '${crew.lastname} ${crew.firstname}', alignment: Alignment.centerLeft),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget tableHeaderCell(BuildContext context, String text, {Alignment alignment = Alignment.center}) {
    return Container(
      height: AppTheme.h(x: 40),
      color: AppTheme.fonfColor,
      padding: const EdgeInsets.all(8.0),
      alignment: alignment,
      child: Text(text, style: AppStylingConstant.crewTableCellStyle, overflow: TextOverflow.ellipsis),
    );
  }

  Widget tableCell(BuildContext context, String text, {Alignment alignment = Alignment.center}) {
    return Container(
      height: AppTheme.h(x: 40),
      padding: const EdgeInsets.all(8.0),
      alignment: alignment,
      child: Text(text, style: AppStylingConstant.crewTableCellStyle, overflow: TextOverflow.ellipsis),
    );
  }
}
