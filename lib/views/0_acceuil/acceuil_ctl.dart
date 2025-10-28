import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../helpers/constants.dart';
import '../../helpers/myerrorinfo.dart';
import '../../Models/jsonModels/datas/airport_model.dart';
import '../../Models/jsonModels/datas/forfait_model.dart';
import '../../routes/app_routes.dart';
import '../../controllers/database_controller.dart';

class AcceuilController extends GetxController {
  static AcceuilController get instance => Get.find();

  final Rx<bool> _isVisibleAcceuil = false.obs;
  bool get isVisibleAcceuil => _isVisibleAcceuil.value;
  set isVisibleAcceuil(bool st) {
    _isVisibleAcceuil.value = st;
  }

  void getMyIdevice() {
    final context = Get.context!;
    String isDevice = context.isLargeTablet ? getIpad : getIphone;
    boxGet.remove(getDevice);
    boxGet.write(getDevice, isDevice);
  }

  /// Enhanced user check and navigation with MyDownLoad loading
  void checkUsersAndNavigate() {
    try {
      Timer(const Duration(milliseconds: 15), () {
        isVisibleAcceuil = true;
      });

      // Defer navigation until after build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performNavigation();
      });
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'RoutingController._checkUsersAndNavigate',
        content: 'Error during user check: $e',
      );
      // Fallback to register screen on error - also deferred
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Routes.register;
      });
    }
  }

  /// Perform navigation logic after build is complete
  void _performNavigation() async {
    try {
      final dbController = DatabaseController.instance;
      dbController.getAllDatas();
      // dbController.clearAllData();
      // Check if airports box is empty and load from JSON if needed

      await AeroportModel.fillAirportModelsIfEmpty();
      // Check if forfaits box is empty and load from JSON if needed
      await ForfaitModel.fillForfaitModelBoxIfEmpty();

      if (dbController.users.isEmpty) {
        // No users found, navigate to register screen
        Routes.toRegister();
      } else if (dbController.currentUser != null) {
        if (dbController.duties.isEmpty) {
          Routes.toWebview();
        } else {
          // Routes.toHome();
          Routes.toImportRosterScreen();
          // Routes.toHomePage();
        }
      } else {
        // Users exist but no current user set, go to register
        Routes.toRegister();
        // print('Routes.toRegister() 1');
      }
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'RoutingController._performNavigation',
        content: 'Error during navigation: $e',
      );

      Routes.toRegister();
    }
  }

  /// Load airports from JSON asset if the airports box is empty
}
