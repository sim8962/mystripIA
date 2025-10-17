import 'package:flutter/material.dart';

import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';

class MyTextWidget extends StatelessWidget {
  const MyTextWidget({required this.label, this.height, this.width, super.key});
  final String label;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(AppTheme.r(x: 10)),
      decoration: BoxDecoration(
        color: AppTheme.fonfColor,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.isDark != true ? AppColors.primaryLightColor : AppColors.errorColor,
            blurRadius: AppTheme.r(x: 22),
            offset: const Offset(5, 5),
          ),
        ],
      ),

      // color: const Color.fromARGB(255, 252, 251, 250),
      child: Center(
        child: Text(label, textAlign: TextAlign.center, style: AppStylingConstant.textWidgetStyle),
      ),
    );
  }
}
