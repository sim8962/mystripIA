import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';

import '../../../../theming/app_color.dart';
import '../../../../theming/app_theme.dart';
import '../../Models/ActsModels/myduty.dart';

import '../../controllers/database_controller.dart';
import '../../helpers/constants.dart';
import '../3_Home/pages/3_calendrier/calendar_controller.dart';

class CalendarDayWidget extends GetView<CalendarController> {
  final DateTime date;
  final double width;
  final bool isCurrentMonth;

  const CalendarDayWidget({
    super.key,
    required this.width,
    required this.date,

    required this.isCurrentMonth,
    required CalendarController controller,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(date);

    @override
    final dayStart = DateTime(date.year, date.month, date.day, 0, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final hasOverflow = DatabaseController.instance.duties.any(
      (e) =>
          e.endTime.isAfter(dayStart) &&
          e.startTime.isBefore(dayEnd) &&
          (e.startTime.isBefore(dayStart) || e.endTime.isAfter(dayEnd)),
    );

    return GestureDetector(
      onTap: () {
        CalendarController.instance.selectedDuty.value = date;
      },
      child: Container(
        width: width / 7,
        height: boxGet.read(getDevice) == getIphone ? width / 7 : width / 7 * 0.7,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.withAlpha((255 * 0.2).toInt())),
            bottom: BorderSide(color: Colors.grey.withAlpha((255 * 0.2).toInt())),
            left: BorderSide(color: Colors.grey.withAlpha((255 * 0.2).toInt()), width: hasOverflow ? 0 : 1),
            right: BorderSide(color: Colors.grey.withAlpha((255 * 0.2).toInt()), width: hasOverflow ? 0 : 1),
          ),
          color: AppTheme.isDark
              ? isToday
                    ? Colors.white54
                    : AppColors.darkBackground
              : isToday
              ? Colors.grey.withAlpha((255 * 0.3).toInt())
              : Colors.white54,
        ),
        child: Stack(
          children: [
            // Events display - using GetBuilder instead of Obx
            GetBuilder<CalendarController>(
              builder: (controller) {
                // Filtrer les duties qui chevauchent ce jour
                final dayStart = DateTime(date.year, date.month, date.day, 0, 0);
                final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

                List<MyDuty> myDutys = DatabaseController.instance.duties
                    .where((e) => e.endTime.isAfter(dayStart) && e.startTime.isBefore(dayEnd))
                    .toList();
                myDutys.sort((a, b) => a.startTime.compareTo(b.startTime));
                return Positioned.fill(child: Stack(children: _buildMyDutyWidgets(myDutys)));
              },
            ),
            // Date indicator
            Positioned(
              top: boxGet.read(getDevice) == getIphone ? AppTheme.h(x: 2) : AppTheme.h(x: 5),
              left: boxGet.read(getDevice) == getIphone ? AppTheme.w(x: 2) : AppTheme.w(x: 5),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday ? Colors.blue : Colors.transparent,
                ),
                //padding: const EdgeInsets.all(4.0),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: !isCurrentMonth
                        ? AppTheme.isDark
                              ? Colors.grey.withAlpha((255 * 0.5).toInt())
                              : Colors.grey.withAlpha((255 * 0.9).toInt())
                        : isToday
                        ? Colors.white
                        : AppTheme.isDark
                        ? Colors.white
                        : Colors.black87,
                    fontSize: boxGet.read(getDevice) == getIphone ? AppTheme.s(x: 9) : AppTheme.s(x: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Convertit la couleur depuis Typ.color vers Flutter Color
  Color _getColorFromTyp(MyDuty myDuty) {
    final colorString = myDuty.typ.target?.color;
    if (colorString == null || colorString.isEmpty) return Colors.grey;

    switch (colorString.toLowerCase()) {
      case 'blue':
        return HexColor('#467db8');
      case 'pale-blue':
        return HexColor('#83c0e6');
      case 'green':
        return HexColor('#58992e');
      case 'purple':
        return HexColor('#a146b8');
      case 'deep-purple':
        return HexColor('#5b538b');
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      default:
        // Si c'est un code hex, essayer de le parser
        if (colorString.startsWith('#')) {
          try {
            return HexColor(colorString);
          } catch (e) {
            return Colors.grey;
          }
        }
        return Colors.grey;
    }
  }

  /// Calcule la position et largeur d'un MyDuty dans la cellule du jour
  /// Retourne un Map avec 'left' et 'width' en pixels
  Map<String, double> _calculateDutyPosition(MyDuty myDuty, double cellWidth) {
    // Début et fin du jour affiché
    final dayStart = DateTime(date.year, date.month, date.day, 0, 0);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

    // Heures de début et fin du duty (clampées au jour)
    DateTime effectiveStart = myDuty.startTime.isBefore(dayStart) ? dayStart : myDuty.startTime;
    DateTime effectiveEnd = myDuty.endTime.isAfter(dayEnd) ? dayEnd : myDuty.endTime;

    // Si le duty n'est pas dans ce jour, retourner des valeurs nulles
    if (effectiveEnd.isBefore(dayStart) || effectiveStart.isAfter(dayEnd)) {
      return {'left': 0.0, 'width': 0.0};
    }

    // Utiliser des minutes pour éviter les petits espaces, avec clamp 0..1440
    const totalMinutesInDay = 24 * 60;
    double startMinutes = effectiveStart.difference(dayStart).inMinutes.toDouble();
    double endMinutes = effectiveEnd.difference(dayStart).inMinutes.toDouble();

    // Si le duty dépasse la fin du jour, étendre jusqu'à 1440
    if (myDuty.endTime.isAfter(dayEnd) || effectiveEnd.isAtSameMomentAs(dayEnd)) {
      // endMinutes = totalMinutesInDay.toDouble();
    }
    // Clamp
    startMinutes = startMinutes.clamp(0.0, totalMinutesInDay.toDouble());
    endMinutes = endMinutes.clamp(0.0, totalMinutesInDay.toDouble());

    // Calculer la position et largeur proportionnelles
    final left = (startMinutes / totalMinutesInDay) * cellWidth;
    final dutyWidth = ((endMinutes - startMinutes) / totalMinutesInDay) * cellWidth;

    return {'left': left, 'width': dutyWidth};
  }

  /// Nouvelle méthode pour afficher les MyDuty avec positionnement proportionnel
  List<Widget> _buildMyDutyWidgets(List<MyDuty> myDutys) {
    final cellWidth = width / 7;
    final List<Widget> eventWidgets = [];
    final double eventHeight = boxGet.read(getDevice) == getIphone ? AppTheme.h(x: 5) : AppTheme.h(x: 8);

    // Les duties sont déjà filtrées dans le GetBuilder, pas besoin de re-filtrer
    for (int i = 0; i < myDutys.length; i++) {
      final myDuty = myDutys[i];

      // Obtenir la couleur depuis Typ
      final myColor = _getColorFromTyp(myDuty);

      // Calculer la position et largeur proportionnelles
      final position = _calculateDutyPosition(myDuty, cellWidth);
      final dutyLeft = position['left']!;
      final dutyWidth = position['width']!;

      // Si la largeur est nulle, ne pas afficher
      if (dutyWidth <= 0) continue;

      // Calculer la position verticale (empiler si plusieurs duties)
      final bottomPosition = 5.0;

      eventWidgets.add(
        Positioned(
          left: dutyLeft,
          bottom: bottomPosition,
          child: Container(
            width: dutyWidth,
            height: eventHeight,
            decoration: BoxDecoration(
              color: myColor.withValues(alpha: 0.8),
              // borderRadius: BorderRadius.circular(3.0),
              // border: Border.all(color: myColor, width: 1.0),
            ),
            child: SizedBox(),
          ),
        ),
      );
    }
    return eventWidgets;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day && date.month == now.month && date.year == now.year;
  }
}
