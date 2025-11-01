import 'package:flutter/material.dart';

import '../../../Models/VolsModels/vol.dart';

import '../../../helpers/constants.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';
import '../../widgets/Cardes/crewtable.dart';

class CardVolModelCompare extends StatelessWidget {
  const CardVolModelCompare({super.key, required this.vol});

  final VolModel vol;

  @override
  Widget build(BuildContext context) {
    // Check if vol has crews
    final hasCrew = vol.crews.isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 5), vertical: AppTheme.h(x: 3)),
      padding: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 5), vertical: AppTheme.h(x: 1)),
      decoration: AppTheme.fondDuty,
      child: ListTileTheme(
        contentPadding: EdgeInsets.all(AppTheme.s(x: 2)),
        horizontalTitleGap: 3 * AppTheme.s(x: 2),
        child: hasCrew
            ? ExpansionTile(
                onExpansionChanged: null,
                title: _buildCardContent(),
                iconColor: Colors.red,
                collapsedIconColor: Colors.blue,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.centerLeft,
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  size: AppTheme.r(x: 25.0),
                  color: AppColors.primaryLightColor,
                ),
                children: [CrewTable(crews: vol.crews.toList())],
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: AppTheme.h(x: 4.0)),
                child: _buildCardContent(),
              ),
      ),
    );
  }

  /// Build the main card content (used both in ExpansionTile and standalone)
  Widget _buildCardContent() {
    return Row(
      children: [
        // Left side: Date column
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
                    Text(dateFormatEE.format(vol.dtDebut), style: AppStylingConstant.dutyDayStyle),
                    Text(dateFormatdd.format(vol.dtDebut), style: AppStylingConstant.dutyDateStyle),
                    Text(dateFormatMM.format(vol.dtDebut), style: AppStylingConstant.dutyMonthStyle),
                  ],
                ),
              ),
              // Color bar based on flight type
              Container(width: 5, color: _getTypeColor()),
            ],
          ),
        ),
        // Type icon
        Container(
          margin: EdgeInsets.only(left: AppTheme.w(x: 5), right: AppTheme.w(x: 10)),
          height: AppTheme.getheight(iphoneSize: 50, ipadsize: 52),
          width: AppTheme.getWidth(iphoneSize: 50, ipadsize: 52),
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
            backgroundColor: _getTypeColor(),
            child: Text(
              vol.typ.isNotEmpty ? vol.typ.substring(0, 1).toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        // Right side: Flight details
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date label
              Text(_getDateLabel(), style: AppStylingConstant.dateLabelStyle, overflow: TextOverflow.fade),
              // Flight type and number
              Text(
                vol.typ.isEmpty ? 'Unknown' : vol.typ,
                style: AppStylingConstant.dutyLabelStyle,
                overflow: TextOverflow.ellipsis,
              ),
              // Route and times
              SizedBox(
                width: AppTheme.w(x: 186),
                child: Text(
                  _getDetailLabel(),
                  style: AppStylingConstant.dutyDetailStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get color based on flight type
  Color _getTypeColor() {
    switch (vol.typ.toLowerCase()) {
      case 'vol':
        return AppColors.primaryLightColor;
      case 'mep':
      case 'tax':
        return AppColors.secondaryColor;
      case 'htl':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Format date label
  String _getDateLabel() {
    return vol.dtDebut.toString().split(' ')[0];
  }

  /// Format detail label with route and times
  String _getDetailLabel() {
    final from = vol.depIata.isEmpty ? '?' : vol.depIata;
    final to = vol.arrIata.isEmpty ? '?' : vol.arrIata;
    final depTime = vol.dtDebut.toString().split(' ')[1].substring(0, 5);
    final arrTime = vol.dtFin.toString().split(' ')[1].substring(0, 5);
    return '$from → $to  $depTime - $arrTime';
  }
}
