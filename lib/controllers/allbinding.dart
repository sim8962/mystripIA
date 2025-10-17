import 'package:get/get.dart';

import '../helpers/myerrorinfo.dart';
import '../views/7_cruds/aeroports_crud/aeroport_controller.dart';
import '../views/7_cruds/forfait_crud/forfait_controller.dart';

import '../views/4_myDuties/duty_list_controller.dart';
import '../views/5_activities/vot_controller.dart';
import '../views/6_myDownloads/downloads_list_controller.dart';
import 'database_controller.dart';
import '../services/objectbox_service.dart';

import '../views/0_acceuil/acceuil_ctl.dart';
import '../views/1_register/register_ctl.dart';
import '../views/2_webview/webview_ctl.dart';
import '../views/3_Home/home_ctl.dart';

class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DatabaseController>()) {
      Get.put(DatabaseController(), permanent: true);
    }

    // Screen controllers
    if (!Get.isRegistered<AcceuilController>()) {
      Get.lazyPut<AcceuilController>(() => AcceuilController());
    }
    // Get.put(AcceuilController(), permanent: true);
    if (!Get.isRegistered<AerportService>()) {
      Get.lazyPut<AerportService>(() => AerportService());
    }
    if (!Get.isRegistered<ForfaitController>()) {
      Get.lazyPut<ForfaitController>(() => ForfaitController());
    }
    if (!Get.isRegistered<RegisterController>()) {
      Get.lazyPut<RegisterController>(() => RegisterController());
    }
    if (!Get.isRegistered<WebViewEcreenController>()) {
      Get.lazyPut<WebViewEcreenController>(() => WebViewEcreenController());
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    }
    if (!Get.isRegistered<DutyListController>()) {
      Get.lazyPut<DutyListController>(() => DutyListController(), fenix: true);
    }
    if (!Get.isRegistered<VolController>()) {
      Get.lazyPut<VolController>(() => VolController(), fenix: true);
    }
    if (!Get.isRegistered<DownloadsListController>()) {
      Get.lazyPut<DownloadsListController>(() => DownloadsListController(), fenix: true);
    }
  }

  static Future<void> myInitController() async {
    try {
      if (!Get.isRegistered<ObjectBoxService>()) {
        final service = await ObjectBoxService.initializeNewBoxes();
        Get.put<ObjectBoxService>(service, permanent: true);
      }
      return;
    } catch (e, stackTrace) {
      MyErrorInfo.erreurInos(
        label: 'myInitController',
        content: 'Error initializing controllers: $e \n stackTrace:${stackTrace.toString()}',
      );
      rethrow;
    }
  }
}
