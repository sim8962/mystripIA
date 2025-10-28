import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../Models/userModel/my_download.dart';
import '../../../Models/jsonModels/mystripjson/mystrip_model.dart';
import '../../../Models/ActsModels/myduty.dart';
import '../../../services/strip_processor.dart';
import '../../../helpers/fct.dart';

import '../../controllers/database_controller.dart';

class DownloadsListController extends GetxController {
  final DatabaseController _databaseController = DatabaseController.instance;

  final StripProcessor _stripProcessor = StripProcessor();

  // Content type constants
  static const String contentTypeJson = 'JSON';
  static const String contentTypeHtml = 'HTML';
  static const String contentTypeJsonHtml = 'JSON + HTML';
  static const String contentTypeEmpty = 'Empty';

  // Date formatting constants
  static const String dateToday = 'Today';
  static const String dateYesterday = 'Yesterday';
  static const String dateUnknown = 'Unknown date';
  static const String dateDaysAgo = 'days ago';

  // Observable list of downloads
  final RxList<MyDownLoad> downloads = <MyDownLoad>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDownloads();
  }

  /// Load all downloads for the current user, sorted by date (newest first)
  void loadDownloads() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentUser = _databaseController.currentUser;
      if (currentUser != null) {
        final userDownloads = _databaseController.getDownloadsByUser(currentUser.id).toSet().toList();

        // Sort by downloadTime (newest first)
        userDownloads.sort((a, b) {
          return b.downloadTime.compareTo(a.downloadTime); // Descending order (newest first)
        });

        downloads.value = userDownloads;
      } else {
        downloads.clear();
        errorMessage.value = 'No user found';
      }
    } catch (e) {
      errorMessage.value = 'Error loading downloads: $e';
      downloads.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh the downloads list
  void refreshDownloads() {
    loadDownloads();
  }

  /// Get formatted date string for display
  String getFormattedDate(DateTime? dateTime) {
    if (dateTime == null) return dateUnknown;
    DateTime dt0 = Fct.dayOfDate(dt: DateTime.now());
    DateTime dt = Fct.dayOfDate(dt: dateTime);
    final difference = dt0.difference(dt);

    if (difference.inDays == 0) {
      return '$dateToday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '$dateYesterday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} $dateDaysAgo';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Get content preview (first 100 characters)
  String getContentPreview(MyDownLoad download) {
    String content = '';

    if (download.jsonContent != null && download.jsonContent!.isNotEmpty) {
      content = download.jsonContent!;
    } else if (download.htmlContent != null && download.htmlContent!.isNotEmpty) {
      content = download.htmlContent!;
    }

    if (content.isEmpty) return 'No content available';

    // Remove HTML tags and extra whitespace
    content = content.replaceAll(RegExp(r'<[^>]*>'), '');
    content = content.replaceAll(RegExp(r'\s+'), ' ').trim();

    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }

  /// Get content type indicator
  String getContentType(MyDownLoad download) {
    if (download.jsonContent != null && download.jsonContent!.isNotEmpty) {
      if (download.htmlContent != null && download.htmlContent!.isNotEmpty) {
        return contentTypeJsonHtml;
      }
      return contentTypeJson;
    } else if (download.htmlContent != null && download.htmlContent!.isNotEmpty) {
      return contentTypeHtml;
    }
    return contentTypeEmpty;
  }

  /// Parse jsonContent from MyDownLoad into `List<MyDuty>`
  List<MyDuty> parseJsonContentToDuties(MyDownLoad download) {
    try {
      if (download.jsonContent == null || download.jsonContent!.isEmpty) {
        return [];
      }

      // Parse JSON content using the same logic as webview controller
      final jsonResponse = json.decode(download.jsonContent!);
      final myStrip = MyStrip.fromJson(jsonResponse);
      final myDutiesbyDates = _stripProcessor.processMyStripIntoDuties(myStrip);

      return myDutiesbyDates;
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing JSON content to duties: $e');
      }
      return [];
    }
  }

  /// Check if download has parseable JSON content
  bool hasParseableJsonContent(MyDownLoad download) {
    return download.jsonContent != null &&
        download.jsonContent!.isNotEmpty &&
        download.jsonContent!.trim().startsWith('{');
  }

  /// Delete a specific download from both UI list and ObjectBox database
  void deleteDownload(MyDownLoad download) {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentUser = _databaseController.currentUser;
      if (currentUser == null) {
        errorMessage.value = 'No user found';
        return;
      }

      // Remove from ObjectBox database
      _databaseController.deleteDownloads([download]);

      // Remove from user's relationship
      currentUser.myDownLoads.remove(download);
      _databaseController.updateUser(currentUser);

      // Remove from reactive list for immediate UI update
      downloads.remove(download);

      // Show success message
      Get.snackbar(
        'Download Deleted',
        'Download removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      if (kDebugMode) {
        print('Deleted download with ID: ${download.id}');
      }
    } catch (e) {
      errorMessage.value = 'Error deleting download: $e';
      if (kDebugMode) {
        print('Error deleting download: $e');
      }

      Get.snackbar(
        'Error',
        'Failed to delete download: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clean duplicates from MyDownLoad box based on custom == operator
  /// (compares by year, month, day, minute, second - ignores milliseconds and hour)
  void cleanDuplicateDownloads() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentUser = _databaseController.currentUser;
      if (currentUser == null) {
        errorMessage.value = 'No user found';
        return;
      }

      // Get all downloads for current user
      final userDownloads = _databaseController.getDownloadsByUser(currentUser.id);

      if (userDownloads.isEmpty) {
        if (kDebugMode) {
          print('No downloads found for cleanup');
        }
        return; // Silent return when called from refreshDownloads()
      }

      // Sort downloads by ID (ascending) to process older ones first
      userDownloads.sort((a, b) => a.id.compareTo(b.id));

      // Use Set for more efficient duplicate detection
      final Set<MyDownLoad> uniqueDownloads = <MyDownLoad>{};
      final List<MyDownLoad> duplicatesToDelete = [];

      for (final download in userDownloads) {
        // Try to add to Set - if it returns false, it's a duplicate
        if (!uniqueDownloads.add(download)) {
          // It's a duplicate, add to deletion list
          duplicatesToDelete.add(download);
          if (kDebugMode) {
            print('Found duplicate: ID ${download.id}, Time: ${download.downloadTime}');
          }
        }
      }

      if (duplicatesToDelete.isEmpty) {
        if (kDebugMode) {
          print('No duplicate downloads found');
        }
        return; // Silent return when called from refreshDownloads()
      }

      // Delete duplicates from database
      _databaseController.deleteDownloads(duplicatesToDelete);

      // Remove duplicates from user's relationship
      for (final duplicate in duplicatesToDelete) {
        currentUser.myDownLoads.remove(duplicate);
      }
      _databaseController.updateUser(currentUser);

      // Refresh the downloads list (avoid infinite loop by not calling refreshDownloads)
      loadDownloads();

      // Show success message only when manually called (not from refreshDownloads)
      if (Get.currentRoute.contains('downloads')) {
        Get.snackbar(
          'Duplicates Cleaned',
          'Removed ${duplicatesToDelete.length} duplicate download(s)',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      if (kDebugMode) {
        print('✅ Cleaned ${duplicatesToDelete.length} duplicate downloads');
        print('Duplicates removed by time comparison (year/month/day/minute/second):');
        for (final duplicate in duplicatesToDelete) {
          print('  - ID ${duplicate.id}: ${duplicate.downloadTime}');
        }
      }
    } catch (e) {
      errorMessage.value = 'Error cleaning duplicates: $e';
      if (kDebugMode) {
        print('❌ Error cleaning duplicates: $e');
      }

      // Only show error snackbar when manually called
      if (Get.currentRoute.contains('downloads')) {
        Get.snackbar(
          'Error',
          'Failed to clean duplicates: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
