import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../Models/ActsModels/typ_const.dart';
import '../../Models/volpdfs/chechplatform.dart';
import '../../Models/volpdfs/vol_pdf.dart';

class OutilImportController extends GetxController {
  static OutilImportController instance = Get.find();

  final titres = [
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

  String getMonth({required List<TextLine> result, required List<MatchedItem> myPeriods}) {
    var ch = '';
    if (myPeriods.isEmpty) return ch;
    for (int i = 0; i < result.length; i++) {
      List<TextWord> wordCollection = result[i].wordCollection;
      for (int j = 0; j < wordCollection.length; j++) {
        if (myPeriods[0].bounds.top.round() == wordCollection[j].bounds.top.round() &&
            myPeriods[0].bounds.left.round() < wordCollection[j].bounds.left.round()) {
          if (wordCollection[j].text.trim().isNotEmpty) {
            ch += '${wordCollection[j].text} ';
          }
        }
      }
    }
    return ch;
  }

  List<VolPdf> getVoltraiteOnePdf({required ChechPlatFormMonth myPlatformBox}) {
    List<VolPdf> meslistVols = getRostersVolsPdfs(myPlatformBox);
    //print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    correctListVols(meslistVols);

    getVolPdfDuty(meslistVols);

    getAllDatesVols(meslistVols);
    // print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    // for (var e in meslistVols) {
    //   print('apres getVolPdfDuty:${e.toString()}');
    // }
    DateTime dt = DateFormat('MMMM yyyy').parse(myPlatformBox.title);

    List<VolPdf> monthlistVols = meslistVols
        .where((volPdfB) => (volPdfB.dateVol.year == dt.year && volPdfB.dateVol.month == dt.month))
        .toSet()
        .toList();

    // print('================================ PdfController ${dt.year}-${dt.month}==========================');
    return monthlistVols;
  }

  List<List<int>> getBounds({
    required PdfDocument document,
    required int p,
    required int myLignBlock,
    required int nbreDePage,
  }) {
    List<int> myTopBounds = [];
    List<int> myLeftBound = [];
    PdfTextExtractor extractor = PdfTextExtractor(document);
    List<TextLine> result = extractor.extractTextLines(startPageIndex: p);

    List<MatchedItem> dateBlock = PdfTextExtractor(document).findText(['Date'], startPageIndex: p);
    if (dateBlock.isEmpty) return [myLeftBound, myTopBounds];
    var myLignDate = dateBlock[0].bounds.top.round();

    for (int i = 0; i < result.length; i++) {
      List<TextWord> wordCollection = result[i].wordCollection;
      for (var m = 0; m < titres.length; m++) {
        for (int j = 0; j < wordCollection.length; j++) {
          if (titres[m] == wordCollection[j].text &&
              !myLeftBound.contains(wordCollection[j].bounds.left.round())) {
            myLeftBound.add(wordCollection[j].bounds.left.round());
          }
          if (!myTopBounds.contains(wordCollection[j].bounds.top.round()) &&
              !myTopBounds.contains(wordCollection[j].bounds.top.round() + 1)) {
            if (p == nbreDePage) {
              if (myLignDate < wordCollection[j].bounds.top.round() &&
                  wordCollection[j].bounds.top.round() < myLignBlock) {
                myTopBounds.add(wordCollection[j].bounds.top.round());
              }
            } else {
              if (myLignDate < wordCollection[j].bounds.top.round()) {
                myTopBounds.add(wordCollection[j].bounds.top.round());
              }
            }
          }
        }
      }
    }

    return [myLeftBound, myTopBounds];
  }

  List<VolPdf> getRostersVolsPdfs(ChechPlatFormMonth chechPlatFormMonth) {
    var ch = '';
    final myFile = chechPlatFormMonth.file;
    List<VolPdf> mesVols = [];

    final PdfDocument document = PdfDocument(inputBytes: myFile.readAsBytesSync());

    List<MatchedItem> textBlock = PdfTextExtractor(document).findText(['Block']);
    if (textBlock.isEmpty) {
      document.dispose();
      return mesVols;
    }

    var nbreDePage = textBlock[0].pageIndex;
    var myLignBlock = textBlock[0].bounds.top.round();

    for (var p = 0; p < nbreDePage + 1; p++) {
      PdfTextExtractor extractor = PdfTextExtractor(document);
      List<TextLine> result = extractor.extractTextLines(startPageIndex: p);

      List<MatchedItem> myPeriods = PdfTextExtractor(document).findText(['Period:']);
      if (p == 0) {
        ch = getMonth(result: result, myPeriods: myPeriods);
      }
      List<String> myBlcs = [];
      //List<MatchedItem> myBlcs = PdfTextExtractor(document).findText(['BLC:']);
      for (var myBlc in result) {
        if (myBlc.text.contains('BLC:')) {
          String s = myBlc.text.replaceAll('in period', ',');
          if (s.split(',').length > 2) {
            String s1 = s.split(',')[0].split('hours:').last.trim().replaceAll(':', 'h');
            String s2 = s.split(',')[1].split('BLC:').last.trim().replaceAll(':', 'h');
            String s3 = s.split(',')[2].trim().replaceAll(RegExp(r'[()]'), '');
            //print('BH: $s1 /BLC: $s2/ date: $s3');
            myBlcs.add('BH $s1/BLC $s2/ date $s3');
          }

          // myBlcs.add(s);}
        }
      }

      final myBounds = getBounds(nbreDePage: nbreDePage, document: document, p: p, myLignBlock: myLignBlock);

      for (int lign = 0; lign < myBounds[1].length; lign++) {
        VolPdf myVol = VolPdf();
        var cl = 0;

        for (int col = 0; col < myBounds[0].length; col++) {
          for (int i = 0; i < result.length; i++) {
            List<TextWord> wordCollection = result[i].wordCollection;
            for (int j = 0; j < wordCollection.length; j++) {
              var myL = wordCollection[j].bounds.top.round();
              var myC = wordCollection[j].bounds.left.round();

              var l = myBounds[1][lign];
              if ((l - myL).abs() < 10) {
                if (col != 0) {
                  cl = 0;
                }

                if (col < myBounds[0].length - 1) {
                  if (myBounds[0][col] <= myC && myC < myBounds[0][col + 1]) {
                    switch (col) {
                      case 0:
                        cl++;
                        if (cl == 1) {
                          myVol.datej = wordCollection[j].text.trim();
                        } else if (cl == 3) {
                          myVol.dateM = wordCollection[j].text.trim();
                        }
                        break;
                      case 1:
                        myVol.report = wordCollection[j].text.trim();

                        break;
                      case 3:
                        myVol.pos = wordCollection[j].text.trim();
                        break;
                      case 4:
                        myVol.activity = wordCollection[j].text.trim();
                        break;
                      case 5:
                        myVol.from = wordCollection[j].text.trim();
                        break;
                      case 6:
                        myVol.to = wordCollection[j].text.trim();

                        break;
                      case 7:
                        myVol.start = wordCollection[j].text.trim();

                        break;
                      case 8:
                        myVol.end = wordCollection[j].text.trim();

                        break;
                      case 9:
                        myVol.aC = wordCollection[j].text.trim();
                        break;
                    }
                  }
                } else {
                  if (myBounds[0][col] <= myC) {
                    myVol.layover = wordCollection[j].text.trim();
                  }
                }
              }
            }
          }
        }
        myVol.month = ch;
        if (myBlcs.isNotEmpty) {
          myVol.tags = myBlcs.first;
          // print(myVol.tags);
        }

        mesVols.add(myVol);
        // print(myVol.toString());
      }
    }
    document.dispose();

    return mesVols;
  }

  void correctListVols(List<VolPdf> mesVols) {
    List<VolPdf> toRemove = [];
    for (var i = 0; i < mesVols.length; i++) {
      if (mesVols[i].activity.trim().isEmpty) {
        toRemove.add(mesVols[i]);
      }
    }
    mesVols.removeWhere((e) => toRemove.contains(e));
    for (var i = 1; i < mesVols.length; i++) {
      if (mesVols[i].from.trim().isEmpty &&
          mesVols[i].to.trim().isNotEmpty &&
          mesVols[i].start.trim().isEmpty &&
          mesVols[i].activity.trim().isNotEmpty) {
        toRemove.add(mesVols[i]);
        mesVols[i - 1].to = mesVols[i].to.trim();
        mesVols[i - 1].end = mesVols[i].end.trim();
        mesVols[i - 1].aC = mesVols[i].aC.trim();
        mesVols[i - 1].layover = mesVols[i].layover.trim();
      }
      if (mesVols[i].to.trim().isEmpty &&
          mesVols[i].start.trim().isNotEmpty &&
          mesVols[i].activity.trim().isNotEmpty) {
        mesVols[i].to = mesVols[i].from.trim();
      }
    }
    mesVols.removeWhere((e) => toRemove.contains(e));
    for (var i = 0; i < mesVols.length; i++) {
      if (mesVols[i].activity.trim().isNotEmpty && mesVols[i].from.isEmpty && mesVols[i].to.isEmpty) {
        mesVols[i].start = '00:01';
        mesVols[i].end = '23:59';
        mesVols[i].from = 'CMN';
        mesVols[i].to = 'CMN';
      }
    }
  }

  void getVolPdfDuty(List<VolPdf> volPdfs) {
    for (var volPdf in volPdfs) {
      if (int.tryParse(volPdf.activity) == null) {
        if (volPdf.activity.trim() == 'CA' || volPdf.activity.trim() == 'CRE') {
          volPdf.duty = tConge.typ;
        } else if (volPdf.activity.trim().startsWith('RV')) {
          volPdf.duty = tRV.typ;
          volPdf.to = volPdf.from;
        } else if (volPdf.activity.trim().startsWith('CNL')) {
          volPdf.duty = tCNL.typ;
        } else if (volPdf.activity.trim().startsWith('TAX')) {
          volPdf.duty = tMEP.typ;
        } else if (volPdf.activity.trim().startsWith('CM')) {
          volPdf.duty = tCM.typ;
        } else if (volPdf.activity.trim().startsWith('HTL')) {
          volPdf.duty = tHTL.typ;
        } else {
          volPdf.duty = tDuty.typ;
        }
      } else {
        volPdf.activity = 'AT${volPdf.activity}';
        volPdf.duty = tVol.typ;
        if (volPdf.pos.trim() == 'DH') volPdf.duty = tMEP.typ;
      }
    }
  }

  void getAllDatesVols(List<VolPdf> mesVols) {
    if (mesVols.isEmpty) return;

    var ch = mesVols[0].month;

    DateTime dateMois = DateFormat('d MMMM yyyy').parse('01 $ch');
    DateTime dtFin = DateTime(dateMois.year, dateMois.month + 1, dateMois.day, 0, 0, 0);
    dtFin.subtract(const Duration(minutes: 1));
    // print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    // print('                           $dateMois                           ');
    // print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    DateTime transitDate = dateMois;
    for (var i = 0; i < mesVols.length; i++) {
      var vol = mesVols[i];
      if (vol.datej.isNotEmpty) {
        int myDay = int.parse(vol.datej);
        // print('i:$i ,myDay :$myDay');
        if (i == 0) {
          if (myDay == 31) {
            transitDate = DateTime(
              dateMois.year,
              dateMois.month - 1,
              myDay,
              transitDate.hour,
              transitDate.minute,
            );
          } else {
            transitDate = DateTime(
              transitDate.year,
              transitDate.month,
              myDay,
              transitDate.hour,
              transitDate.minute,
            );

            if (dateMois.isBefore(transitDate) && myDay > 22) {
              transitDate = substractMonth(transitDate);
            }
          }
        } else {
          transitDate = DateTime(
            transitDate.year,
            transitDate.month,
            myDay,
            transitDate.hour,
            transitDate.minute,
          );
          if (transitDate.isBefore(mesVols[i - 1].dateVol)) {
            if (transitDate.month == mesVols[i - 1].dateVol.month) {
              transitDate = addMonth(transitDate);
            } else {
              transitDate = addDay(transitDate);
            }
          }
        }
      }
      // print('transitDate : $transitDate.// dateMois: $dateMois /');

      if (vol.start.trim().isNotEmpty) {
        var heur = vol.report.trim().isNotEmpty ? vol.report.trim() : vol.start.trim();
        transitDate = DateTime(
          transitDate.year,
          transitDate.month,
          transitDate.day,
          int.parse(heur.split(':').first),
          int.parse(heur.split(':').last),
        );
      }

      vol.dateVol = transitDate;

      transitDate = getCorrectDate(textHeure: vol.report.trim(), transitDate: transitDate);

      vol.myChInDate = DateFormat('dd/MM/yyyy HH:mm').format(transitDate);

      transitDate = getCorrectDate(textHeure: vol.start.trim(), transitDate: transitDate);

      vol.myDepDate = DateFormat('dd/MM/yyyy HH:mm').format(transitDate);

      transitDate = getCorrectDate(textHeure: vol.end.trim(), transitDate: transitDate);
      vol.myArrDate = DateFormat('dd/MM/yyyy HH:mm').format(transitDate);
      // print(vol.myArrDate);

      if (vol.layover.contains(':')) {
        VolPdf myVol = VolPdf();
        myVol.month = vol.month;
        myVol.dateVol = transitDate;
        myVol.duty = 'HTL';
        //   vol.dateVol = transitDate;
        myVol.myDepDate = DateFormat('dd/MM/yyyy HH:mm').format(transitDate);
        myVol.start = DateFormat('HH:mm').format(transitDate);
        transitDate = transitDate.add(
          Duration(
            hours: int.parse(vol.layover.split(':')[0]),
            minutes: int.parse(vol.layover.split(':')[1]),
          ),
        );
        myVol.myArrDate = DateFormat('dd/MM/yyyy HH:mm').format(transitDate);
        myVol.end = DateFormat('HH:mm').format(transitDate);
        myVol.activity = 'HTL';
        myVol.from = vol.to;
        myVol.to = vol.to;
        myVol.report = '';
        //  print('HTL $vol');
        //mesHtlVols.add(myVol);
        mesVols.insert(i + 1, myVol);
        i++;
      }
      // print('vol.toString():${vol.toString()}');
    }
    mesVols.removeWhere((e) => (e.dateVol.isBefore(dateMois) || e.dateVol.isAfter(dtFin)));
    // for (var vol in mesVols) {
    //   print('vol.toString():${vol.toString()}');
    // }
  }

  DateTime substractMonth(DateTime date) =>
      DateTime(date.year, date.month - 1, date.day, date.hour, date.minute);
  DateTime addDay(DateTime date) => DateTime(date.year, date.month, date.day + 1, date.hour, date.minute);
  DateTime addMonth(DateTime date) => DateTime(date.year, date.month + 1, date.day, date.hour, date.minute);
  DateTime getCorrectDate({required DateTime transitDate, required String textHeure}) {
    DateTime myDate = transitDate;
    if (textHeure.isNotEmpty) {
      myDate = DateTime(
        transitDate.year,
        transitDate.month,
        transitDate.day,
        int.parse(textHeure.trim().split(':').first),
        int.parse(textHeure.trim().split(':').last),
      );
      if (myDate.isBefore(transitDate)) {
        myDate = myDate.add(const Duration(days: 1));
      }
    }
    return myDate;
  }
}
