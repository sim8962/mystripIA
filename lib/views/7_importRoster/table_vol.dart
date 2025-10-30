import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mystrip25/Models/VolsModels/vol.dart';
import 'package:mystrip25/Models/VolsModels/svolmodel.dart';

import '../../Models/volpdfs/vol_pdf.dart';
import '../../controllers/database_controller.dart';
import '../../helpers/fct.dart';
import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../widgets/background_container.dart';

class TablescreenController extends GetxController {
  static TablescreenController get instance => Get.find();
  final RxInt displayMode = 0.obs; // 0: VolModel, 1: VolPdf, 2: StringVolModel
  final RxString selectedMonth = ''.obs;
  final RxList<String> availableMonths = <String>[].obs;
  final RxList<StringVolModel> stringVolModels = <StringVolModel>[].obs;

  // Filtered data lists by type
  final RxList<VolModel> filteredVolModels = <VolModel>[].obs;
  final RxList<VolPdf> filteredVolPdfs = <VolPdf>[].obs;
  final RxList<StringVolModel> filteredStringVolModels = <StringVolModel>[].obs;

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
    } catch (e) {
      // Error handling for batch creation
      stringVolModels.clear();
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
          final date = Fct.parseDateTimeFromString(stringVol.sDebut);
          return _getMonthKey(date) == selectedMonth.value;
        } catch (e) {
          return false;
        }
      }).toList(),
    );
  }
}

class Tablescreen extends GetView<TablescreenController> {
  const Tablescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TablescreenController>(
      init: TablescreenController(),
      builder: (tableController) {
        return _buildScreen(context, tableController);
      },
    );
  }

  Widget _buildScreen(BuildContext context, TablescreenController tableController) {
    return GetBuilder<TablescreenController>(
      initState: (_) async {
        // Load all data from database first
      },
      builder: (_) {
        return BackgroundContainer(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getheight(iphoneSize: 10, ipadsize: 10)),
            child: Obx(
              () => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 15, ipadsize: 20)),
                      child: Text(
                        'Comparison: VolModel vs VolPdf',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                    // Month Selector
                    if (tableController.availableMonths.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 15, ipadsize: 20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Select Month:', style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(height: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
                            DropdownButton<String>(
                              value: tableController.selectedMonth.value,
                              items: tableController.availableMonths
                                  .map(
                                    (month) => DropdownMenuItem(
                                      value: month,
                                      child: Text(tableController.getMonthDisplayName(month)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  tableController.selectedMonth.value = value;
                                  tableController.fillFilteredData();
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                    // Display Mode Selector (3 options)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 15, ipadsize: 20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Display Mode:', style: Theme.of(context).textTheme.bodyMedium),
                          SizedBox(height: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
                          Row(
                            children: [
                              // VolModel Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => tableController.displayMode.value = 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                      horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                    ),
                                    decoration: BoxDecoration(
                                      color: tableController.displayMode.value == 0
                                          ? Colors.blue
                                          : Colors.grey.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'VolModel',
                                        style: TextStyle(
                                          color: tableController.displayMode.value == 0
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              // VolPdf Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => tableController.displayMode.value = 1,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                      horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                    ),
                                    decoration: BoxDecoration(
                                      color: tableController.displayMode.value == 1
                                          ? Colors.green
                                          : Colors.grey.withValues(alpha: 0.3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'VolPdf',
                                        style: TextStyle(
                                          color: tableController.displayMode.value == 1
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              // StringVolModel Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => tableController.displayMode.value = 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                      horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                    ),
                                    decoration: BoxDecoration(
                                      color: tableController.displayMode.value == 2
                                          ? Colors.purple
                                          : Colors.grey.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'StringVol',
                                        style: TextStyle(
                                          color: tableController.displayMode.value == 2
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Summary
                    Padding(
                      padding: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 10, ipadsize: 15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'VolModels: ${TablescreenController.instance.filteredVolModels.length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'VolPdfs: ${TablescreenController.instance.filteredVolPdfs.length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    // Comparison Cards
                    if (tableController.displayMode.value == 0 &&
                            TablescreenController.instance.filteredVolModels.isEmpty ||
                        tableController.displayMode.value == 1 &&
                            TablescreenController.instance.filteredVolPdfs.isEmpty ||
                        tableController.displayMode.value == 2 &&
                            TablescreenController.instance.filteredStringVolModels.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
                          child: Text('No data available'),
                        ),
                      )
                    else
                      _buildCardsList(context, tableController),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds card list combining VolModel, VolPdf, and StringVolModel data filtered by selected month
  Widget _buildCardsList(BuildContext context, TablescreenController tableController) {
    if (tableController.displayMode.value == 0) {
      if (tableController.filteredVolModels.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
            child: Text('No data for selected month'),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tableController.filteredVolModels.length,
        itemBuilder: (context, index) {
          return _buildVolModelCard(context, tableController.filteredVolModels[index]);
        },
      );
    } else if (tableController.displayMode.value == 1) {
      if (tableController.filteredVolPdfs.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
            child: Text('No data for selected month'),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tableController.filteredVolPdfs.length,
        itemBuilder: (context, index) {
          return _buildVolPdfCard(context, tableController.filteredVolPdfs[index]);
        },
      );
    } else {
      if (tableController.filteredStringVolModels.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
            child: Text('No data for selected month'),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tableController.filteredStringVolModels.length,
        itemBuilder: (context, index) {
          return _buildStringVolModelCard(context, tableController.filteredStringVolModels[index]);
        },
      );
    }
  }

  /// Builds a card for VolModel data
  Widget _buildVolModelCard(BuildContext context, VolModel vol) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),
      //margin: EdgeInsets.only(bottom: AppTheme.h(x: 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
        border: Border.all(
          width: 1,
          color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
        ),
      ),
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with departure and arrival
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                    ),
                    Text(
                      vol.depIata.isEmpty ? '-' : vol.depIata,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.blue),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'To',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                    ),
                    Text(
                      vol.arrIata.isEmpty ? '-' : vol.arrIata,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),

          // Flight number and type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flight',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),
                  Text(vol.nVol.isEmpty ? '-' : vol.nVol, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Type',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),
                  Text(vol.typ.isEmpty ? '-' : vol.typ, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ],
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),

          // Departure and arrival times
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),
                  Text(_formatDateTime(vol.dtDebut), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Arrival',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),
                  Text(_formatDateTime(vol.dtFin), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a card for VolPdf data
  Widget _buildVolPdfCard(BuildContext context, VolPdf volPdf) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),
      decoration: BoxDecoration(
        color: Colors
            .white, //AppTheme.isDark ? Colors.green.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.getWidth(iphoneSize: 8, ipadsize: 12)),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1),
      ),
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with departure and arrival
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                    ),
                    Text(
                      volPdf.from.isEmpty ? '-' : volPdf.from,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.green),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'To',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                    ),
                    Text(
                      volPdf.to.isEmpty ? '-' : volPdf.to,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),

          // Activity and duty
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),
                  Text(
                    volPdf.activity.isEmpty ? '-' : volPdf.activity,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Duty',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),
                  Text(
                    volPdf.duty.isEmpty ? '-' : volPdf.duty,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 12, ipadsize: 16)),

          // Date and aircraft
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),
                  Text(_formatDateTime(volPdf.dateVol), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Arrivee',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.errorColor),
                  ),

                  Text(volPdf.myArrDate, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get month key in format YYYY-MM
  // String _getMonthKey(DateTime date) {
  //   return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  // }

  /// Formats DateTime to readable string
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Builds an elegant card for StringVolModel data with all fields
  Widget _buildStringVolModelCard(BuildContext context, StringVolModel stringVol) {
    final cardBg = AppTheme.isDark ? AppColors.darkBackground : AppColors.colorWhite;
    final borderColor = AppTheme.isDark ? AppColors.primaryLightColor : AppColors.primaryLightColor;
    final textPrimary = AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87;
    final textSecondary = AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor;

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 10, ipadsize: 12)),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.isDark ? Colors.black26 : Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 10, ipadsize: 12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Flight number and type with aircraft
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flight ${stringVol.nVol}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: textSecondary),
                    ),
                    Text(
                      stringVol.typ,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: textPrimary.withAlpha(180), fontSize: 9),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                  vertical: AppTheme.getWidth(iphoneSize: 4, ipadsize: 6),
                ),
                decoration: BoxDecoration(
                  color: textSecondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: textSecondary.withValues(alpha: 0.3), width: 0.5),
                ),
                child: Text(
                  stringVol.sAvion,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),

          // Route: From → To (compact)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
              vertical: AppTheme.getWidth(iphoneSize: 6, ipadsize: 8),
            ),
            decoration: BoxDecoration(
              color: textSecondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: textSecondary.withValues(alpha: 0.2), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stringVol.depIata.isEmpty ? '-' : stringVol.depIata,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        stringVol.depIcao,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: textPrimary.withAlpha(140), fontSize: 8),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: textSecondary, size: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        stringVol.arrIata.isEmpty ? '-' : stringVol.arrIata,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        stringVol.arrIcao,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: textPrimary.withAlpha(140), fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),

          // Times (compact)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildTimeField(context, 'Dep', stringVol.sDebut, textSecondary)),
              SizedBox(width: AppTheme.getWidth(iphoneSize: 6, ipadsize: 8)),
              Expanded(child: _buildTimeField(context, 'Arr', stringVol.sFin, textSecondary)),
            ],
          ),
          if (stringVol.sDureevol.isNotEmpty ||
              stringVol.sDureeMep.isNotEmpty ||
              stringVol.sDureeForfait.isNotEmpty ||
              stringVol.sMepForfait.isNotEmpty ||
              stringVol.sNuitVol.isNotEmpty ||
              stringVol.sNuitForfait.isNotEmpty) ...[
            SizedBox(height: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
            // Durations Grid (compact, 3 columns)
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppTheme.getWidth(iphoneSize: 4, ipadsize: 6),
              crossAxisSpacing: AppTheme.getWidth(iphoneSize: 4, ipadsize: 6),
              childAspectRatio: 1.2,
              children: [
                if (stringVol.sDureevol.isNotEmpty)
                  _buildDurationChip(context, 'Vol', stringVol.sDureevol, AppColors.primaryLightColor),
                if (stringVol.sDureeMep.isNotEmpty)
                  _buildDurationChip(context, 'MEP', stringVol.sDureeMep, AppColors.secondaryColor),
                if (stringVol.sDureeForfait.isNotEmpty)
                  _buildDurationChip(context, 'F.Vol', stringVol.sDureeForfait, myColorOrg),
                if (stringVol.sMepForfait.isNotEmpty)
                  _buildDurationChip(context, 'F.MEP', stringVol.sMepForfait, myColorOrg),
                if (stringVol.sNuitVol.isNotEmpty)
                  _buildDurationChip(context, 'Nuit', stringVol.sNuitVol, myColorRed),
                if (stringVol.sNuitForfait.isNotEmpty)
                  _buildDurationChip(context, 'F.Nuit', stringVol.sNuitForfait, myColorRed),
              ],
            ),
          ],
          // Monthly Cumulative Section - Only show if at least one cumul is not empty/00h00
          if ((stringVol.sCumulDureeVol.isNotEmpty && stringVol.sCumulDureeVol != '00h00') ||
              (stringVol.sCumulDureeMep.isNotEmpty && stringVol.sCumulDureeMep != '00h00') ||
              (stringVol.sCumulDureeForfait.isNotEmpty && stringVol.sCumulDureeForfait != '00h00') ||
              (stringVol.sCumulMepForfait.isNotEmpty && stringVol.sCumulMepForfait != '00h00') ||
              (stringVol.sCumulNuitVol.isNotEmpty && stringVol.sCumulNuitVol != '00h00') ||
              (stringVol.sCumulNuitForfait.isNotEmpty && stringVol.sCumulNuitForfait != '00h00')) ...[
            SizedBox(height: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                vertical: AppTheme.getWidth(iphoneSize: 6, ipadsize: 8),
              ),
              decoration: BoxDecoration(
                color: textSecondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: textSecondary.withValues(alpha: 0.2), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cumuls du mois',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textSecondary,
                      fontSize: 9,
                    ),
                  ),
                  SizedBox(height: AppTheme.getWidth(iphoneSize: 4, ipadsize: 6)),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppTheme.getWidth(iphoneSize: 3, ipadsize: 4),
                    crossAxisSpacing: AppTheme.getWidth(iphoneSize: 3, ipadsize: 4),
                    childAspectRatio: 1.5,
                    children: [
                      if (stringVol.sCumulDureeVol.isNotEmpty && stringVol.sCumulDureeVol != '00h00')
                        _buildCumulChip(
                          context,
                          'C.Vol',
                          stringVol.sCumulDureeVol,
                          AppColors.primaryLightColor,
                        ),
                      if (stringVol.sCumulDureeMep.isNotEmpty && stringVol.sCumulDureeMep != '00h00')
                        _buildCumulChip(context, 'C.MEP', stringVol.sCumulDureeMep, AppColors.secondaryColor),
                      if (stringVol.sCumulDureeForfait.isNotEmpty && stringVol.sCumulDureeForfait != '00h00')
                        _buildCumulChip(context, 'C.F.V', stringVol.sCumulDureeForfait, myColorOrg),
                      if (stringVol.sCumulMepForfait.isNotEmpty && stringVol.sCumulMepForfait != '00h00')
                        _buildCumulChip(context, 'C.F.M', stringVol.sCumulMepForfait, myColorOrg),
                      if (stringVol.sCumulNuitVol.isNotEmpty && stringVol.sCumulNuitVol != '00h00')
                        _buildCumulChip(context, 'C.Nuit', stringVol.sCumulNuitVol, myColorRed),
                      if (stringVol.sCumulNuitForfait.isNotEmpty && stringVol.sCumulNuitForfait != '00h00')
                        _buildCumulChip(context, 'C.F.N', stringVol.sCumulNuitForfait, myColorRed),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (stringVol.tsv.isNotEmpty) ...[
            SizedBox(height: AppTheme.getWidth(iphoneSize: 6, ipadsize: 8)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.getWidth(iphoneSize: 6, ipadsize: 8),
                vertical: AppTheme.getWidth(iphoneSize: 3, ipadsize: 4),
              ),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.3), width: 0.5),
              ),
              child: Text(
                'TSV: ${stringVol.tsv}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Helper widget for time fields
  Widget _buildTimeField(BuildContext context, String label, String time, Color color) {
    return Container(
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color.withValues(alpha: 0.7), fontSize: 9),
          ),
          SizedBox(height: 2),
          Text(
            time,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Helper widget for duration chips
  Widget _buildDurationChip(BuildContext context, String label, String duration, Color color) {
    return Container(
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 6, ipadsize: 8)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.7),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Text(
            duration,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: color, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// Helper widget for cumulative chips (smaller version)
  Widget _buildCumulChip(BuildContext context, String label, String duration, Color color) {
    return Container(
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 4, ipadsize: 6)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.6),
              fontSize: 7,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1),
          Text(
            duration,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
