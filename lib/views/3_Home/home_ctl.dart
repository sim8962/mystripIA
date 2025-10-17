import 'package:get/get.dart';

import '../../Models/ActsModels/myduty.dart';
import '../../Models/ActsModels/typ_const.dart';
import '../../controllers/database_controller.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  // Reactive index and refresh properties.
  final RxInt _iphonePageIndex = 0.obs;
  int get iphonePageIndex => _iphonePageIndex.value;
  set iphonePageIndex(int value) => _iphonePageIndex.value = value;
  final RxBool _shouldRefreshPage = false.obs;
  bool get shouldRefreshPage => _shouldRefreshPage.value;
  set shouldRefreshPage(bool value) => _shouldRefreshPage.value = value;

  //------------------------- Next Duty ---------------------------

  final RxList<String> _sEtapes = <String>[].obs;
  List<String> get sEtapes => _sEtapes;
  set sEtapes(List<String> value) => _sEtapes.value = value;

  int _day = 0;
  set day(int value) => _day = value;
  // Cache the `getNextDutys` to avoid unneeded re-calculation.
  MyDuty get myNextDuty => _getNextDuty();

  /// Retrieves the next duty from the available list of duties based on the current time.
  MyDuty _getNextDuty() {
    final currentDate = DateTime.now().subtract(Duration(hours: _day));

    final index = DatabaseController.instance.duties.indexWhere(
      (duty) => duty.endTime.compareTo(currentDate) >= 0,
    );

    return DatabaseController.instance.duties[index == -1
        ? DatabaseController.instance.duties.length - 1
        : index];
  }

  // Generates a list containing details about the next upcoming activity
  //  The list contains two values: the first one represents the upcoming activity and
  //  the second one the remaining time of that activity

  List<String> getNextDutyText() {
    String sDuration = '';
    String sRoute = '';
    //print('ici1');
    final currentDate = DateTime.now().subtract(Duration(hours: _day));
    final duty = _getNextDuty();
    //print('ici2');
    final isBetween = (!currentDate.isBefore(duty.startTime) && !currentDate.isAfter(duty.endTime));
    // print('ici3');
    if (isBetween) {
      // print('ici4');
      if (duty.etapes.isNotEmpty) {
        final etaIndex = duty.etapes.indexWhere(
          (etape) =>
              (etape.startTime.compareTo(currentDate) >= 0) &&
              etape.typ.target != tHTL &&
              etape.typ.target != tTsv,
        );

        if (etaIndex != -1) {
          final remainingHours = duty.etapes[etaIndex].startTime.difference(currentDate.toUtc()).inHours;
          sDuration = 'Dans ${remainingHours}H';
          sRoute = duty.etapes[etaIndex].typeLabel;
        } else {
          sDuration = 'Dans ${duty.endTime.difference(currentDate.toUtc()).inHours}H';
        }
      } else {
        sDuration = 'Dans ${duty.endTime.difference(currentDate.toUtc()).inHours}H';
      }
    } else {
      // print('ici5');
      sDuration = 'Dans ${duty.startTime.difference(currentDate.toUtc()).inHours}H';

      // sRoute = duty.etapes
      //     .where((element) => element.volTraite.target != null)
      //     .map((e) => e.volTraite.target!)
      //     .map((e) => e.arrIATA)
      //     .join('-');
      //print(duty.etapes.length);
      // if (sRoute.isNotEmpty && duty.etapes.length > 1) {
      //   sRoute = '${duty.etapes[1].volTraite.target!.depIATA}-$sRoute';
      // }
    }
    //print('ici6:${[sRoute, sDuration]}');
    return [sRoute, sDuration];
  }

  List<String> get getMyNextDutyText => getNextDutyText();
}
