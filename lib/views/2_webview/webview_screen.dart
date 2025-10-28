import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/myerrorinfo.dart';

import '../../routes/app_routes.dart';

import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';
import '../widgets/background_container.dart';
import '../widgets/mybutton.dart';
import 'webview_ctl.dart';

class Webviewscreen extends GetView<WebViewEcreenController> {
  const Webviewscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebViewEcreenController>(
      initState: (_) async {
        //
      },
      builder: (_) {
        return BackgroundContainer(
          // isButton: FloatingActionButton(
          //   onPressed: () {
          //     SettingsService.instance.showSettingsMenu(context);
          //   },
          //   backgroundColor: AppTheme.isDark ? AppColors.darkBackground : AppColors.primaryLightColor,
          //   child: Icon(Icons.settings, color: AppTheme.isDark ? AppColors.errorColor : Colors.white),
          // ),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getheight(iphoneSize: 10, ipadsize: 10)),
            child: Obx(
              () => controller.getConnexion
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [_buildWebViewContainer(), _buildButtonRow()],
                    )
                  : _buildStatusContainer(),
            ),
          ),
        );
      },
    );
  }

  /// Builds the main WebView container or status display
  Widget _buildWebViewContainer() {
    return SizedBox(
      height: AppTheme.getheight(iphoneSize: 580, ipadsize: 560),
      child: Obx(
        () => controller.visibleWeb
            ? WebViewWidget(controller: controller.webViewController)
            : _buildStatusContainer(),
      ),
    );
  }

  /// Builds the status container shown when WebView is not visible
  Widget _buildStatusContainer() {
    return Container(
      width: AppTheme.myWidth,
      decoration: BoxDecoration(
        color: AppTheme.isDark ? AppColors.darkBackground : AppColors.primaryLightColor,
        borderRadius: BorderRadius.all(Radius.circular(AppTheme.r(x: 6))),
        border: Border.all(
          width: AppTheme.w(x: 1),
          color: AppTheme.isDark ? AppColors.errorColor : Colors.white,
        ),
      ),
      child: Center(
        child: Text(controller.sEtape.tr, style: AppStylingConstant.webScreen, textAlign: TextAlign.center),
      ),
    );
  }

  /// Builds the row of action buttons
  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // _buildActionButtons(),
        Obx(() => controller.visibleenregistre ? _buildActionButtons() : _buildProgressWithRegisterButton()),
      ],
    );
  }

  /// Builds the action buttons shown when data is ready to be saved
  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildResetButton(),
        SizedBox(width: AppTheme.getWidth(iphoneSize: 10, ipadsize: 50)),
        _buildSaveButton(),
      ],
    );
  }

  /// Builds the reset button
  Widget _buildResetButton() {
    return MyButton(
      width: AppTheme.getWidth(iphoneSize: 100, ipadsize: 150),
      label: 'button_reset'.tr,
      func: () async {
        controller.webReset(mycontroller: controller.webViewController);
      },
    );
  }

  /// Builds the save button
  Widget _buildSaveButton() {
    return MyButton(
      width: AppTheme.getWidth(iphoneSize: 160, ipadsize: 250),
      label: 'button_save'.tr,
      func: () async {
        try {
          bool isDone = controller.enregistrerMjsonString();
          if (isDone) {
            Routes.toHome();
          }
        } catch (e) {
          MyErrorInfo.erreurInos(label: 'button_save'.tr, content: e.toString());
        }
      },
    );
  }

  /// Builds the progress indicator with register button
  Widget _buildProgressWithRegisterButton() {
    return Row(
      children: [
        const Center(child: CircularProgressIndicator(color: AppColors.primaryLightColor, strokeWidth: 7)),
        SizedBox(width: AppTheme.getWidth(iphoneSize: 10, ipadsize: 50)),
        MyButton(
          width: AppTheme.getWidth(iphoneSize: 160, ipadsize: 250),
          label: 'button_to_home'.tr,
          func: () async {
            Routes.toHome();
          },
        ),
      ],
    );
  }

  /// Navigate to the appropriate home page based on device type
  // void _navigateToHomePage() {
  //   boxGet.read(getDevice) == getIphone ? Routes.toHomeIphonePage() : Routes.toRegister();
  // }
}
