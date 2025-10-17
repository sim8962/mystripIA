import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../Models/userModel/my_download.dart';
import '../../../../theming/app_color.dart';
import '../../../../theming/app_theme.dart';

import '../../../Models/ActsModels/myduty.dart';
import 'download_duties.dart';
import '../downloads_list_controller.dart';

class MydownloadCarde extends StatelessWidget {
  const MydownloadCarde({required this.download, required this.controller, super.key});
  final MyDownLoad download;
  final DownloadsListController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.h(x: 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.r(x: 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: AppTheme.r(x: 8),
            offset: Offset(0, AppTheme.h(x: 2)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.r(x: 12)),
          onTap: () => _showDownloadDetails(download, controller),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.w(x: 16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: AppTheme.w(x: 50),
                  height: AppTheme.h(x: 50),
                  child: InkWell(
                    onTap: () => _showDeleteConfirmation(download, controller),
                    borderRadius: BorderRadius.circular(AppTheme.r(x: 80)),
                    child: Container(
                      padding: EdgeInsets.all(AppTheme.w(x: 6)),
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(AppTheme.r(x: 80)),
                      ),
                      child: Icon(Icons.delete_outline, size: AppTheme.s(x: 18), color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: AppTheme.w(x: 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getFormattedDate(download.downloadTime),
                        style: TextStyle(
                          color: AppTheme.isDark ? AppColors.secondaryColor : AppColors.primaryLightColor,
                          fontWeight: FontWeight.w800,
                          fontSize: AppTheme.getfontSize(iphoneSize: 16, ipadsize: 16),
                        ),
                      ),
                      SizedBox(height: AppTheme.h(x: 8)),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: AppTheme.s(x: 16), color: Colors.grey[500]),
                          SizedBox(width: AppTheme.w(x: 4)),
                          Expanded(
                            child: Text(
                              '${download.downloadTime.day}/${download.downloadTime.month}/${download.downloadTime.year} at ${download.downloadTime.hour.toString().padLeft(2, '0')}:${download.downloadTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: AppTheme.s(x: 12), color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: AppTheme.s(x: 30), color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Color _getContentTypeColor(String contentType) {
  //   switch (contentType) {
  //     case DownloadsListController.contentTypeJson:
  //       return Colors.blue;
  //     case DownloadsListController.contentTypeHtml:
  //       return Colors.green;
  //     case DownloadsListController.contentTypeJsonHtml:
  //       return Colors.purple;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  void _showDeleteConfirmation(MyDownLoad download, DownloadsListController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Download',
          style: TextStyle(
            fontSize: AppTheme.getfontSize(iphoneSize: 18, ipadsize: 22),
            fontWeight: FontWeight.w600,
            color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this download? This action cannot be undone.',
          style: TextStyle(
            fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 16),
            color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
          ),
        ),
        backgroundColor: AppTheme.isDark ? AppColors.colorblack87 : AppColors.colorWhite,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 16),
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.deleteDownload(download); // Delete the download
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: AppTheme.getfontSize(iphoneSize: 14, ipadsize: 16),
                color: Colors.red[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadDetails(MyDownLoad download, DownloadsListController controller) {
    // Check if the download has parseable JSON content for MyDuty display
    if (controller.hasParseableJsonContent(download)) {
      _showDutiesFromDownload(download, controller);
    } else {
      _showRawContentDialog(download, controller);
    }
  }

  void _showDutiesFromDownload(MyDownLoad download, DownloadsListController controller) {
    final List<MyDuty> myDutiesbyDates = controller.parseJsonContentToDuties(download);
    Get.to(
      () => DateDuties(myDutiesbyDates: myDutiesbyDates, download: download, controller: controller),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _showRawContentDialog(MyDownLoad download, DownloadsListController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r(x: 16))),
        child: Container(
          constraints: BoxConstraints(maxHeight: 0.8.sh, maxWidth: 0.9.sw),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(AppTheme.w(x: 20)),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.r(x: 16)),
                    topRight: Radius.circular(AppTheme.r(x: 16)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Download Details',
                            style: TextStyle(fontSize: AppTheme.s(x: 18), fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: AppTheme.h(x: 4)),
                          Text(
                            controller.getFormattedDate(download.downloadTime),
                            style: TextStyle(fontSize: AppTheme.s(x: 14), color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, size: AppTheme.s(x: 24)),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppTheme.w(x: 20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (download.jsonContent != null && download.jsonContent!.isNotEmpty) ...[
                        Text(
                          'JSON Content:',
                          style: TextStyle(fontSize: AppTheme.s(x: 16), fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: AppTheme.h(x: 8)),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppTheme.w(x: 12)),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(AppTheme.r(x: 8)),
                          ),
                          child: Text(
                            download.jsonContent!,
                            style: TextStyle(fontSize: AppTheme.s(x: 12), fontFamily: 'monospace'),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      if (download.htmlContent != null && download.htmlContent!.isNotEmpty) ...[
                        Text(
                          'HTML Content:',
                          style: TextStyle(fontSize: AppTheme.s(x: 16), fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppTheme.w(x: 12)),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(AppTheme.r(x: 8)),
                          ),
                          child: Text(
                            download.htmlContent!,
                            style: TextStyle(fontSize: AppTheme.s(x: 12), fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
