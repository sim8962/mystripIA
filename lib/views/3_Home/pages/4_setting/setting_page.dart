import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../theming/app_theme.dart';

import '../../../widgets/background_container.dart';
import '../../../widgets/mybutton.dart';

import '../../../widgets/mydialogue.dart';
import '../../../widgets/mytext.dart';
import '../../home_ctl.dart';

//COMMENT Ecran d'accueil avec un timer affichage image .
class SettingPage extends GetView<HomeController> {
  const SettingPage({super.key});
  //COMMENT on Charge l'image acceuil et on decide de route selon DB .
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (_) async {},
      builder: (_) {
        return BackgroundContainer(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //if (HomeController.instance.boolForfAerp)
            child: Column(
              children: [
                SizedBox(height: AppTheme.getheight(iphoneSize: 80, ipadsize: 80)),
                Padding(
                  padding: EdgeInsets.all(AppTheme.w(x: 10)),
                  child: MyTextWidget(label: 'settings_title'.tr),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButton(
                        label: 'menu_history'.tr,
                        func: () {
                          MyDialogue.dialogue(
                            title: 'Historique Telechargement',
                            action1: 'affiche',
                            smiddleText: '',
                            func: () {
                              Routes.toDownloadsScreen();
                            },
                          );
                        },

                        width: AppTheme.getWidth(iphoneSize: 280, ipadsize: 180),
                      ),
                      MyButton(
                        label: 'menu_airports'.tr,
                        func: () {
                          Routes.toAeroportscreen();
                        },

                        width: AppTheme.getWidth(iphoneSize: 280, ipadsize: 180),
                      ),
                      MyButton(
                        label: 'menu_forfaits'.tr,
                        func: () {
                          Routes.toForfaitScreen();
                        },

                        width: AppTheme.getWidth(iphoneSize: 280, ipadsize: 180),
                      ),
                      MyButton(
                        label: 'menu_import_strip'.tr,
                        func: () {
                          Routes.toImportRosterScreen();
                        },
                        width: AppTheme.getWidth(iphoneSize: 280, ipadsize: 180),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
