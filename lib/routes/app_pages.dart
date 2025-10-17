import 'package:get/get.dart';

import '../controllers/allbinding.dart';
import '../views/0_acceuil/acceuil_screen.dart';
import '../views/1_register/register_screen.dart';
import '../views/2_webview/webview_screen.dart';
import '../views/3_Home/iphone_homepage.dart';
import '../views/7_cruds/aeroports_crud/aeroport_screen.dart';
import '../views/7_cruds/forfait_crud/forfait_screen.dart';

import 'app_routes.dart';

class AppPages {
  static const registerScreen = '/RegisterScreen';
  static final pages = [
    // Authentication
    GetPage(name: Routes.acceuil, page: () => const AcceuilScreen(), binding: AllControllerBinding()),
    GetPage(name: Routes.register, page: () => RegisterScreen(), binding: AllControllerBinding()),
    GetPage(name: Routes.webview, page: () => Webviewscreen(), binding: AllControllerBinding()),
    GetPage(name: Routes.homeIphonescreen, page: () => HomeIphoneScreen(), binding: AllControllerBinding()),
    GetPage(name: Routes.aeroportscreen, page: () => AeroportScreen(), binding: AllControllerBinding()),
    GetPage(name: Routes.forfaitScreen, page: () => ForfaitScreen(), binding: AllControllerBinding()),
  ];
}
