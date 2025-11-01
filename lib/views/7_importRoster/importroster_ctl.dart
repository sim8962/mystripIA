import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../Models/ActsModels/typ_const.dart';
import '../../Models/VolsModels/vol.dart';

import '../../Models/volpdfs/chechplatform.dart';
import '../../controllers/database_controller.dart';
import '../../helpers/constants.dart';
import '../../helpers/myerrorinfo.dart';
import '../../Models/volpdfs/vol_pdf.dart';
import '../../Models/volpdfs/vol_pdf_list.dart';
import '../../Models/stringvols/svolmodel.dart';
import '../../Models/stringvols/stringvolmois.dart';

class ImportrosterCtl extends GetxController {
  static ImportrosterCtl instance = Get.find();

  // Constants
  static const String _pdfExtension = 'pdf';
  static const String _rosterFolder = 'rosters';
  static const Duration _processingDelay = Duration(milliseconds: 400);
  static const int _dayThreshold = 22;
  static const String _blockMarker = 'Block';
  static const String _periodMarker = 'Period:';
  static const String _dateFormat = 'MMMM yyyy';
  static const String _dateFormatFull = 'd MMMM yyyy';
  static const String _dateFormatDisplay = 'dd/MM/yyyy HH:mm';
  static const String _timeFormat = 'HH:mm';
  static const String _defaultBase = 'CMN';
  static const String _defaultStartTime = '00:01';
  static const String _defaultEndTime = '23:59';
  static const String _hotelDuty = 'HTL';
  static const String _activityPrefix = 'AT';

  List<PlatformFile> platformFiles = [];
  final RxBool _loading = false.obs;
  final RxInt _etape = 0.obs;

  bool get loading => _loading.value;
  set loading(bool value) => _loading.value = value;

  int get etape => _etape.value;
  set etape(int value) => _etape.value = value;

  // ============================================================================
  // ETAPE 0 : Selection des fichiers PDF
  // ============================================================================

  /// Ouvre le sélecteur de fichiers et retourne les fichiers PDF sélectionnés
  Future<List<PlatformFile>> getPlatformFile() async {
    // final dir = await FilePicker.platform.getDirectoryPath();
    // print(dir);
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [_pdfExtension],
    );

    if (result == null || result.files.isEmpty) return [];

    loading = true;

    final selectedFiles = result.files.where((file) => file.name.contains(_pdfExtension)).toList();
    etape = 1;
    return selectedFiles;
  }

  // ============================================================================
  // ETAPE 1 : Traitement et extraction des données des fichiers PDF
  // ============================================================================

  List<ChechPlatFormMonth> myList = [];
  List<VolPdfList> volPdfLists = [];
  // String versions computed from final VolModels
  final RxList<StringVolModel> stringVolModels = <StringVolModel>[].obs;
  final RxList<StringVolModelMois> stringVolMois = <StringVolModelMois>[].obs;

  /// Stream qui traite les fichiers PDF sélectionnés et retourne les mois extraits
  Stream<List<ChechPlatFormMonth>> getStreamPlatformFile() async* {
    myList = [];
    volPdfLists = [];
    final rosterPath = await _createRosterFolder();
    for (var file in platformFiles) {
      //on extrait les strips des les  fichiers
      await _processRosterFile(file: file, path: '$rosterPath/${tRoster.typ}_');

      await Future.delayed(_processingDelay);
      myList = myList.toSet().toList();
      yield myList;
    }
  }

  /// Crée le dossier de destination pour les fichiers rosters
  Future<String> _createRosterFolder() async {
    final appStorage = await getApplicationDocumentsDirectory();
    final Directory folder = Directory('${appStorage.path}/$_rosterFolder'.trim());

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return '${appStorage.path}/$_rosterFolder';
  }
  // ============================================================================
  /// Traite un fichier PDF roster et extrait les données mensuelles
  // ============================================================================

  Future<void> _processRosterFile({required PlatformFile file, required String path}) async {
    final filePath = file.path;
    if (filePath == null) return;

    try {
      final PdfDocument document = PdfDocument(inputBytes: File(filePath).readAsBytesSync());
      final textBlock = PdfTextExtractor(document).findText([_blockMarker]);

      if (textBlock.isEmpty) return;

      final pageCount = textBlock[0].pageIndex;

      for (var pageIndex = 0; pageIndex <= pageCount; pageIndex++) {
        try {
          final extractor = PdfTextExtractor(document);
          final textLines = extractor.extractTextLines(startPageIndex: pageIndex);
          final periods = PdfTextExtractor(document).findText([_periodMarker]);

          await _processRosterFileExtractMonthDataFromPage(
            textLines: textLines,
            periods: periods,
            file: file,
            filePath: filePath,
            path: path,
          );
        } catch (e) {
          MyErrorInfo.erreurInos(
            label: 'ImportrosterCtl',
            content: '_processRosterFile page $pageIndex: ${e.toString()}',
          );
        }
      }
      document.dispose();
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'ImportrosterCtl', content: '_processRosterFile: ${e.toString()}');
    }
  }

  /// Extrait les données du mois depuis la première page du PDF
  Future<void> _processRosterFileExtractMonthDataFromPage({
    required List<TextLine> textLines,
    required List<MatchedItem> periods,
    required PlatformFile file,
    required String filePath,
    required String path,
  }) async {
    final monthText = _extractMonthText(textLines: textLines, periods: periods).trim();
    if (monthText.isEmpty) {
      return;
    }
    final monthDate = DateFormat(_dateFormat).parse(monthText);
    final monthStr = monthDate.month.toString().padLeft(2, '0');
    final yearStr = monthDate.year.toString();
    final copiedFile = await File(filePath).copy('$path$yearStr$monthStr.pdf');

    final rosterMonth = ChechPlatFormMonth(
      title: monthText,
      datefile: monthDate,
      file: copiedFile,
      filePlat: file,
    );

    final myVolPdfs = _extractVolumesFromRoster(myPlatformBox: rosterMonth);
    final tags = myVolPdfs.isNotEmpty ? myVolPdfs.first.tags : '';
    final myVolPdfList = VolPdfList(month: monthDate, tags: tags, path: copiedFile.path);
    myVolPdfList.volPdfs.addAll(myVolPdfs);

    if (!myList.contains(rosterMonth)) {
      myList.add(rosterMonth);
    }
    myList.sort((a, b) => b.datefile.millisecondsSinceEpoch.compareTo(a.datefile.millisecondsSinceEpoch));
    volPdfLists.add(myVolPdfList);
    
  }

  /// Extrait le texte du mois depuis les lignes de texte du PDF
  String _extractMonthText({required List<TextLine> textLines, required List<MatchedItem> periods}) {
    var monthText = '';
    if (periods.isEmpty) {
      return monthText;
    }
    for (int i = 0; i < textLines.length; i++) {
      List<TextWord> wordCollection = textLines[i].wordCollection;
      for (int j = 0; j < wordCollection.length; j++) {
        if (periods[0].bounds.top.round() == wordCollection[j].bounds.top.round() &&
            periods[0].bounds.left.round() < wordCollection[j].bounds.left.round()) {
          if (wordCollection[j].text.trim().isNotEmpty) {
            monthText += '${wordCollection[j].text} ';
          }
        }
      }
    }
    return monthText;
  }

  /// Extrait et traite tous les volumes (vols) d'un fichier roster
  List<VolPdf> _extractVolumesFromRoster({required ChechPlatFormMonth myPlatformBox}) {
    List<VolPdf> mesVolPdfs = _parseRosterPdfTable(myPlatformBox);
    _cleanupVolumeList(mesVolPdfs);
    _assignVolumeDuties(mesVolPdfs);
    _calculateVolumeDates(mesVolPdfs);

    final monthDate = DateFormat(_dateFormat).parse(myPlatformBox.title);
    final filteredVolumes = mesVolPdfs
        .where((vol) => (vol.dateVol.year == monthDate.year && vol.dateVol.month == monthDate.month))
        .toSet()
        .toList();

    return filteredVolumes;
  }

  // ============================================================================
  // Fonctions utilitaires pour l'extraction des données du tableau PDF
  // ============================================================================

  static const List<String> _pdfTableHeaders = [
    'Date',
    'Report',
    'Tags',
    'Pos',
    'Activity',
    'From',
    'To',
    'Start',
    'End',
    'A/C',
    'Layover',
  ];

  /// Parse le tableau des vols depuis le fichier PDF roster
  List<VolPdf> _parseRosterPdfTable(ChechPlatFormMonth rosterMonth) {
    var monthText = '';
    final pdfFile = rosterMonth.file;
    List<VolPdf> volumes = [];

    final PdfDocument document = PdfDocument(inputBytes: pdfFile.readAsBytesSync());
    final textBlock = PdfTextExtractor(document).findText([_blockMarker]);
    if (textBlock.isEmpty) {
      document.dispose();
      return volumes;
    }

    final pageCount = textBlock[0].pageIndex;
    final blockLinePosition = textBlock[0].bounds.top.round();

    for (var pageIndex = 0; pageIndex <= pageCount; pageIndex++) {
      final extractor = PdfTextExtractor(document);
      final textLines = extractor.extractTextLines(startPageIndex: pageIndex);
      final periods = PdfTextExtractor(document).findText([_periodMarker]);

      if (pageIndex == 0) {
        monthText = _extractMonthText(textLines: textLines, periods: periods);
      }

      final blcTags = _extractBlcTags(textLines);
      final tableBounds = _calculateTableBounds(
        textLines: textLines,
        document: document,
        pageIndex: pageIndex,
        blockLinePosition: blockLinePosition,
        pageCount: pageCount,
      );

      volumes.addAll(
        _extractVolumesFromTableBounds(
          textLines: textLines,
          bounds: tableBounds,
          monthText: monthText,
          blcTags: blcTags,
        ),
      );
    }

    document.dispose();
    return volumes;
  }

  /// Extrait les tags BLC du texte du PDF
  List<String> _extractBlcTags(List<TextLine> textLines) {
    List<String> blcTags = [];
    for (var line in textLines) {
      if (line.text.contains('BLC:')) {
        String s = line.text.replaceAll('in period', ',');
        if (s.split(',').length > 2) {
          String s1 = s.split(',')[0].split('hours:').last.trim().replaceAll(':', 'h');
          String s2 = s.split(',')[1].split('BLC:').last.trim().replaceAll(':', 'h');
          String s3 = s.split(',')[2].trim().replaceAll(RegExp(r'[()]'), '');
          blcTags.add('BH $s1/BLC $s2/ date $s3');
        }
      }
    }
    return blcTags;
  }

  /// Calcule les limites du tableau (colonnes et lignes)
  List<List<int>> _calculateTableBounds({
    required List<TextLine> textLines,
    required PdfDocument document,
    required int pageIndex,
    required int blockLinePosition,
    required int pageCount,
  }) {
    List<int> columnBounds = [];
    List<int> rowBounds = [];

    final dateBlock = PdfTextExtractor(document).findText(['Date'], startPageIndex: pageIndex);
    if (dateBlock.isEmpty) {
      return [columnBounds, rowBounds];
    }
    final dateLinePosition = dateBlock[0].bounds.top.round();

    for (var line in textLines) {
      for (var word in line.wordCollection) {
        if (_pdfTableHeaders.contains(word.text)) {
          final leftPos = word.bounds.left.round();
          if (!columnBounds.contains(leftPos)) {
            columnBounds.add(leftPos);
          }
        }

        if (!rowBounds.contains(word.bounds.top.round()) &&
            !rowBounds.contains(word.bounds.top.round() + 1)) {
          if (pageIndex == pageCount) {
            if (dateLinePosition < word.bounds.top.round() && word.bounds.top.round() < blockLinePosition) {
              rowBounds.add(word.bounds.top.round());
            }
          } else {
            if (dateLinePosition < word.bounds.top.round()) {
              rowBounds.add(word.bounds.top.round());
            }
          }
        }
      }
    }

    return [columnBounds, rowBounds];
  }

  /// Extrait les volumes à partir des limites du tableau
  List<VolPdf> _extractVolumesFromTableBounds({
    required List<TextLine> textLines,
    required List<List<int>> bounds,
    required String monthText,
    required List<String> blcTags,
  }) {
    List<VolPdf> volumes = [];
    final columnBounds = bounds[0];
    final rowBounds = bounds[1];

    for (int rowIndex = 0; rowIndex < rowBounds.length; rowIndex++) {
      final volume = VolPdf();
      var columnCounter = 0;

      for (int colIndex = 0; colIndex < columnBounds.length; colIndex++) {
        for (var line in textLines) {
          for (var word in line.wordCollection) {
            final wordTop = word.bounds.top.round();
            final wordLeft = word.bounds.left.round();
            final rowTop = rowBounds[rowIndex];

            if ((rowTop - wordTop).abs() < 10) {
              if (colIndex != 0) {
                columnCounter = 0;
              }

              if (colIndex < columnBounds.length - 1) {
                if (columnBounds[colIndex] <= wordLeft && wordLeft < columnBounds[colIndex + 1]) {
                  if (colIndex == 0) {
                    columnCounter++;
                  }
                  _assignVolumeFieldByColumn(volume, colIndex, word.text.trim(), columnCounter);
                }
              } else {
                if (columnBounds[colIndex] <= wordLeft) {
                  volume.layover = word.text.trim();
                }
              }
            }
          }
        }
      }

      volume.month = monthText;
      if (blcTags.isNotEmpty) {
        volume.tags = blcTags.first;
      }
      volumes.add(volume);
    }

    return volumes;
  }

  /// Assigne la valeur du mot au champ approprié du volume selon la colonne
  void _assignVolumeFieldByColumn(VolPdf volume, int columnIndex, String value, int counter) {
    switch (columnIndex) {
      case 0:
        if (counter == 1) {
          volume.datej = value;
        } else if (counter == 3) {
          volume.dateM = value;
        }
        break;
      case 1:
        volume.report = value;
        break;
      case 3:
        volume.pos = value;
        break;
      case 4:
        volume.activity = value;
        break;
      case 5:
        volume.from = value;
        break;
      case 6:
        volume.to = value;
        break;
      case 7:
        volume.start = value;
        break;
      case 8:
        volume.end = value;
        break;
      case 9:
        volume.aC = value;
        break;
    }
  }

  /// Nettoie et corrige la liste des volumes
  void _cleanupVolumeList(List<VolPdf> volumes) {
    // Remove volumes with empty activity
    volumes.removeWhere((vol) => vol.activity.trim().isEmpty);

    // Merge continuation rows and fix missing destinations
    for (var i = 1; i < volumes.length; i++) {
      final current = volumes[i];
      final previous = volumes[i - 1];

      if (current.from.trim().isEmpty &&
          current.to.trim().isNotEmpty &&
          current.start.trim().isEmpty &&
          current.activity.trim().isNotEmpty) {
        previous.to = current.to.trim();
        previous.end = current.end.trim();
        previous.aC = current.aC.trim();
        previous.layover = current.layover.trim();
        volumes.removeAt(i);
        i--;
      } else if (current.to.trim().isEmpty &&
          current.start.trim().isNotEmpty &&
          current.activity.trim().isNotEmpty) {
        current.to = current.from.trim();
      }
    }

    // Set default base for volumes without origin/destination
    for (var vol in volumes) {
      if (vol.activity.trim().isNotEmpty && vol.from.isEmpty && vol.to.isEmpty) {
        vol.start = _defaultStartTime;
        vol.end = _defaultEndTime;
        vol.from = _defaultBase;
        vol.to = _defaultBase;
      }
    }
  }

  /// Assigne les types de service (duty) à chaque volume
  void _assignVolumeDuties(List<VolPdf> volumes) {
    for (var volume in volumes) {
      final activity = volume.activity.trim();
      if (int.tryParse(activity) == null) {
        volume.duty = _mapActivityToDuty(activity);
      } else {
        volume.activity = '$_activityPrefix${volume.activity}';
        volume.duty = tVol.typ;
        if (volume.pos.trim() == 'DH') volume.duty = tMEP.typ;
      }
    }
  }

  /// Mappe une activité à son type de service
  String _mapActivityToDuty(String activity) {
    if (activity == 'CA' || activity == 'CRE') return tConge.typ;
    if (activity.startsWith('RV')) return tRV.typ;
    if (activity.startsWith('CNL')) return tCNL.typ;
    if (activity.startsWith('TAX')) return tMEP.typ;
    if (activity.startsWith('CM')) return tCM.typ;
    if (activity.startsWith(_hotelDuty)) return tHTL.typ;
    return tDuty.typ;
  }

  /// Calcule les dates et heures pour chaque volume
  void _calculateVolumeDates(List<VolPdf> volumes) {
    if (volumes.isEmpty) return;

    final monthText = volumes[0].month;
    final monthStart = DateFormat(_dateFormatFull).parse('01 $monthText');
    final monthEnd = DateTime(
      monthStart.year,
      monthStart.month + 1,
      monthStart.day,
    ).subtract(const Duration(minutes: 1));

    DateTime transitDate = monthStart;
    for (var i = 0; i < volumes.length; i++) {
      final vol = volumes[i];

      // Update transit date based on day field
      if (vol.datej.isNotEmpty) {
        final day = int.parse(vol.datej);
        transitDate = _computeTransitDate(day, i, transitDate, monthStart, volumes);
      }

      // Set time from report or start time
      if (vol.start.trim().isNotEmpty) {
        final timeStr = vol.report.trim().isNotEmpty ? vol.report.trim() : vol.start.trim();
        final timeParts = timeStr.split(':');
        transitDate = DateTime(
          transitDate.year,
          transitDate.month,
          transitDate.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      }

      vol.dateVol = transitDate;
      vol.myChInDate = DateFormat(
        _dateFormatDisplay,
      ).format(_adjustTimeToNextIfBefore(vol.report.trim(), transitDate));
      transitDate = _adjustTimeToNextIfBefore(vol.report.trim(), transitDate);

      vol.myDepDate = DateFormat(
        _dateFormatDisplay,
      ).format(_adjustTimeToNextIfBefore(vol.start.trim(), transitDate));
      transitDate = _adjustTimeToNextIfBefore(vol.start.trim(), transitDate);

      vol.myArrDate = DateFormat(
        _dateFormatDisplay,
      ).format(_adjustTimeToNextIfBefore(vol.end.trim(), transitDate));
      transitDate = _adjustTimeToNextIfBefore(vol.end.trim(), transitDate);

      // Handle layover as hotel duty
      if (vol.layover.contains(':')) {
        final hotelVol = _createHotelVolume(vol, transitDate);
        volumes.insert(i + 1, hotelVol);
        transitDate = transitDate.add(
          Duration(
            hours: int.parse(vol.layover.split(':')[0]),
            minutes: int.parse(vol.layover.split(':')[1]),
          ),
        );
        i++;
      }
    }

    volumes.removeWhere((vol) => vol.dateVol.isBefore(monthStart) || vol.dateVol.isAfter(monthEnd));
  }

  /// Calcule la date de transit pour un volume donné
  DateTime _computeTransitDate(
    int day,
    int index,
    DateTime transitDate,
    DateTime monthStart,
    List<VolPdf> volumes,
  ) {
    if (index == 0) {
      if (day == 31) {
        return DateTime(monthStart.year, monthStart.month - 1, day, transitDate.hour, transitDate.minute);
      } else {
        var newDate = DateTime(
          transitDate.year,
          transitDate.month,
          day,
          transitDate.hour,
          transitDate.minute,
        );
        if (monthStart.isBefore(newDate) && day > _dayThreshold) {
          newDate = _subtractMonth(newDate);
        }
        return newDate;
      }
    } else {
      var newDate = DateTime(transitDate.year, transitDate.month, day, transitDate.hour, transitDate.minute);
      if (newDate.isBefore(volumes[index - 1].dateVol)) {
        if (newDate.month == volumes[index - 1].dateVol.month) {
          newDate = _addMonth(newDate);
        } else {
          newDate = _addDay(newDate);
        }
      }
      return newDate;
    }
  }

  /// Crée un volume hôtel pour une escale
  VolPdf _createHotelVolume(VolPdf vol, DateTime transitDate) {
    final hotelVol = VolPdf();
    hotelVol.month = vol.month;
    hotelVol.dateVol = transitDate;
    hotelVol.duty = _hotelDuty;
    hotelVol.myDepDate = DateFormat(_dateFormatDisplay).format(transitDate);
    hotelVol.start = DateFormat(_timeFormat).format(transitDate);

    final layoverParts = vol.layover.split(':');
    final endTime = transitDate.add(
      Duration(hours: int.parse(layoverParts[0]), minutes: int.parse(layoverParts[1])),
    );
    hotelVol.myArrDate = DateFormat(_dateFormatDisplay).format(endTime);
    hotelVol.end = DateFormat(_timeFormat).format(endTime);
    hotelVol.activity = _hotelDuty;
    hotelVol.from = vol.to;
    hotelVol.to = vol.to;
    hotelVol.report = '';

    return hotelVol;
  }

  /// Ajuste l'heure au jour suivant si elle est antérieure à la date actuelle
  DateTime _adjustTimeToNextIfBefore(String timeStr, DateTime transitDate) {
    DateTime myDate = transitDate;
    if (timeStr.isNotEmpty) {
      myDate = DateTime(
        transitDate.year,
        transitDate.month,
        transitDate.day,
        int.parse(timeStr.trim().split(':').first),
        int.parse(timeStr.trim().split(':').last),
      );
      if (myDate.isBefore(transitDate)) {
        myDate = myDate.add(const Duration(days: 1));
      }
    }
    return myDate;
  }

  /// Soustrait un mois d'une date
  DateTime _subtractMonth(DateTime date) =>
      DateTime(date.year, date.month - 1, date.day, date.hour, date.minute);

  /// Ajoute un jour à une date
  DateTime _addDay(DateTime date) => DateTime(date.year, date.month, date.day + 1, date.hour, date.minute);

  /// Ajoute un mois à une date
  DateTime _addMonth(DateTime date) => DateTime(date.year, date.month + 1, date.day, date.hour, date.minute);

  // ============================================================================
  // ETAPE 2 : Conversion des VolPdf en VolModel
  // ============================================================================

  /// Convertit les VolPdf extraits des PDFs en VolModel pour la base de données
  /// Retourne une liste de VolModel prêts à être stockés dans ObjectBox
  /// Les champs manquants (from, to, activity) sont acceptés et traités ultérieurement
  List<VolModel> getvolTraitesFromVolpdfs() {
    List<VolModel> volModels = [];

    try {
      // Parcourir tous les VolPdfList extraits
      for (var volPdfList in volPdfLists) {
        // Parcourir tous les VolPdf de chaque liste
        for (var volPdf in volPdfList.volPdfs) {
          try {
            final dtDebut = dateFormatDDHH.tryParse(volPdf.myDepDate);

            final dtFin = dateFormatDDHH.tryParse(volPdf.myArrDate);
            if (dtFin != null && dtDebut != null) {
              final volModel = VolModel.fromVolPdf(volPdf);

              volModels.add(volModel);
            }
          } catch (e) {
            // Logger l'erreur mais continuer le traitement
            MyErrorInfo.erreurInos(
              label: 'ImportrosterCtl',
              content: 'Erreur conversion VolPdf: ${e.toString()}',
            );
            continue;
          }
        }
      }

      // Supprimer les doublons basés sur la clé unique
      final uniqueVols = <String, VolModel>{};
      for (var vol in volModels) {
        uniqueVols[vol.cle] = vol;
      }
      volModels = uniqueVols.values.toList();

      // Trier par date de départ
      volModels.sort((a, b) => a.dtDebut.compareTo(b.dtDebut));
      return volModels;
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'ImportrosterCtl', content: 'getvolTraitesFromVolpdfs: ${e.toString()}');
      return [];
    }
  }

  /// Sauvegarde les VolPdfList nouveaux puis calcule les listes StringVolModel et StringVolModelMois
  void saveVolpdfsList() {
    try {
      // 1) Persister seulement les VolPdfList nouveaux (par mois)
      DatabaseController.instance.getAllVolPdfLists();
      final existingMonthKeys = DatabaseController.instance.volPdfLists
          .map((e) => '${e.month.year}-${e.month.month.toString().padLeft(2, '0')}')
          .toSet();

      final List<VolPdfList> toAdd = [];
      for (final v in volPdfLists) {
        final key = '${v.month.year}-${v.month.month.toString().padLeft(2, '0')}';
        if (!existingMonthKeys.contains(key)) {
          toAdd.add(v);
        }
      }
      if (toAdd.isNotEmpty) {
        DatabaseController.instance.addVolPdfLists(toAdd);
      }

      // 2) Construire StringVolModel et StringVolModelMois à partir des vols finaux
      final volModels = getvolTraitesFromVolpdfs();
      final Map<String, List<VolModel>> byMonth = {};
      for (final v in volModels) {
        final key = '${v.dtDebut.year}-${v.dtDebut.month.toString().padLeft(2, '0')}';
        byMonth.putIfAbsent(key, () => <VolModel>[]).add(v);
      }

      final List<StringVolModel> sVols = [];
      for (final entry in byMonth.entries) {
        final monthVols = entry.value..sort((a, b) => a.dtDebut.compareTo(b.dtDebut));
        for (final v in monthVols) {
          sVols.add(StringVolModel.withMonthlyCumuls(v, monthVols));
        }
      }
      final Map<String, StringVolModel> unique = {for (final sv in sVols) sv.cle: sv};
      final finalSVols = unique.values.toList()
        ..sort((a, b) {
          final ad = dateFormatDDHH.tryParse(a.sDebut) ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bd = dateFormatDDHH.tryParse(b.sDebut) ?? DateTime.fromMillisecondsSinceEpoch(0);
          return ad.compareTo(bd);
        });
      stringVolModels.assignAll(finalSVols);

      final months = StringVolModelMois.fromStringVols(finalSVols);
      stringVolMois.assignAll(months);
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'ImportrosterCtl', content: 'saveVolpdfsList: ${e.toString()}');
    }
  }

  /// Parse les tags BLC depuis une chaîne de caractères
  List<String> _parseBlcTagsFromString(String tagsString) {
    if (tagsString.isEmpty) return [];

    final tags = tagsString
        .split(RegExp(r'[,;]'))
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty && tag.contains('BH'))
        .toList();

    return tags;
  }

  /// Récupère les tags BLC groupés par mois (format YYYY-MM)
  Map<String, List<String>> getBlcTagsByMonth() {
    final Map<String, List<String>> blcByMonth = {};

    for (var volPdfList in volPdfLists) {
      final monthRef = '${volPdfList.month.year}-${volPdfList.month.month.toString().padLeft(2, '0')}';

      if (!blcByMonth.containsKey(monthRef)) {
        blcByMonth[monthRef] = [];
      }

      if (volPdfList.tags.isNotEmpty) {
        final blcTagsList = _parseBlcTagsFromString(volPdfList.tags);
        blcByMonth[monthRef]!.addAll(blcTagsList);
      }
    }

    return blcByMonth;
  }

  /// Récupère les tags BLC pour un mois spécifique (format YYYY-MM)
  List<String> getBlcTagsForMonth(String moisReference) {
    try {
      final parts = moisReference.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      final volPdfList = volPdfLists.firstWhere((v) => v.month.year == year && v.month.month == month);

      if (volPdfList.tags.isEmpty) return [];
      return _parseBlcTagsFromString(volPdfList.tags);
    } catch (e) {
      return [];
    }
  }
}
