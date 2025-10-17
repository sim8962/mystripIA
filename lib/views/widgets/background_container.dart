import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../theming/app_theme.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final FloatingActionButton? isButton;

  const BackgroundContainer({super.key, required this.child, this.isButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: AppTheme.myHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppTheme.isDark == true ? urlNuitback : urlDayback),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: child),
      ),
      floatingActionButton: isButton,
    );
  }
}
