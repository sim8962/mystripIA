import 'package:get/get.dart';

import '../helpers/myerrorinfo.dart';
import '../views/3_Home/pages/3_calendrier/calendar_controller.dart';
import '../views/5_cruds/aeroports_crud/aeroport_controller.dart';
import '../views/5_cruds/forfait_crud/forfait_controller.dart';

import '../views/3_Home/pages/1_myDuties/duty_list_controller.dart';
import '../views/3_Home/pages/2_volsDetails/vot_controller.dart';
import '../views/4_myDownloads/downloads_list_controller.dart';
import '../views/6_versCalender/calender_controller.dart';

import '../views/7_importRoster/importroster_ctl.dart';
import 'database_controller.dart';
import 'objectbox_service.dart';

import '../views/0_acceuil/acceuil_ctl.dart';
import '../views/1_register/register_ctl.dart';
import '../views/2_webview/webview_ctl.dart';
import '../views/3_Home/home_ctl.dart';
import '../services/settings_service.dart';
import '../theming/theme_controller.dart';

/// Binding pour l'injection de dépendances de tous les contrôleurs.
///
/// Enregistre tous les contrôleurs et services auprès du conteneur GetX.
/// Les services permanents sont chargés au démarrage, les autres sont chargés paresseusement.
class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    // =====================================================================
    // SECTION: SERVICES PERMANENTS
    // =====================================================================
    if (!Get.isRegistered<DatabaseController>()) {
      Get.put(DatabaseController(), permanent: true);
    }

    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
    }

    if (!Get.isRegistered<SettingsService>()) {
      Get.put(SettingsService(), permanent: true);
    }

    // =====================================================================
    // SECTION: CONTRÔLEURS D'ÉCRAN (Chargement paresseux)
    // =====================================================================

    if (!Get.isRegistered<AcceuilController>()) {
      Get.lazyPut<AcceuilController>(() => AcceuilController());
    }

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
    if (!Get.isRegistered<CalendarController>()) {
      Get.lazyPut<CalendarController>(() => CalendarController(), fenix: true);
    }
    if (!Get.isRegistered<VersCalenderCtl>()) {
      Get.lazyPut<VersCalenderCtl>(() => VersCalenderCtl(), fenix: true);
    }
    if (!Get.isRegistered<ImportrosterCtl>()) {
      Get.lazyPut<ImportrosterCtl>(() => ImportrosterCtl(), fenix: true);
    }
  }

  /// Initialise le service ObjectBox de manière asynchrone.
  ///
  /// Crée et enregistre une instance de [ObjectBoxService] dans le conteneur GetX.
  /// Gère les erreurs et réinitialise la base de données en cas de problème.
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
