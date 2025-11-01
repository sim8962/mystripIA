import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:mystrip25/Models/stringvols/svolmodel.dart';
import 'package:mystrip25/Models/stringvols/stringvolmois.dart';
import 'package:mystrip25/Models/volpdfs/vol_pdf_list.dart';

import '../../Models/VolsModels/vol.dart';
import '../../Models/volpdfs/vol_pdf.dart';
import '../../controllers/database_controller.dart';
import '../../helpers/constants.dart';

class CompareVolsController extends GetxController {
  static CompareVolsController get instance => Get.find();
  final RxInt displayMode = 0.obs; // 0: VolModel, 1: VolPdf, 2: StringVolModel
  final RxString selectedMonth = ''.obs;
  final RxList<String> availableMonths = <String>[].obs;
  final RxList<StringVolModel> stringVolModels = <StringVolModel>[].obs;
  final RxList<StringVolModelMois> stringVolMois = <StringVolModelMois>[].obs;

  // Filtered data lists by type
  final RxList<VolModel> filteredVolModels = <VolModel>[].obs;
  final RxList<VolPdf> filteredVolPdfs = <VolPdf>[].obs;
  final RxList<StringVolModel> filteredStringVolModels = <StringVolModel>[].obs;
  final RxList<StringVolModelMois> filteredStringVolMois = <StringVolModelMois>[].obs;
  final RxList<VolPdfList> filteredVolPdfLists = <VolPdfList>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  final RxList<VolModel> _volModels = DatabaseController.instance.volModels.obs;
  List<VolModel> get volModels => _volModels;
  set volModels(List<VolModel> val) {
    _volModels.value = val;
  }

  final RxList<VolPdf> _volPdfs = DatabaseController.instance.volPdfs.obs;
  List<VolPdf> get volPdfs => _volPdfs;
  set volPdfs(List<VolPdf> val) {
    _volPdfs.value = val;
  }

  final RxList<StringVolModel> _allStringVols = <StringVolModel>[].obs;
  List<StringVolModel> get allStringVols => _allStringVols;
  set allStringVols(List<StringVolModel> val) {
    _allStringVols.value = val;
  }

  /// Initialize all data: fill volModels, create StringVolModels, extract months
  Future<void> _initializeData() async {
    // 1. Fill volModels from volPdfs if empty
    _fillVolModelsFromVolPdfs();

    // 2. Create StringVolModel list from completed volModels
    _createStringVolModels();

    // 3. Extract available months
    final months = _getMontList();
    availableMonths.assignAll(months);
    if (months.isNotEmpty && selectedMonth.value.isEmpty) {
      selectedMonth.value = months.first;
      fillFilteredData();
    }
  }

  /// Fill volModels from volPdfs if volModels is empty
  /// Converts VolPdf to VolModel using factory
  void _fillVolModelsFromVolPdfs() {
    if (volModels.isEmpty) return;
    if (volPdfs.isEmpty) return;
    volModels.sort((a, b) => a.dtDebut.compareTo(b.dtDebut));
    volPdfs.sort((a, b) => a.dateVol.compareTo(b.dateVol));

    List<DateTime> moisvolModels = volModels
        .map((vol) => DateTime(vol.dtDebut.year, vol.dtDebut.month, 1))
        .toSet()
        .toList();
    List<DateTime> moisvolPdfs = volPdfs
        .map((vol) => DateTime(vol.dateVol.year, vol.dateVol.month, 1))
        .toSet()
        .toList();
    for (var mois in moisvolPdfs) {
      if (!moisvolModels.contains(mois)) {
        final convertedVolModels = volPdfs
            .where((volPdf) => volPdf.dateVol.month == mois.month && volPdf.dateVol.year == mois.year)
            .toList();
        for (var volPdf in convertedVolModels) {
          try {
            final volModel = VolModel.fromVolPdf(volPdf);
            volModels.add(volModel);
          } catch (e) {
            // Skip individual conversion errors
            continue;
          }
        }

        moisvolModels.add(mois);
      }
    }

    volModels.sort((a, b) => a.dtDebut.compareTo(b.dtDebut));
  }

  /// Create StringVolModel list from completed volModels
  /// Groups by month and calculates cumulative values
  void _createStringVolModels() {
    if (volModels.isEmpty) {
      stringVolModels.clear();
      stringVolMois.clear();
      return;
    }

    try {
      // Group volModels by month
      final volsByMonth = <String, List<VolModel>>{};
      for (var vol in volModels) {
        final monthKey = _getMonthKey(vol.dtDebut);
        volsByMonth.putIfAbsent(monthKey, () => []).add(vol);
      }

      // Create StringVolModel with cumuls for each vol
      for (var vol in volModels) {
        final monthKey = _getMonthKey(vol.dtDebut);
        final volsInMonth = volsByMonth[monthKey] ?? [];

        try {
          final stringVol = StringVolModel.withMonthlyCumuls(vol, volsInMonth);
          allStringVols.add(stringVol);
        } catch (e) {
          // Skip individual conversion errors
          continue;
        }
      }

      // Update reactive list
      stringVolModels.assignAll(allStringVols);
      // Build monthly summaries from StringVolModel
      try {
        final months = StringVolModelMois.fromStringVols(stringVolModels);
        stringVolMois.assignAll(months);
      } catch (e) {
        stringVolMois.clear();
      }
    } catch (e) {
      // Error handling for batch creation
      stringVolModels.clear();
      stringVolMois.clear();
    }
  }

  /// Get month key in format YYYY-MM
  String _getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  /// Get month display name (e.g., "October 2025")
  String getMonthDisplayName(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length != 2) return monthKey;
    final year = int.tryParse(parts[0]) ?? 0;
    final month = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) return monthKey;
    final date = DateTime(year, month);

    return DateFormat('MMMM yyyy').format(date);
  }

  List<String> _getMontList() {
    List<String> months = volModels.map((vol) => _getMonthKey(vol.dtDebut)).toSet().toList();
    months.sort((a, b) => b.compareTo(a)); // Sort descending (newest first)
    return months;
  }

  void fillFilteredData() {
    //  if (displayMode.value == 0) {
    // Filter VolModel for selected month
    filteredVolModels.assignAll(
      volModels.where((vol) => _getMonthKey(vol.dtDebut) == selectedMonth.value).toList(),
    );
    //print('filteredVolModels: ${filteredVolModels.length}');
    // } else if (displayMode.value == 1) {
    // Filter VolPdf for selected month
    filteredVolPdfs.assignAll(
      volPdfs.where((volPdf) => _getMonthKey(volPdf.dateVol) == selectedMonth.value).toList(),
    );
    //} else {
    // Filter StringVolModel for selected month (already calculated with cumuls)
    filteredStringVolModels.assignAll(
      stringVolModels.where((stringVol) {
        try {
          final date = dateFormatDDHH.tryParse(stringVol.sDebut);
          if (date == null) return false;
          return _getMonthKey(date) == selectedMonth.value;
        } catch (e) {
          return false;
        }
      }).toList(),
    );

    // Filter StringVolModelMois for selected month (match by moisReference)
    filteredStringVolMois.assignAll(
      stringVolMois.where((m) => m.moisReference == selectedMonth.value).toList(),
    );
    filteredVolPdfLists.assignAll(
      DatabaseController.instance.volPdfLists
          .where((m) => _getMonthKey(m.month) == selectedMonth.value)
          .toList(),
    );
  }
}
