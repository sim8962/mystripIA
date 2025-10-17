import 'package:flutter/material.dart';

import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';

class SelectedDate extends StatelessWidget {
  const SelectedDate({super.key, required this.func, required this.label});
  final String label;
  final VoidCallback? func;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.getheight(iphoneSize: 50, ipadsize: 50),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.isDark ? AppColors.errorColor : Colors.black87,
          style: BorderStyle.solid,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(child: Text(label, style: AppStylingConstant.datePickerLabelStyle)),
          ),
          IconButton(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            icon: const Icon(Icons.calendar_month),
            onPressed: func,
          ),
        ],
      ),
    );
  }
}
