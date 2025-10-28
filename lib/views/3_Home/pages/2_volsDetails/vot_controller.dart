import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../Models/VolsModels/vol_traite.dart';

import '../../../../controllers/database_controller.dart';

class VolController extends GetxController {
  static VolController get instance => Get.find();
  final DatabaseController _databaseController = DatabaseController.instance;

  // Reactive lists for UI updates
  final RxList<VolTraiteModel> volsTraites = <VolTraiteModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Filtered activities based on search
  List<VolTraiteModel> get filteredVolsTraites {
    final filtered = searchQuery.value.isEmpty
        ? volsTraites.toList()
        : volsTraites.where((volTraite) {
            final query = searchQuery.value.toLowerCase();

            // Recherche dans les champs de base
            if (volTraite.depIata.toLowerCase().contains(query) ||
                volTraite.arrIata.toLowerCase().contains(query) ||
                volTraite.typ.toLowerCase().contains(query) ||
                volTraite.nVol.toLowerCase().contains(query)) {
              return true;
            }

            // Recherche dans les crews (nom et crewId)
            try {
              final crewsList = volTraite.crewsList;
              for (var crew in crewsList) {
                final nom = crew['nom']?.toLowerCase() ?? '';
                final crewId = crew['crewId']?.toLowerCase() ?? '';
                if (nom.contains(query) || crewId.contains(query)) {
                  return true;
                }
              }
            } catch (e) {
              // Ignorer les erreurs de parsing
            }

            return false;
          }).toList();

    // Sort by datetime (oldest first)
    filtered.sort((a, b) => a.dtDebut.compareTo(b.dtDebut));
    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    // Set up reactive listener to database controller's vols
    // Note: We'll use a different approach since _volTransits is private
    loadVolTraites();
  }

  /// Load all activities from database and process them
  void loadVolTraites() {
    try {
      isLoading.value = true;

      // Charger directement les VolTraiteModel depuis DatabaseController
      // Ils sont déjà extraits et triés par getAllVolTraiteMois()
      final volsTraitesList = _databaseController.volTraiteModels.toList();

      // Update local reactive list
      volsTraites.assignAll(volsTraitesList);

      // print('🔍 VolController.loadVolTraites() - Loaded ${volsTraitesList.length} vols traités');
      // print('🔍 DatabaseController.volTraites.length = ${_databaseController.volTraites.length}');
      // print('🔍 DatabaseController.volTraiteMois.length = ${_databaseController.volTraiteMois.length}');
    } catch (e) {
      // print('Error loading activities: $e');
      // Defer snackbar to avoid build phase conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Erreur',
          'Impossible de charger les activités: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh activities data
  void refreshVolTransits() {
    loadVolTraites();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
  }

  // Les cumuls sont déjà calculés et stockés dans VolTraiteModel
  // Plus besoin de méthodes de calcul, on accède directement aux champs
}
