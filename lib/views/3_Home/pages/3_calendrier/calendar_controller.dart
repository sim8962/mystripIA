import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../controllers/database_controller.dart';

class CalendarController extends GetxController {
  static CalendarController instance = Get.find();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> selectedDuty = DateTime.now().obs;

  final RxInt currentMonth = DateTime.now().month.obs;
  final RxInt currentYear = DateTime.now().year.obs;

  // final RxList<MyEvent> myEvents = <MyEvent>[].obs;

  @override
  void onInit() {
    super.onInit();
    // myEvents.value = DataController.instance.myEvents;
    update();
    // Load events if needed or initialize with sample data
  }

  void initDate() {
    int p = DatabaseController.instance.duties.indexWhere((e) => !e.startTime.isBefore(DateTime.now()));

    if (p != -1) {
      // selectedDate.value = DataController.instance.myEvents[p].dateEvent;
      selectedDuty.value = DatabaseController.instance.duties[p].startTime;
      // print(selectedDuty.value);
    }
  }

  // Move to next month
  void nextMonth() {
    if (currentMonth.value == 12) {
      currentMonth.value = 1;
      currentYear.value++;
    } else {
      currentMonth.value++;
    }
    update();
  }

  // Move to previous month
  void previousMonth() {
    if (currentMonth.value == 1) {
      currentMonth.value = 12;
      currentYear.value--;
    } else {
      currentMonth.value--;
    }
    update();
  }

  // Get days in month
  int getDaysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  // Get first day of month (0 = Monday, 6 = Sunday in our UI)
  int getFirstDayOfMonth(int month, int year) {
    int weekdayIndex = DateTime(year, month, 1).weekday - 1; // 0 for Monday, 6 for Sunday
    return weekdayIndex;
  }

  // Get month name
  String getMonthName(int month) {
    return DateFormat('MMMM').format(DateTime(currentYear.value, month));
  }
}
