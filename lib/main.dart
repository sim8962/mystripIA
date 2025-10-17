import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'helpers/constants.dart';
import 'helpers/translations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'controllers/allbinding.dart';
 
import 'theming/app_theme.dart';

// In Terminal, run :sudo gem update --system.
// Still in Terminal, run : sudo gem install cocoapods.
// Finally run : pod install --repo-update.
// pod repo update
// flutter build ios
//dart run build_runner build --delete-conflicting-outputs
void main() async {
  try {
    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize GetStorage
    await GetStorage.init();
    

    // Initialize controllers after all core services are ready
    await AllControllerBinding.myInitController();
    await ScreenUtil.ensureScreenSize();

    // Set preferred orientations (portrait only for mobile)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'An error occurred',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                details.exception.toString(),
                style: const TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    };
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Fatal Error during app initialization: $e');
    debugPrint(stackTrace.toString());
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil to make the UI responsive
    final isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final Size designSize = isTablet
        ? const Size(deviceWidthIpad, deviceHeightIpad)
        : Size(deviceWidth, deviceHeight);
    isTablet ? boxGet.write(getDevice, getIpad) : boxGet.write(getDevice, getIphone);
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            //NOTE : on initie nos controlleurs et leur state.
            smartManagement: SmartManagement.full,
            initialBinding: AllControllerBinding(),
            theme: AppTheme.appLightTheme,
            darkTheme: AppTheme.appDarkTheme,
            themeMode: ThemeMode.system,
            translations: AppTranslations(),
            // Prefer device locale, fallback to French
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('fr', 'FR'),
            initialRoute: Routes.acceuil,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
