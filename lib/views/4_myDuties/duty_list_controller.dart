import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../Models/ActsModels/myduty.dart';
import '../../controllers/database_controller.dart';

class DutyListController extends GetxController {
  static DutyListController get instance => Get.find();
  final DatabaseController dbController = Get.find<DatabaseController>();

  final RxBool isLoading = true.obs;

  final RxList<MyDuty> _duties = <MyDuty>[].obs;
  List<MyDuty> get duties => _duties;
  set duties(List<MyDuty> val) {
    _duties.value = val;
  }

  @override
  void onInit() {
    super.onInit();
    duties = DatabaseController.instance.duties;
    // _loadAndProcessDuties();
  }

  final myDutyScrollController = ItemScrollController();
  int get myDutyIndex => getIndexDutys();

  int getIndexDutys() {
    int myIndex = duties.indexWhere(
      (a) => ((a.startTime.compareTo(DateTime.now().add(Duration(days: 0))) >= 0)),
    );
    if (myIndex == -1) {
      myIndex = duties.length - 1;
    }
    return myIndex;
  }

  void jumpToDutys() {
    if (duties.isEmpty) return;

    // Use a shorter delay since we're now calling after frame callback
    Future.delayed(const Duration(milliseconds: 300), () {
      if (myDutyScrollController.isAttached) {
        myDutyScrollController.scrollTo(
          index: myDutyIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
