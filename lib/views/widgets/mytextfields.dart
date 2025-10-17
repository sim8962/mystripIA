// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';

class MyTextFields extends StatelessWidget {
  MyTextFields({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });
  final TextEditingController controller;
  IconData? prefixIcon;
  bool obscureText;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  final String labelText;

  final BorderRadius borderRadius = BorderRadius.circular(AppTheme.r(x: 10));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppStylingConstant.textFiel,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      //style: MyStyling.textFieldLarge,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppStylingConstant.labelStyle,
        hintStyle: AppStylingConstant.hintStyle,
        errorStyle: AppStylingConstant.errorStyle,
        prefixIcon: Icon(prefixIcon, color: AppTheme.isDark ? Colors.white : AppColors.primaryLightColor),
        filled: true,
        fillColor: AppTheme.isDark ? Colors.white.withAlpha(30) : Colors.white.withAlpha(100),
        border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: Colors.white38, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.red[200]!, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.red[700]!, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 24), vertical: AppTheme.h(x: 16)),
      ),
    );
  }
}
