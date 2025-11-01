import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/VolsModels/vol.dart';

import '../../Models/stringvols/stringvolmois.dart';
import '../../Models/stringvols/svolmodel.dart';
import '../../Models/volpdfs/vol_pdf.dart';

import '../../routes/app_routes.dart';
import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';
import '../widgets/background_container.dart';
import 'widgets/card_vol_model_compare.dart';
import 'widgets/card_vol_pdf_compare.dart';
import 'widgets/card_string_vol_model_compare.dart';
import 'comparevol_ctl.dart';

class CompareVolScreen extends GetView<CompareVolsController> {
  const CompareVolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompareVolsController>(
      init: CompareVolsController(),
      builder: (compareVolsController) {
        return _buildScreen(context, compareVolsController);
      },
    );
  }

  Widget _buildScreen(BuildContext context, CompareVolsController compareVolsController) {
    return GetBuilder<CompareVolsController>(
      initState: (_) async {
        // Load all data from database first
      },
      builder: (_) {
        return BackgroundContainer(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getheight(iphoneSize: 10, ipadsize: 10)),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (compareVolsController.availableMonths.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 15, ipadsize: 20)),
                      child: Row(
                        children: [
                          Text('Select Month:', style: Theme.of(context).textTheme.bodyMedium),
                          SizedBox(width: AppTheme.getWidth(iphoneSize: 15, ipadsize: 10)),
                          Expanded(
                            child: DropdownButton<String>(
                              dropdownColor: (AppTheme.isDark != true)
                                  ? Colors.white
                                  : AppColors.darkBackground,

                              value: compareVolsController.selectedMonth.value,
                              items: compareVolsController.availableMonths
                                  .map(
                                    (month) => DropdownMenuItem(
                                      value: month,
                                      child: Text(
                                        compareVolsController.getMonthDisplayName(month),
                                        style: AppStylingConstant.dutyLabelStyle,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  compareVolsController.selectedMonth.value = value;
                                  compareVolsController.fillFilteredData();
                                }
                              },
                            ),
                          ),
                          IconButton(
                            iconSize: 30,
                            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
                            icon: const Icon(Icons.home_filled),
                            onPressed: () {
                              Routes.toHome();
                            },
                          ),
                        ],
                      ),
                    ),

                  // Display Mode Selector (3 options)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 15, ipadsize: 20)),
                    child: Row(
                      children: [
                        // VolModel Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => compareVolsController.displayMode.value = 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                              ),
                              decoration: BoxDecoration(
                                color: compareVolsController.displayMode.value == 0
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
                                    color: compareVolsController.displayMode.value == 0
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
                            onTap: () => compareVolsController.displayMode.value = 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                              ),
                              decoration: BoxDecoration(
                                color: compareVolsController.displayMode.value == 1
                                    ? Colors.green
                                    : Colors.grey.withValues(alpha: 0.3),
                              ),
                              child: Center(
                                child: Text(
                                  'VolPdf',
                                  style: TextStyle(
                                    color: compareVolsController.displayMode.value == 1
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
                            onTap: () => compareVolsController.displayMode.value = 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                              ),
                              decoration: BoxDecoration(
                                color: compareVolsController.displayMode.value == 2
                                    ? Colors.purple
                                    : Colors.grey.withValues(alpha: 0.3),
                                // middle-right button (no border radius, the last button will have it)
                              ),
                              child: Center(
                                child: Text(
                                  'StVolModel',
                                  style: TextStyle(
                                    color: compareVolsController.displayMode.value == 2
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
                        // StringVolModel Table Button (4th)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => compareVolsController.displayMode.value = 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                                horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                              ),
                              decoration: BoxDecoration(
                                color: compareVolsController.displayMode.value == 3
                                    ? Colors.orange
                                    : Colors.grey.withValues(alpha: 0.3),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Table',
                                  style: TextStyle(
                                    color: compareVolsController.displayMode.value == 3
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
                  ),

                  // Summary
                  Padding(
                    padding: EdgeInsets.only(bottom: AppTheme.getWidth(iphoneSize: 10, ipadsize: 15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'VolModels: ${CompareVolsController.instance.filteredVolModels.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'VolPdfs: ${CompareVolsController.instance.filteredVolPdfs.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'StringVols: ${CompareVolsController.instance.filteredStringVolModels.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        // Text(
                        //   'Mois: ${CompareVolsController.instance.stringVolMois.length}',
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        // ),
                      ],
                    ),
                  ),

                  // Comparison Cards
                  if (compareVolsController.displayMode.value == 0 &&
                          CompareVolsController.instance.filteredVolModels.isEmpty ||
                      compareVolsController.displayMode.value == 1 &&
                          CompareVolsController.instance.filteredVolPdfs.isEmpty ||
                      compareVolsController.displayMode.value == 2 &&
                          CompareVolsController.instance.filteredStringVolModels.isEmpty ||
                      compareVolsController.displayMode.value == 3 &&
                          CompareVolsController.instance.filteredStringVolModels.isEmpty)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
                          child: Text('No data available'),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(child: _buildCardsList(context, compareVolsController)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds card list combining VolModel, VolPdf, and StringVolModel data filtered by selected month
  Widget _buildCardsList(BuildContext context, CompareVolsController compareVolsController) {
    if (compareVolsController.displayMode.value == 0) {
      if (compareVolsController.filteredVolModels.isEmpty) {
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
        itemCount: compareVolsController.filteredVolModels.length,
        itemBuilder: (context, index) {
          return _buildVolModelCard(context, compareVolsController.filteredVolModels[index]);
        },
      );
    } else if (compareVolsController.displayMode.value == 1) {
      if (compareVolsController.filteredVolPdfs.isEmpty) {
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
        itemCount: compareVolsController.filteredVolPdfs.length,
        itemBuilder: (context, index) {
          return _buildVolPdfCard(context, compareVolsController.filteredVolPdfs[index]);
        },
      );
    } else if (compareVolsController.displayMode.value == 2) {
      if (compareVolsController.filteredStringVolModels.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
            child: Text('No data for selected month'),
          ),
        );
      }
      return Column(
        children: [
          if (compareVolsController.filteredStringVolMois.isNotEmpty)
            _buildStringVolMoisCard(
              context,
              compareVolsController.filteredStringVolMois.first,

              // compareVolsController.filteredVolPdfLists.first.tags,
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: compareVolsController.filteredStringVolModels.length,
            itemBuilder: (context, index) {
              return _buildStringVolModelCard(context, compareVolsController.filteredStringVolModels[index]);
            },
          ),
        ],
      );
    } else if (compareVolsController.displayMode.value == 3) {
      if (compareVolsController.filteredStringVolModels.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
            child: Text('No data for selected month'),
          ),
        );
      }
      return _buildStringVolTable(context, compareVolsController.filteredStringVolModels);
    }
    //else {
    //   if (compareVolsController.stringVolMois.isEmpty) {
    //     return Center(
    //       child: Padding(
    //         padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
    //         child: Text('No data for selected month'),
    //       ),
    //     );
    //   }
    //   return ListView.builder(
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: compareVolsController.stringVolMois.length,
    //     itemBuilder: (context, index) {
    //       return _buildStringVolMoisCard(context, compareVolsController.stringVolMois[index]);
    //     },
    //   );
    // }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 20, ipadsize: 30)),
        child: Text('No data for selected month'),
      ),
    );
  }

  /// Builds a card for VolModel data
  Widget _buildVolModelCard(BuildContext context, VolModel vol) {
    return CardVolModelCompare(vol: vol);
  }

  /// Builds a card for VolPdf data
  Widget _buildVolPdfCard(BuildContext context, VolPdf volPdf) {
    return CardVolPdfCompare(volPdf: volPdf);
  }

  /// Builds a card for StringVolModel data
  Widget _buildStringVolModelCard(BuildContext context, StringVolModel stringVol) {
    return CardStringVolModelCompare(stringVol: stringVol);
  }

  /// Builds a card for StringVolModelMois data
  Widget _buildStringVolMoisCard(BuildContext context, StringVolModelMois mois) {
    return Container(
      margin: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 5, ipadsize: 5)),
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 8, ipadsize: 8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.getRadius(iphoneSize: 8, ipadsize: 8)),
        border: Border.all(
          color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CompareVolsController.instance.getMonthDisplayName(mois.moisReference),
            style: AppStylingConstant.volDetailMonthStyle,
          ),
          Divider(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            thickness: 1,
            height: AppTheme.getheight(iphoneSize: 16, ipadsize: 16),
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDurationItem(label: 'Vol  : ${mois.cumulTotalDureeVol}'),
                  SizedBox(width: AppTheme.getheight(iphoneSize: 8, ipadsize: 8)),
                  buildDurationItem(label: 'ForfV: ${mois.cumulTotalDureeForfait}'),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
              ),
              Column(
                children: [
                  buildDurationItem(label: 'MEP: ${mois.cumulTotalDureeMep}'),
                  SizedBox(width: AppTheme.getheight(iphoneSize: 8, ipadsize: 8)),
                  buildDurationItem(label: 'ForfM: ${mois.cumulTotalMepForfait}'),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildDurationItem(label: 'Nuit: ${mois.cumulTotalNuitVol}'),
                  SizedBox(width: AppTheme.getheight(iphoneSize: 8, ipadsize: 8)),
                  buildDurationItem(label: 'ForfN: ${mois.cumulTotalNuitForfait}'),
                ],
              ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'ForV: ${mois.cumulTotalDureeForfait}',
          //       style: AppStylingConstant.volDetailIATAStyle.copyWith(fontSize: 12),
          //     ),
          //     Text(
          //       'ForM: ${mois.cumulTotalMepForfait}',
          //       style: AppStylingConstant.volDetailIATAStyle.copyWith(fontSize: 12),
          //     ),
          //     Text(
          //       'ForN: ${mois.cumulTotalNuitForfait}',
          //       style: AppStylingConstant.volDetailIATAStyle.copyWith(fontSize: 12),
          //     ),
          //   ],
          // ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 10, ipadsize: 12)),
          Divider(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            thickness: 1,
            height: AppTheme.getheight(iphoneSize: 16, ipadsize: 16),
          ),
          if (CompareVolsController.instance.filteredVolPdfLists.isNotEmpty)
            Text(
              CompareVolsController.instance.filteredVolPdfLists.first.tags,
              style: AppStylingConstant.volDetailMonthStyle,
            ),
          Divider(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            thickness: 1,
            height: AppTheme.getheight(iphoneSize: 16, ipadsize: 16),
          ),
          SizedBox(height: AppTheme.getWidth(iphoneSize: 6, ipadsize: 8)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildDurationItem(label: 'AnV: ${mois.cumulAnTotalDureeVol}'),
              Container(
                width: 1,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
              ),
              buildDurationItem(label: 'AnM: ${mois.cumulAnTotalDureeMep}'),
              Container(
                width: 1,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
              ),
              buildDurationItem(label: 'AnN: ${mois.cumulAnTotalNuitVol}'),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildDurationItem({required String label}) {
    if (label.contains('00h00')) label = label.replaceAll('00h00', 'flight_nil'.tr);
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppTheme.getheight(iphoneSize: 4, ipadsize: 4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.getRadius(iphoneSize: 6, ipadsize: 6)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppStylingConstant.volNumeriq.copyWith(
          fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 13),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStringVolTable(BuildContext context, List<StringVolModel> items) {
    return Container(
      margin: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 5, ipadsize: 5)),
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 4, ipadsize: 6)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.getRadius(iphoneSize: 8, ipadsize: 8)),
        border: Border.all(
          color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: AppTheme.getheight(iphoneSize: 30, ipadsize: 34),
          dataRowMinHeight: AppTheme.getheight(iphoneSize: 24, ipadsize: 28),
          dataRowMaxHeight: AppTheme.getheight(iphoneSize: 26, ipadsize: 30),
          columnSpacing: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
          horizontalMargin: AppTheme.getWidth(iphoneSize: 6, ipadsize: 8),
          columns: const [
            DataColumn(label: Text('Typ')),
            DataColumn(label: Text('N°')),
            DataColumn(label: Text('Début')),
            DataColumn(label: Text('Fin')),
            DataColumn(label: Text('D.Vol')),
            DataColumn(label: Text('C.Vol')),
            DataColumn(label: Text('F.Vol')),
            DataColumn(label: Text('C.FV')),
            DataColumn(label: Text('Nuit')),
            DataColumn(label: Text('C.Nuit')),
          ],
          rows: items.map((s) {
            final debut = _formatDayTime(s.sDebut);
            final fin = _formatDayTime(s.sFin);
            return DataRow(
              cells: [
                DataCell(Text(s.typ, style: AppStylingConstant.volNumeriq)),
                DataCell(Text(s.nVol, style: AppStylingConstant.volNumeriq)),
                DataCell(Text(debut, style: AppStylingConstant.volNumeriq)),
                DataCell(Text(fin, style: AppStylingConstant.volNumeriq)),
                DataCell(Text(_nz(s.sDureevol), style: AppStylingConstant.volNumeriq)),
                DataCell(Text(_nz(s.sCumulDureeVol), style: AppStylingConstant.volNumeriq)),
                DataCell(Text(_nz(s.sDureeForfait), style: AppStylingConstant.volNumeriq)),
                DataCell(Text(_nz(s.sCumulDureeForfait), style: AppStylingConstant.volNumeriq)),
                DataCell(Text(_nz(s.sNuitVol), style: AppStylingConstant.volNumeriq)),
                DataCell(Text(_nz(s.sCumulNuitVol), style: AppStylingConstant.volNumeriq)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _formatDayTime(String sDateTime) {
    try {
      final parts = sDateTime.split(' ');
      final dd = parts[0].split('/')[0];
      final hm = parts.length > 1 ? parts[1] : '00:00';
      return '$dd $hm';
    } catch (_) {
      return sDateTime;
    }
  }

  String _nz(String v) {
    return v == '00h00' ? '' : v;
  }
}
