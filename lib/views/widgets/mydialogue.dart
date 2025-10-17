import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';
import 'mybutton.dart';

class MyDialogue {
  static Future<dynamic> dialogue({
    required String title,
    required String action1,
    required Function func,
    required String smiddleText,
  }) {
    return Get.defaultDialog(
      title: title,
      middleText: smiddleText,
      titleStyle: AppStylingConstant.dialogueTitleStyle,
      middleTextStyle: AppStylingConstant.dialogueMiddleTextStyle,
      titlePadding: EdgeInsets.symmetric(vertical: AppTheme.s(x: 15), horizontal: AppTheme.s(x: 4)),
      backgroundColor: AppTheme.fonfColor, // const Color.fromARGB(255, 235, 244, 249),
      actions: [
        Column(
          children: [
            MyButton(
              label: action1,
              func: () {
                func();
              },
            ),
            SizedBox(height: AppTheme.r(x: 20)),
            MyButton(
              label: 'button_close'.tr,
              func: () {
                Get.back();
              },
            ),
          ],
        ),
      ],
      barrierDismissible: false,
      radius: AppTheme.r(x: 20),
    );
  }
}
