import 'package:flutter/material.dart';

import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({this.width, this.height, this.size, required this.label, required this.func, super.key});
  final String label;
  double? width;
  double? height;
  double? size;
  //int? btn;
  final void Function()? func;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 10), vertical: AppTheme.h(x: 10)),
      decoration: AppTheme.buttonBoxDecoration(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
        ),
        onPressed: func,
        child: Text(label, style: AppStylingConstant.buttonTextStyle),
      ),
    );
  }
}
