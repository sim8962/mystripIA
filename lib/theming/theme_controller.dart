import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_color.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find<ThemeController>();

  final GetStorage _storage = GetStorage();
  final String _themeKey = 'theme_mode';

  // Observable theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // Observable for current theme brightness
  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
    _updateThemeBasedOnSystem();

    // Listen to system theme changes
    ever(_themeMode, (_) => _updateThemeBasedOnSystem());
  }

  @override
  void onReady() {
    super.onReady();
    // Apply theme after the app is fully initialized
    _updateThemeBasedOnSystem();
  }

  /// Load saved theme preference from storage
  void _loadThemeFromStorage() {
    final savedTheme = _storage.read(_themeKey);
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          _themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          _themeMode.value = ThemeMode.dark;
          break;
        default:
          _themeMode.value = ThemeMode.system;
      }
    }
  }

  /// Save theme preference to storage
  void _saveThemeToStorage() {
    String themeString;
    switch (_themeMode.value) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    _storage.write(_themeKey, themeString);
  }

  /// Update the current theme based on system or manual selection
  void _updateThemeBasedOnSystem() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        _isDarkMode.value = false;
        break;
      case ThemeMode.dark:
        _isDarkMode.value = true;
        break;
      case ThemeMode.system:
        _isDarkMode.value = Get.isPlatformDarkMode;
        break;
    }

    // Update GetX theme with proper themes
    Get.changeTheme(lightTheme);
    Get.changeTheme(darkTheme);
    Get.changeThemeMode(_themeMode.value);

    // Update system UI overlay style
    _updateSystemUIOverlay();
    
    // Trigger UI update
    update();
  }

  /// Update system UI overlay style based on current theme
  void _updateSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkMode.value ? Brightness.light : Brightness.dark,
        statusBarBrightness: _isDarkMode.value ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: _isDarkMode.value ? AppColors.darkBackground : AppColors.lightBackground,
        systemNavigationBarIconBrightness: _isDarkMode.value ? Brightness.light : Brightness.dark,
      ),
    );
  }

  /// Switch to light theme
  void setLightTheme() {
    _themeMode.value = ThemeMode.light;
    _saveThemeToStorage();
    _updateThemeBasedOnSystem();
  }

  /// Switch to dark theme
  void setDarkTheme() {
    _themeMode.value = ThemeMode.dark;
    _saveThemeToStorage();
    _updateThemeBasedOnSystem();
  }

  /// Switch to system theme (automatic)
  void setSystemTheme() {
    _themeMode.value = ThemeMode.system;
    _saveThemeToStorage();
    _updateThemeBasedOnSystem();
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.system) {
      // If currently on system, switch to opposite of current system theme
      if (Get.isPlatformDarkMode) {
        setLightTheme();
      } else {
        setDarkTheme();
      }
    } else if (_themeMode.value == ThemeMode.light) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }

  /// Get light theme data
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.colorSchemelight,
    fontFamily: latoFontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.colorblack87),
      titleTextStyle: TextStyle(
        color: AppColors.colorblack87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: latoFontFamily,
      ),
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
  );

  /// Get dark theme data
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.colorSchemeDark,
    fontFamily: latoFontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.colorWhite),
      titleTextStyle: TextStyle(
        color: AppColors.colorWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: latoFontFamily,
      ),
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
  );

  /// Get current theme name for display
  String get currentThemeName {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }
}
