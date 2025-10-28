import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Models/VolsModels/vol_traite.dart';
import '../../../../../Models/ActsModels/typ_const.dart';
import '../../../../../theming/app_color.dart';
import '../../../../../theming/app_theme.dart';
import '../../../../../theming/apptheme_constant.dart';

import 'cardesVols/flight_card.dart';
import 'cardesVols/htl_card.dart';
import 'vot_controller.dart';
import 'cardesVols/duty_card.dart';

class VolScreen extends GetView<VolController> {
  const VolScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        // SizedBox(height: AppTheme.getheight(iphoneSize: 5, ipadsize: 5)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppTheme.getWidth(iphoneSize: 6, ipadsize: 6)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
            border: Border.all(color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor),
          ),
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'vol_search_hint'.tr,
              hintStyle: AppStylingConstant.volSearchHintStyle,
              prefixIcon: Icon(Icons.search, size: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 12)),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          controller.searchController.clear();
                          controller.clearSearch();
                        },
                        icon: Icon(Icons.clear, size: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 14)),
                      )
                    : const SizedBox.shrink(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
                borderSide: BorderSide(
                  color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: AppTheme.fonfColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.getWidth(iphoneSize: 16, ipadsize: 16),
                vertical: AppTheme.getheight(iphoneSize: 12, ipadsize: 12),
              ),
            ),
          ),
        ),

        // Activities List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
                ),
              );
            }

            final vols = controller.filteredVolsTraites;

            if (vols.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flight_takeoff,
                      size: AppTheme.s(x: 64),
                      color: AppTheme.isDark
                          ? AppColors.colorWhite.withAlpha(100)
                          : AppColors.colorblack87.withAlpha(100),
                    ),
                    SizedBox(height: AppTheme.h(x: 16)),
                    Text(
                      controller.searchQuery.value.isNotEmpty
                          ? 'vol_no_activity_found'.tr
                          : 'vol_no_activity_available'.tr,
                      style: AppStylingConstant.volEmptyStateStyle,
                    ),
                    if (controller.searchQuery.value.isNotEmpty) ...[
                      SizedBox(height: AppTheme.h(x: 8)),
                      Text('vol_try_other_keywords'.tr, style: AppStylingConstant.volEmptySubtitleStyle),
                    ],
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => controller.refreshVolTransits(),
              color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
              child: ListView.builder(
                padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 10, ipadsize: 10)),
                itemCount: vols.length,
                itemBuilder: (context, index) {
                  final vol = vols[index];
                  //print('activity.dtDebut :${activity.dtDebut}');
                  return _buildVolTraiteCard(vol, controller);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildVolTraiteCard(VolTraiteModel vol, VolController controller) {
    // Si c'est un vol de type Vol, MEP ou TAX, utiliser la carte détaillée

    if (vol.typ == tVol.typ || vol.typ == tMEP.typ || vol.typ == tTAX.typ) {
      return FlightCard(vol: vol, controller: controller);
    } else if (vol.typ == tHTL.typ) {
      return HtlCard(vol: vol, controller: controller);
    } else {
      return DutyCard(vol: vol, controller: controller);
    }
  }
}
