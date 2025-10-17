import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../Models/ActsModels/myduty.dart';
import '../../../../Models/userModel/my_download.dart';
import '../../../../theming/app_color.dart';
import '../../../../theming/app_theme.dart';
import '../../widgets/allduties.dart';
import '../../widgets/background_container.dart';
import '../downloads_list_controller.dart';

class DateDuties extends StatelessWidget {
  DateDuties({required this.myDutiesbyDates, required this.download, required this.controller, super.key});
  final MyDownLoad download;
  final DownloadsListController controller;
  final List<MyDuty> myDutiesbyDates;
  final ItemScrollController scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Column(
        children: [
          // Custom AppBar
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 16), vertical: AppTheme.h(x: 8)),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: AppTheme.s(x: 20),
                    color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
                  ),
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: Text(
                    'Duties - ${controller.getFormattedDate(download.downloadTime)}',
                    style: TextStyle(
                      fontSize: AppTheme.getfontSize(iphoneSize: 18, ipadsize: 20),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                      color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body content
          Expanded(
            child: myDutiesbyDates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: AppTheme.s(x: 64),
                          color: AppTheme.isDark
                              ? AppColors.colorWhite.withValues(alpha: 0.6)
                              : Colors.grey[400],
                        ),
                        SizedBox(height: AppTheme.h(x: 16)),
                        Text(
                          'No Duties Found',
                          style: TextStyle(
                            fontSize: AppTheme.getfontSize(iphoneSize: 20, ipadsize: 22),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lato',
                            color: AppTheme.isDark
                                ? AppColors.colorWhite.withValues(alpha: 0.8)
                                : Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: AppTheme.h(x: 8)),
                        Text(
                          'Unable to parse duties from this download.',
                          style: TextStyle(
                            fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 16),
                            fontFamily: 'Lato',
                            color: AppTheme.isDark
                                ? AppColors.colorWhite.withValues(alpha: 0.6)
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : Allduties(duties: myDutiesbyDates, scrollController: scrollController),
          ),
        ],
      ),
    );
  }
}
