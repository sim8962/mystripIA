import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/constants.dart';
import '../../theming/app_theme.dart';
import '../widgets/background_container.dart';
import 'acceuil_ctl.dart';

//COMMENT Ecran d'accueil avec un timer affichage image .
class AcceuilScreen extends GetView<AcceuilController> {
  const AcceuilScreen({super.key});
  //COMMENT on Charge l'image acceuil et on decide de route selon DB .

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AcceuilController>(
      initState: (_) {
        // NOTE :Timer 20ms pour rendre visible
        if (boxGet.read(getDevice) == null) {
          AcceuilController.instance.getMyIdevice();
        }

        // NOTE :Timer 1s  pour lancer le routing selon DB.
        AcceuilController.instance.checkUsersAndNavigate();
      },
      builder: (_) {
        return BackgroundContainer(
          child: Obx(
            () => AnimatedOpacity(
              // NOTE : opacity image change de 0 a 1 pendant 20ms.
              opacity: AcceuilController.instance.isVisibleAcceuil ? 1.0 : 0,
              duration: const Duration(milliseconds: 1200),
              child: Center(
                child: Container(
                  // NOTE : dimension cadre image
                  height: AppTheme.getRadius(iphoneSize: 300, ipadsize: 500),
                  // boxGet.read(getDevice) == getIphone ? MyStyling.r(x: 300) : MyStyling.r(x: 500),
                  width: AppTheme.getRadius(iphoneSize: 300, ipadsize: 500),
                  //boxGet.read(getDevice) == getIphone ? MyStyling.r(x: 300) : MyStyling.r(x: 500),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(),
                        blurRadius: 2.0,
                        offset: const Offset(5.0, 3.0),
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(AppTheme.isDark == true ? urlImage1 : urlImage2),
                    radius: AppTheme.getRadius(iphoneSize: 190, ipadsize: 500),
                    // boxGet.read(getDevice) == getIphone ? MyStyling.r(x: 190) : MyStyling.r(x: 500),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
