import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../Models/jsonModels/datas/forfait_model.dart';

import '../../../controllers/database_controller.dart';
import '../../../helpers/myerrorinfo.dart';
import '../aeroports_crud/aeroport_controller.dart';

class ForfaitController extends GetxController {
  //@override
  // void onInit() {
  //   super.onInit();
  //  // DatabaseController.instance.getAllForfaitLists();
  // }

  static ForfaitController instance = Get.find();
  final TextEditingController depController = TextEditingController();
  final TextEditingController arrController = TextEditingController();
  final TextEditingController forfController = TextEditingController();
  final TextEditingController tableController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final Rx<bool> _saison = false.obs;
  bool get saison => _saison.value;

  set saison(bool mySecteur) {
    _saison.value = mySecteur;
  }

  String get sSaison => (_saison.value == false) ? 'Ete' : 'Hiver';

  final Rx<bool> _secteur = false.obs;
  bool get secteur => _secteur.value;
  set secteur(bool mySecteur) {
    _secteur.value = mySecteur;
  }

  String get sSecteur => (_secteur.value == false) ? 'MACHMC' : 'MACHLC';
  final Rx<DateTime> _startDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs; // Start of the current month
  DateTime get startDate => _startDate.value;
  set startDate(DateTime value) => _startDate.value = value;

  final RxList<ForfaitModel> _forfaits = <ForfaitModel>[].obs;
  List<ForfaitModel> get forfaits => _forfaits;
  set forfaits(List<ForfaitModel> val) {
    _forfaits.value = val;
  }

  final Rx<bool> _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool mySecteur) {
    _isLoading.value = mySecteur;
  }

  // ===== Import from Excel (file picker) =====

  DateTime? parseDateFromName(String raw) {
    final name = raw.trim();
    //print('name:$name');
    // 1) Exact yyyyMM
    if (RegExp(r'^\d{6}$').hasMatch(name)) {
      final y = int.tryParse(name.substring(0, 4));
      final m = int.tryParse(name.substring(4, 6));
      if (y != null && m != null && m >= 1 && m <= 12) {
        return DateTime(y, m, 1);
      }
      return null;
    }
    // 2) Extract first yyyyMM occurrence within any filename
    final match = RegExp(r'(20\d{2})(0[1-9]|1[0-2])').firstMatch(name);
    if (match != null) {
      final y = int.tryParse(match.group(1)!);
      final m = int.tryParse(match.group(2)!);
      if (y != null && m != null) {
        return DateTime(y, m, 1);
      }
    }
    return null;
  }

  Future<void> getForfaitFromAllExcelOptimized() async {
    final DateFormat ddMMyyyy = DateFormat('dd/MM/yyyy');
    isLoading = true;

    try {
      final directoryPath = await FilePicker.platform.getDirectoryPath();
      if (directoryPath == null) {
        Get.snackbar('info'.tr, 'Aucun dossier sélectionné');
        return;
      }

      final excelFiles = await Directory(
        directoryPath,
      ).list().where((e) => e is File && e.path.toLowerCase().endsWith('.xlsx')).cast<File>().toList();

      if (excelFiles.isEmpty) {
        MyErrorInfo.erreurInos(
          label: 'ForfaitController getForfaitFromAllExcelOptimized2()',
          content: 'Aucun fichier Excel (.xlsx) trouvé dans ce dossier',
        );
        return;
      }

      final linked = <String, ForfaitModel>{};

      for (final file in excelFiles) {
        try {
          final baseName = file.uri.pathSegments.last.split('.').first;
          final fileDate = parseDateFromName(baseName);
          if (fileDate == null) {
            // print('fileDate null:${file.path}');
            MyErrorInfo.erreurInos(
              label: 'ForfaitController getForfaitFromAllExcelOptimized2()',
              content: 'Le fichier ${file.path} ne respecte pas le format yyyyMM',
            );
            // errorCount++;
            continue;
          }

          final bytes = await file.readAsBytes();
          final parsed = ForfaitModel.parseExcel(bytes);

          // Normalize dateForfait to dd/MM/yyyy (1st day of the month) for DB grouping
          final sDateForfait = ddMMyyyy.format(DateTime(fileDate.year, fileDate.month, 1));
          for (final f in parsed) {
            f.dateForfait = sDateForfait;
            final key = '${f.cle}_${f.dateForfait}'.toUpperCase();
            linked[key] = f.copyWith(id: 0);
          }
          //  successCount++;
        } catch (e) {
          MyErrorInfo.erreurInos(
            label: 'ForfaitController getForfaitFromAllExcelOptimized2()',
            content: 'Erreur lors de la lecture du fichier: ${e.toString()}',
          );
          //errorCount++;
          continue;
        }
      }

      final sortedForfaits = linked.values.toList()..sort((a, b) => a.dateForfait.compareTo(b.dateForfait));

      final forfaitLists = DatabaseController.instance.getForfaitListsFromForfaits(sortedForfaits);
      DatabaseController.instance
        ..clearAllForfaitLists()
        ..addForfaitLists(forfaitLists)
        ..getAllForfaitLists();

      await DatabaseController.instance.exportForfaitsToJson(
        fileName: 'forfaits_${DateFormat('ddMMyyyy').format(DateTime.now())}.json',
      );
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'ForfaitController getForfaitFromAllExcelOptimized2()',
        content: 'Erreur lors de l\'import: ${e.toString()}',
      );
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  // ===== Filter and search forfaits =====

  void getmyLists() async {
    try {
      // Get all forfaits from database
      final allForfaits = DatabaseController.instance.forfaits;
      // final directory = await getApplicationDocumentsDirectory();
      List<String> uniqueKeys = [];
      for (var forfait in allForfaits) {
        // print('${forfait.cle} ${forfait.dateForfait}');
        '==========================================================';

        String key = '${forfait.cle.toUpperCase()}__${forfait.dateForfait.toUpperCase()}';

        if (forfait.depIATA.toUpperCase() == 'CMN'.toUpperCase() &&
            !uniqueKeys.contains(key) &&
            forfait.arrIATA.toUpperCase() == 'ORY'.toUpperCase()) {
          uniqueKeys.add(key);
          // print('${forfait.cle} ${forfait.dateForfait}');
        }
      }
      if (allForfaits.isEmpty) {
        _forfaits.clear();
        Get.snackbar('info'.tr, 'Aucun forfait disponible. Veuillez importer des données.');
        return;
      }

      // Get search criteria
      final String depSearch =
          AerportService.instance.getAeroportByIata(search: depController.text.trim().toUpperCase())?.icao ??
          '';
      final String arrSearch =
          AerportService.instance.getAeroportByIata(search: arrController.text.trim().toUpperCase())?.icao ??
          '';
      final String selectedSaison = sSaison.toUpperCase().trim();
      final String selectedSecteur = sSecteur.toUpperCase().trim();
      final String cleSearch = '$selectedSaison$selectedSecteur$depSearch$arrSearch'.trim();
      // Filter forfaits based on criteria

      List<ForfaitModel> filtered = allForfaits.where((forfait) => forfait.cle.contains(cleSearch)).toList();

      // Sort results
      DateFormat formatter = DateFormat("dd/MM/yyyy");
      filtered.sort((b, a) {
        // If both are equal, compare dateForfait
        try {
          DateTime dateA = formatter.parse(a.dateForfait);
          DateTime dateB = formatter.parse(b.dateForfait);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

      // Update the observable list
      _forfaits.value = filtered;

      // Show result message
      if (filtered.isEmpty) {
        Get.snackbar('info'.tr, 'Aucun forfait trouvé pour ces critères');
      } else {
        Get.snackbar('success'.tr, '${filtered.length} forfait(s) trouvé(s)');
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'Erreur lors de la recherche: $e');
      _forfaits.clear();
    }
  }

  // Future<void> getForfaitFromAllExcel() async {
  //   DateFormat dateFormat = DateFormat('yyyyMM');
  //   // DateTime now = DateTime.now();
  //   // print('now:${dateFormat.format(now)}');
  //   try {
  //     isLoading = true;
  //     // Step 1: Select directory
  //     String? directoryPath = await FilePicker.platform.getDirectoryPath();

  //     if (directoryPath == null) {
  //       Get.snackbar('info'.tr, 'Aucun dossier sélectionné');
  //       isLoading = false;
  //       return;
  //     }

  //     // Step 2: List all .xlsx files in directory
  //     final Directory directory = Directory(directoryPath);
  //     final List<FileSystemEntity> files = directory.listSync();

  //     final List<File> excelFiles = files
  //         .whereType<File>()
  //         .where((file) => file.path.toLowerCase().endsWith('.xlsx'))
  //         .toList();

  //     if (excelFiles.isEmpty) {
  //       MyErrorInfo.erreurInos(
  //         label: 'ForfaitController getForfaitFromAllExcel()',
  //         content: 'Aucun fichier Excel (.xlsx) trouvé dans ce dossier',
  //       );
  //       isLoading = false;
  //       return;
  //     }

  //     // Get.snackbar('info'.tr, '${excelFiles.length} fichier(s) Excel trouvé(s). Import en cours...');

  //     // Step 3: Process each Excel file
  //     List<ForfaitModel> allForfaits = [];
  //     List<ForfaitListModel> allForfaitLists = [];
  //     int successCount = 0;
  //     int errorCount = 0;

  //     for (File excelFile in excelFiles) {
  //       // print('======================================================');
  //       // print('excelFile:${excelFile.path}');
  //       // print('---------------------------------------------------------');

  //       try {
  //         String fileName = excelFile.path.split('/').last.split('.').first;
  //         DateTime? fileDate = dateFormat.tryParse(fileName.trim());
  //         if (fileDate == null) {
  //           MyErrorInfo.erreurInos(
  //             label: 'ForfaitController getForfaitFromAllExcel()',
  //             content: 'le nom de fichier ne respecte pas format attendu',
  //           );
  //           errorCount++;
  //           continue;
  //         }

  //         // Read Excel file

  //         ForfaitListModel? forfaitList = await ForfaitListModel.getForfaitListFromExcel(
  //           excelFile,
  //           dateFormat,
  //         );
  //         if (forfaitList == null) {
  //           MyErrorInfo.erreurInos(
  //             label: 'ForfaitController getForfaitFromAllExcel()',
  //             content: 'Error during getting forfaitList',
  //           );
  //           continue;
  //         }

  //         int index = allForfaitLists.indexWhere((e) => e.date.isAtSameMomentAs(forfaitList.date));
  //         if (index == -1) {
  //           allForfaitLists.add(forfaitList);
  //         } else {
  //           allForfaitLists[index] = forfaitList;
  //         }

  //         // print('successCount forfaitsFromFile:$fileName');
  //         successCount++;
  //       } catch (e) {
  //         //print('catch excelFile:${e.toString()}');
  //         MyErrorInfo.erreurInos(
  //           label: 'ForfaitController getForfaitFromAllExcel()',
  //           content: 'Error :${e.toString()}',
  //         );
  //         errorCount++;
  //         continue;
  //       }
  //     }

  //     // if (allForfaits.isEmpty) {
  //     //   Get.snackbar('error'.tr, 'Aucun forfait valide trouvé dans les fichiers');
  //     //   isLoading = false;
  //     //   return;
  //     // }

  //     // Step 4: Sort and remove duplicates
  //     List<ForfaitModel> sortedForfaits = []; //sortForfaits(forfaits: allForfaits);
  //     List<String> uniqueKeys = [];
  //     for (var forfait in allForfaits) {
  //       // print('${forfait.cle} ${forfait.dateForfait}');
  //       //  '==========================================================';
  //       String key = '${forfait.cle.toUpperCase()}_${forfait.dateForfait.toUpperCase()}';
  //       if (!uniqueKeys.contains(key)) {
  //         uniqueKeys.add(key);
  //         sortedForfaits.add(forfait.copyWith(id: 0));
  //         // print('${forfait.cle} ${forfait.dateForfait}');
  //       }
  //     }
  //     // Step 5: Save to database
  //     List<ForfaitListModel> forfaitLists = DatabaseController.instance.getForfaitListsFromForfaits(
  //       sortedForfaits,
  //     );
  //     // Save all forfait lists
  //     DatabaseController.instance.clearAllForfaitLists();
  //     DatabaseController.instance.addForfaitLists(forfaitLists);
  //     // Step 6: Refresh local data
  //     DatabaseController.instance.getAllForfaitLists();
  //     //DatabaseController.instance.getAllForfaitLists();

  //     // Step 7: Export to JSON for backup
  //     DatabaseController.instance.exportForfaitsToJson(
  //       fileName: 'forfaits_${DateFormat('ddMMyyyy').format(DateTime.now())}.json',
  //     );
  //     // Show success message
  //     Get.snackbar(
  //       'success'.tr,
  //       '$successCount fichier(s) importé(s) avec succès\n'
  //       '${sortedForfaits.length} forfaits au total\n'
  //       '${allForfaitLists.length} liste(s) créée(s)'
  //       '${errorCount > 0 ? '\n$errorCount erreur(s)' : ''}',
  //       duration: const Duration(seconds: 5),
  //     );

  //     isLoading = false;
  //   } catch (e) {
  //     // Get.snackbar('error'.tr, 'Erreur lors de l\'import: $e');
  //     MyErrorInfo.erreurInos(
  //       label: 'ForfaitController getForfaitFromAllExcel()',
  //       content: 'Erreur lors de l\'import: :${e.toString()}',
  //     );
  //     isLoading = false;
  //     rethrow;
  //   }
  // }
}
