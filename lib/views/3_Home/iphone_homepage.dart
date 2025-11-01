import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';

import 'pages/1_myDuties/duty_list_screen.dart';
import 'pages/2_volsDetails/vol_screen.dart';
import 'pages/2_volsDetails/vot_controller.dart';

import '../widgets/background_container.dart';
import '../widgets/mydialogue.dart';
import 'home_ctl.dart';
import 'pages/4_setting/setting_page.dart';
import '../../services/settings_service.dart';
import 'pages/3_calendrier/calender_screen.dart';

class HomeIphoneScreen extends GetView<HomeController> {
  HomeIphoneScreen({super.key});
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<IconData> myIcons = [
    Icons.home_filled,
    Icons.list,
    Icons.calendar_month,
    Icons.download_rounded,
    Icons.file_copy,
    Icons.settings,
    //Icons.bar_chart_rounded,

    // Icons.list_alt,
  ];

  // Screens are created as getters to ensure fresh instances when navigating
  List<Widget> get screens => [const DutyListScreen(), VolScreen(), MyCalenderScreen(), const SettingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VolController.instance.loadVolTraites();
          SettingsService.instance.showSettingsMenu(context);
        },
        backgroundColor: AppTheme.isDark ? AppColors.darkBackground : AppColors.primaryLightColor,
        child: Icon(Icons.settings, color: AppTheme.isDark ? AppColors.errorColor : Colors.white),
      ),

      body: Obx(() {
        if (HomeController.instance.shouldRefreshPage) {
          return const SizedBox();
        }
        return BackgroundContainer(child: screens[HomeController.instance.iphonePageIndex]);
      }),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(
            color: AppTheme.isDark ? AppColors.darkBackground : AppColors.primaryLightColor,
          ),
        ),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: HomeController.instance.iphonePageIndex,
          height: AppTheme.h(x: 50),
          items: myIcons
              .map(
                (e) => Icon(
                  e,
                  size: AppTheme.s(x: 25),
                  color: AppTheme.isDark ? AppColors.errorColor : Colors.white,
                  semanticLabel: _getSemanticLabel(e),
                ),
              )
              .toList(),
          color: AppTheme.isDark ? AppColors.darkBackground : AppColors.primaryLightColor,
          // backgroundColor: MyStyling.isDark ? MyStyling.fondDark : MyStyling.myColor,
          backgroundColor: AppTheme.isDark
              ? const Color.fromARGB(150, 170, 59, 52)
              : Color.fromARGB(255, 160, 220, 240),

          buttonBackgroundColor: AppTheme.isDark ? AppColors.darkBackground : AppColors.primaryLightColor,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            _handleNavigationTap(index);
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }

  void _handleNavigationTap(int index) {
    switch (index) {
      case 0:
        //DutyListScreen()
        HomeController.instance.iphonePageIndex = 0;

        break;
      case 1:
        //VolScreen()
        HomeController.instance.iphonePageIndex = 1;
        break;
      case 2:
        // MyCalenderScreen()
        HomeController.instance.iphonePageIndex = 2;
        break;
      case 3:
        // DownloadsListScreen()
        MyDialogue.dialogue(
          title: 'dialog_download_strip'.tr,
          action1: 'button_download_strip'.tr,
          smiddleText: '',
          func: () {
            Routes.toWebview();
          },
        );
        break;

      case 4:
        Routes.toTableScreen();
        break;
      case 5:
        HomeController.instance.iphonePageIndex = 3;
        break;
      // case 6:
      //   HomeController.instance.iphonePageIndex = 5;
      //   break;
      // case 6:
      //   HomeController.instance.iphonePageIndex = 5;
      //   break;
      default:
        // Handle any other cases if necessary
        break;
    }
  }

  String _getSemanticLabel(IconData icon) {
    if (icon == Icons.library_books) {
      return 'semantic_library_books'.tr;
    } else if (icon == Icons.bar_chart_rounded) {
      return 'Statistiques mensuelles';
    } else if (icon == Icons.list) {
      return 'semantic_list'.tr;
    } else if (icon == Icons.upload_rounded) {
      return 'semantic_upload'.tr;
    } else if (icon == Icons.download_rounded) {
      return 'semantic_download'.tr;
    } else if (icon == Icons.file_copy) {
      return 'semantic_file_copy'.tr;
    } else {
      return 'semantic_icon'.tr;
    }
  }
}
