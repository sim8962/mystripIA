import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../Models/VolsModels/vol_traite.dart';

import '../../controllers/database_controller.dart';

class VolController extends GetxController {
  final DatabaseController _databaseController = DatabaseController.instance;

  // Reactive lists for UI updates
  final RxList<VolTraiteModel> volsTraites = <VolTraiteModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  // Filtered activities based on search
  List<VolTraiteModel> get filteredVolsTraites {
    final filtered = searchQuery.value.isEmpty
        ? volsTraites.toList()
        : volsTraites.where((volTraite) {
            final query = searchQuery.value.toLowerCase();
            return volTraite.depIata.toLowerCase().contains(query) ||
                volTraite.arrIata.toLowerCase().contains(query) ||
                volTraite.typ.toLowerCase().contains(query) ||
                volTraite.nVol.toLowerCase().contains(query);
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
    loadVolTransits();
  }

  /// Load all activities from database and process them
  void loadVolTransits() {
    try {
      isLoading.value = true;
      
      // Load all VolModel from database
      final allVolTransits = _databaseController.vols;

      // Update missing values for old data
      for (var volTransit in allVolTransits) {
        volTransit.updateMissingValues();
      }

      // Process all vols to create VolTraiteModel
      final volsTraitesList = <VolTraiteModel>[];
      for (var vol in allVolTransits) {
        final volTraite = VolTraiteModel.fromVolModel(vol, allVolTransits);
        volsTraitesList.add(volTraite);
      }

      volsTraitesList.sort((a, b) => b.dtDebut.compareTo(a.dtDebut));
      
      // Update local reactive list
      volsTraites.assignAll(volsTraitesList);
      
      // print('Loaded ${volsTraitesList.length} vols traités');
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
    loadVolTransits();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
  }

  /// Get formatted date string
  String getFormattedDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  /// Get formatted time string
  String getFormattedTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Get duration between start and end time
  String getDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h${minutes.toString().padLeft(2, '0')}';
  }

  // Les cumuls sont déjà calculés et stockés dans VolTraiteModel
  // Plus besoin de méthodes de calcul, on accède directement aux champs
}
