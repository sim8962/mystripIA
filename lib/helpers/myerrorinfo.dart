import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A utility class for displaying error information to the user.
///
/// This class provides a convenient way to show error messages in a standardized format.
/// It uses the Get package to display snackbars with customizable appearance and behavior.
class MyErrorInfo {
  /// Displays an error message as a snackbar.
  ///
  /// [label] is the title of the error message.
  /// [content] is the detailed error message.
  ///
  /// Returns a [SnackbarController] that can be used to control the snackbar.
  static SnackbarController erreurInos({required String label, required String content}) {
    //print("""label: $label, content: $content""");
    // print("======================================================");
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
