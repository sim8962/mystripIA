import 'package:flutter/material.dart';

import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';
import '../1_register/register_ctl.dart';
import '../7_cruds/forfait_crud/forfait_controller.dart';

class MySwitch extends StatelessWidget {
  const MySwitch({
    super.key,
    required this.smalllabeltext,
    required this.labeltext,
    required this.ichoice,
    required this.width,
    required this.height,
  });
  final String smalllabeltext;
  final String labeltext;
  final int ichoice;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 1.0),
      width: width, //AppTheme.getWidth(iphoneSize: 160, ipadsize: 180),
      height: height, //AppTheme.getWidth(iphoneSize: 60, ipadsize: 60),
      //height: Theming.h(x: 60),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? Colors.white.withAlpha(40) : Colors.white.withAlpha(100),
        borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
      ),

      // width: 260,
      child: Center(
        child: SwitchListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          dense: true,
          title: Text(
            labeltext.toUpperCase(),
            style: (smalllabeltext.isNotEmpty)
                ? AppStylingConstant.switchStyleBig
                : AppStylingConstant.switchStyleSmall,
          ),

          subtitle: (smalllabeltext.isNotEmpty)
              ? Text(smalllabeltext.toUpperCase(), style: AppStylingConstant.switchStyleSmall)
              : null,
          activeThumbColor: AppColors.primaryLightColor,
          activeTrackColor: const Color.fromARGB(255, 194, 208, 224),
          inactiveThumbColor: AppColors.primaryLightColor,
          inactiveTrackColor: Colors.white,
          value: _getValue(),
          onChanged: (bool value) {
            _onChanged();
          },
        ),
      ),
    );
  }

  void _onChanged() {
    switch (ichoice) {
      case 1:
        RegisterController.instance.amsram = !RegisterController.instance.amsram;
        break;
      case 2:
        RegisterController.instance.secteur = !RegisterController.instance.secteur;
        break;
      case 3:
        ForfaitController.instance.saison = !ForfaitController.instance.saison;
        break;
      case 4:
        ForfaitController.instance.secteur = !ForfaitController.instance.secteur;
        break;
      case 5:
        RegisterController.instance.ispnt = !RegisterController.instance.ispnt;
        break;
      default:
    }
  }

  bool _getValue() {
    switch (ichoice) {
      case 1:
        return RegisterController.instance.amsram;
      case 2:
        return RegisterController.instance.secteur;
      case 3:
        return ForfaitController.instance.saison;
      case 4:
        return ForfaitController.instance.secteur;
      case 5:
        return RegisterController.instance.ispnt;

      default:
        return false;
    }
  }
}
