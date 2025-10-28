import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../theming/theme_controller.dart';

/// Service pour gérer les paramètres de l'application (langue et thème)
class SettingsService extends GetxService {
  static SettingsService get instance => Get.find<SettingsService>();

  final GetStorage _storage = GetStorage();
  final String _languageKey = 'app_language';

  // Observable pour la langue actuelle
  final Rx<Locale> _currentLocale = const Locale('fr', 'FR').obs;
  Locale get currentLocale => _currentLocale.value;

  @override
  void onInit() {
    super.onInit();
    _loadLanguageFromStorage();
  }

  /// Charger la langue sauvegardée depuis le storage
  void _loadLanguageFromStorage() {
    final savedLanguage = _storage.read(_languageKey);
    if (savedLanguage != null) {
      switch (savedLanguage) {
        case 'en_US':
          _currentLocale.value = const Locale('en', 'US');
          break;
        case 'fr_FR':
          _currentLocale.value = const Locale('fr', 'FR');
          break;
        default:
          _currentLocale.value = const Locale('fr', 'FR');
      }
      Get.updateLocale(_currentLocale.value);
    }
  }

  /// Sauvegarder la langue dans le storage
  void _saveLanguageToStorage(String languageCode) {
    _storage.write(_languageKey, languageCode);
  }

  /// Changer la langue en anglais
  void setEnglish() {
    _currentLocale.value = const Locale('en', 'US');
    _saveLanguageToStorage('en_US');
    Get.updateLocale(_currentLocale.value);
  }

  /// Changer la langue en français
  void setFrench() {
    _currentLocale.value = const Locale('fr', 'FR');
    _saveLanguageToStorage('fr_FR');
    Get.updateLocale(_currentLocale.value);
  }

  /// Basculer entre anglais et français
  void toggleLanguage() {
    if (_currentLocale.value.languageCode == 'fr') {
      setEnglish();
    } else {
      setFrench();
    }
    // Forcer le rebuild de l'UI
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.forceAppUpdate();
    });
  }

  /// Obtenir le nom de la langue actuelle
  String get currentLanguageName {
    return _currentLocale.value.languageCode == 'fr' ? 'Français' : 'English';
  }

  /// Obtenir le code de la langue actuelle
  String get currentLanguageCode {
    return _currentLocale.value.languageCode == 'fr' ? 'fr_FR' : 'en_US';
  }

  /// Basculer le thème (utilise le ThemeController existant)
  void toggleTheme() {
    if (Get.isRegistered<ThemeController>()) {
      ThemeController.instance.toggleTheme();
      // Forcer le rebuild de l'UI
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.forceAppUpdate();
      });
    }
  }

  /// Obtenir le nom du thème actuel
  String get currentThemeName {
    if (Get.isRegistered<ThemeController>()) {
      return ThemeController.instance.isDarkMode ? 'Dark' : 'Light';
    }
    return 'Light';
  }

  /// Afficher le menu des paramètres
  void showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GetBuilder<ThemeController>(
        builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Titre
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'settings_menu_title'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(height: 1),

            // Option Thème
            Obx(() => ListTile(
              leading: Icon(
                ThemeController.instance.isDarkMode 
                    ? Icons.dark_mode 
                    : Icons.light_mode,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('settings_theme_mode'.tr),
              subtitle: Text(currentThemeName),
              trailing: Switch(
                value: ThemeController.instance.isDarkMode,
                onChanged: (value) {
                  toggleTheme();
                },
              ),
              onTap: toggleTheme,
            )),

            const Divider(height: 1),

            // Option Langue
            Obx(() => ListTile(
              leading: Icon(
                Icons.language,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('settings_language'.tr),
              subtitle: Text(currentLanguageName),
              trailing: Switch(
                value: _currentLocale.value.languageCode == 'en',
                onChanged: (value) {
                  toggleLanguage();
                },
              ),
              onTap: toggleLanguage,
            )),

            const SizedBox(height: 16),
          ],
        ),
      ),
      ),
    );
  }
}
