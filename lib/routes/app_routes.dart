import 'package:get/get.dart';

import '../helpers/constants.dart';

abstract class Routes {
  // Authentication
  static const acceuil = '/acceuil';
  static const register = '/register';

  static const homeIphonescreen = '/homeIphoneScreen'; //HomePage
  static const homeIpadscreen = '/homeIpadScreen'; //HomePage
  static const webview = '/webview';

  static const aeroportscreen = '/AeroportScreen';
  static const forfaitScreen = '/ForfaitScreen';
  static const calenderScreen = '/CalenderScreen';
  static const importRosterScreen = '/ImportRosterScreen';

  // Individual screens (accessible through navigation)
  static const dutyListScreen = '/duty-list';
  static const downloadsListScreen = '/DownloadsListScreen';
  static const activitiesListScreen = '/activities';

  static void toAcceuil() => Get.offAllNamed(acceuil);
  static void toRegister() => Get.offAllNamed(register);
  static void toWebview() => Get.offAllNamed(webview);
  static void toDownloadsScreen() => Get.offAllNamed(downloadsListScreen);
  static void toForfaitScreen() => Get.offAllNamed(forfaitScreen);
  static void toAeroportscreen() => Get.offAllNamed(aeroportscreen);
  static void toCalenderScreen() => Get.offAllNamed(calenderScreen);
  static void toImportRosterScreen() => Get.offAllNamed(importRosterScreen);

  static void toHomeIphonePage() => Get.offAllNamed(homeIphonescreen);
  static void toHomeIpadPage() => Get.offAllNamed(homeIpadscreen);
  static void toHome() => boxGet.read(getDevice) == getIphone ? toHomeIphonePage() : toHomeIpadPage();

  static void back() => Get.back();
}
