
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyErrorInfo {

  static SnackbarController erreurInos({required String label, required String content}) {
    return Get.snackbar(
      label,
      content,
      icon: const Icon(Icons.warning_amber, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 10),
      isDismissible: true,
      dismissDirection: DismissDirection.down,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
