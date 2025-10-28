import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../Models/ActsModels/myduty.dart';
import '../../../../controllers/database_controller.dart';
import '../../../../helpers/constants.dart';
import '../../../../routes/app_routes.dart';
import '../../../../theming/app_color.dart';
import '../../../../theming/app_theme.dart';
import '../../../../theming/apptheme_constant.dart';
import '../../../widgets/Cardes/carde_dutys.dart';
import '../../../widgets/calendar_day_widget.dart';
import '../../../widgets/mybutton.dart';
import '../../../widgets/mydialogue.dart';
import 'calendar_controller.dart';

class MyCalenderScreen extends GetView<CalendarController> {
  const MyCalenderScreen({super.key});
  // final CalendarController controller = Get.put(CalendarController());
  //CalendarController.instance.selectedDuty.value = date;

  @override
  Widget build(BuildContext context) {
    final width = (AppTheme.myWidth - AppTheme.w(x: 30));
    return GetBuilder<CalendarController>(
      initState: (_) async {
        // print("initState");
        CalendarController.instance.initDate();
      },
      builder: (_) {
        return SizedBox(
          //padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          width: width + 100,
          //margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                        width: AppTheme.getWidth(iphoneSize: 280, ipadsize: 180),
                        label: 'button_to_calendar'.tr,
                        func: () async {
                          MyDialogue.dialogue(
                            title: 'dialog_export_calendar'.tr,
                            action1: 'button_export'.tr,
                            smiddleText: '',
                            func: () {
                              Routes.toCalenderScreen();
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      _buildMonthHeader(width: width),
                      _buildWeekdaysHeader(width: width),
                      Obx(() => _buildCalendarDays(width: width)),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                if (boxGet.read(getDevice) == getIphone)
                  Obx(() => _buildDutyCard(CalendarController.instance.selectedDuty.value)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthHeader({required double width}) {
    return Container(
      width: width,
      height: 60,
      padding: EdgeInsets.all(AppTheme.r(x: 10)),
      decoration: BoxDecoration(
        color: AppTheme.fonfColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.isDark != true ? AppColors.primaryLightColor : AppColors.errorColor,
            blurRadius: AppTheme.r(x: 22),
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
              size: AppTheme.s(x: 25),
            ),
            onPressed: () => controller.previousMonth(),
          ),
          Obx(
            () => Expanded(
              child: Center(
                child: Text(
                  "${controller.getMonthName(controller.currentMonth.value)} ${controller.currentYear.value}",
                  style: AppStylingConstant.textWidgetStyle.copyWith(fontSize: 18),
                  // style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            ),
            onPressed: () => controller.nextMonth(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdaysHeader({required double width}) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    String dayName = DateFormat('E').format(DateTime.now());
    return SizedBox(
      height: 60,

      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: weekdays
            .map(
              (day) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withAlpha((255 * 0.2).toInt())),
                  color: AppTheme.isDark ? AppColors.darkBackground : Colors.white,
                ),
                // width: ((MediaQuery.of(Get.context!).size.width - 20) / 7),
                width: width / 7,
                height: 60,
                child: Center(
                  child: Text(
                    dayName == day ? day.toUpperCase() : day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.isDark
                          ? dayName == day
                                ? AppColors.colorWhite
                                : AppColors.errorColor
                          : dayName == day
                          ? AppColors.errorColor
                          : Colors.black87,
                      fontSize: AppTheme.s(x: 14),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCalendarDays({required double width}) {
    final daysInMonth = controller.getDaysInMonth(
      controller.currentMonth.value,
      controller.currentYear.value,
    );

    final firstDayOfMonth = controller.getFirstDayOfMonth(
      controller.currentMonth.value,
      controller.currentYear.value,
    );

    // Calculate previous month's days to show
    final previousMonthYear = controller.currentMonth.value == 1
        ? controller.currentYear.value - 1
        : controller.currentYear.value;
    final previousMonth = controller.currentMonth.value == 1 ? 12 : controller.currentMonth.value - 1;
    final daysInPreviousMonth = controller.getDaysInMonth(previousMonth, previousMonthYear);

    // Days from previous month
    List<Widget> calendarCells = List.generate(
      firstDayOfMonth,
      (index) => CalendarDayWidget(
        width: width,
        date: DateTime(previousMonthYear, previousMonth, daysInPreviousMonth - firstDayOfMonth + index + 1),
        isCurrentMonth: false,
        controller: controller,
      ),
    );

    // Days from current month
    calendarCells.addAll(
      List.generate(daysInMonth, (index) {
        // DateTime dt = DateTime(controller.currentYear.value, controller.currentMonth.value, index + 1);
        return CalendarDayWidget(
          width: width,
          date: DateTime(controller.currentYear.value, controller.currentMonth.value, index + 1),
          isCurrentMonth: true,
          controller: controller,
        );
      }),
    );

    // Calculate how many days we need from next month
    final int totalCellsNeeded = (firstDayOfMonth + daysInMonth) > 35 ? 42 : 35;
    final nextMonthDaysCount = totalCellsNeeded - firstDayOfMonth - daysInMonth;

    // Days from next month
    final nextMonthYear = controller.currentMonth.value == 12
        ? controller.currentYear.value + 1
        : controller.currentYear.value;
    final nextMonth = controller.currentMonth.value == 12 ? 1 : controller.currentMonth.value + 1;

    calendarCells.addAll(
      List.generate(
        nextMonthDaysCount,
        (index) => CalendarDayWidget(
          width: width,
          date: DateTime(nextMonthYear, nextMonth, index + 1),
          isCurrentMonth: false,
          controller: controller,
        ),
      ),
    );

    // Build wrap widget with all days
    return Wrap(children: calendarCells);
  }

  Widget _buildDutyCard(DateTime date) {
    DateTime dtDebut = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime dtFin = DateTime(date.year, date.month, date.day, 23, 0, 0);
    int p = DatabaseController.instance.duties.indexWhere(
      (duty) => duty.endTime.isAfter(dtDebut) && duty.startTime.isBefore(dtFin),
    );
    if (p != -1) {
      MyDuty myDuty = DatabaseController.instance.duties[p];
      return CardDutys(duty: myDuty);
    } else {
      return SizedBox();
    }
  }
}
