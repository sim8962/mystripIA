import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../widgets/background_container.dart';
import 'downloads_list_controller.dart';
import 'widgets/mydownload_carde.dart';

class DownloadsListScreen extends GetView<DownloadsListController> {
  const DownloadsListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BackgroundContainer(
      isButton: FloatingActionButton(
        onPressed: () => Routes.toHome(),
        backgroundColor: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
        child: Icon(
          Icons.home_filled,
          size: AppTheme.getfontSize(iphoneSize: 20, ipadsize: 24),
          color: AppTheme.isDark ? AppColors.colorblack87 : AppColors.colorWhite,
        ),
      ),
      child: Column(
        children: [
          // Body content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(strokeWidth: AppTheme.w(x: 3)),
                      SizedBox(height: AppTheme.h(x: 16)),
                      Text(
                        'Loading downloads...',
                        style: TextStyle(fontSize: AppTheme.s(x: 16), color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: AppTheme.s(x: 64), color: Colors.red[400]),
                      SizedBox(height: AppTheme.h(x: 16)),
                      Text(
                        'Error',
                        style: TextStyle(
                          fontSize: AppTheme.s(x: 20),
                          fontWeight: FontWeight.w600,
                          color: Colors.red[400],
                        ),
                      ),
                      SizedBox(height: AppTheme.h(x: 8)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 32)),
                        child: Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: AppTheme.s(x: 14), color: Colors.grey[600]),
                        ),
                      ),
                      SizedBox(height: AppTheme.h(x: 24)),
                      ElevatedButton(
                        onPressed: () => controller.refreshDownloads(),
                        child: Text('Retry', style: TextStyle(fontSize: AppTheme.s(x: 16))),
                      ),
                    ],
                  ),
                );
              }

              if (controller.downloads.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_outlined, size: AppTheme.s(x: 64), color: Colors.grey[400]),
                      SizedBox(height: AppTheme.h(x: 16)),
                      Text(
                        'No Downloads',
                        style: TextStyle(
                          fontSize: AppTheme.s(x: 20),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: AppTheme.h(x: 8)),
                      Text(
                        'You haven\'t downloaded any content yet.',
                        style: TextStyle(fontSize: AppTheme.s(x: 14), color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => controller.refreshDownloads(),
                child: ListView.builder(
                  padding: EdgeInsets.all(AppTheme.w(x: 16)),
                  itemCount: controller.downloads.length,
                  itemBuilder: (context, index) {
                    final download = controller.downloads[index];
                    return MydownloadCarde(controller: controller, download: download);
                    //_buildDownloadCard(download, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
