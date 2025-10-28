import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import 'vol_pdf.dart';

@Entity()
class VolPdfList {
  @Id()
  int id;

  @Backlink('volPdfList')
  final volPdfs = ToMany<VolPdf>();

  @Property(type: PropertyType.date)
  final DateTime month;

  final String tags;
  final String path;

  VolPdfList({this.id = 0, required this.tags, required this.month, required this.path});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VolPdfList && other.month == month && other.volPdfs.length == volPdfs.length;
  }

  @override
  int get hashCode => volPdfs.length.hashCode ^ month.hashCode;

  factory VolPdfList.copy(VolPdfList volPdfListB) {
    VolPdfList vol = VolPdfList(
      id: volPdfListB.id,
      month: volPdfListB.month,
      tags: volPdfListB.tags,
      path: volPdfListB.path,
    );
    vol.volPdfs.addAll(volPdfListB.volPdfs);
    return vol;
  }

  factory VolPdfList.getListVolPdfyMonth({required DateTime myMonth, required List<VolPdf> volPdfBs}) {
    List<VolPdf> monthLists =
        volPdfBs
            .where(
              (volPdfB) => (volPdfB.dateVol.year == myMonth.year && volPdfB.dateVol.month == myMonth.month),
            )
            .toSet()
            .toList();

    monthLists.sort((a, b) {
      return a.dateVol.millisecondsSinceEpoch.compareTo(b.dateVol.millisecondsSinceEpoch);
    });
    String s = monthLists.isNotEmpty ? monthLists.first.tags : '';

    VolPdfList myVolPdfList = VolPdfList(tags: s, path: '', month: myMonth);
    myVolPdfList.volPdfs.addAll(monthLists);
    return myVolPdfList;
  }

  /// Extrait les mois uniques d'une liste de VolPdf et les retourne triés
  static List<DateTime> extractMonthsFromVolPdfs({required List<VolPdf> myVolPdfs}) {
    final months = <DateTime>{};
    for (var volPdf in myVolPdfs) {
      final month = DateTime(volPdf.dateVol.year, volPdf.dateVol.month, 1);
      months.add(month);
    }
    final sortedMonths = months.toList();
    sortedMonths.sort((a, b) => a.millisecondsSinceEpoch.compareTo(b.millisecondsSinceEpoch));
    return sortedMonths;
  }

  /// Groupe les VolPdf par mois et retourne une liste de VolPdfList
  static List<VolPdfList> groupByMonth({required List<VolPdf> volPdfs}) {
    final Map<String, List<VolPdf>> groupedByMonth = {};
    
    for (var volPdf in volPdfs) {
      final monthKey = '${volPdf.dateVol.year}-${volPdf.dateVol.month.toString().padLeft(2, '0')}';
      groupedByMonth.putIfAbsent(monthKey, () => []).add(volPdf);
    }

    final result = <VolPdfList>[];
    for (var entry in groupedByMonth.entries) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final monthDate = DateTime(year, month, 1);
      
      final volPdfList = VolPdfList.getListVolPdfyMonth(myMonth: monthDate, volPdfBs: entry.value);
      result.add(volPdfList);
    }

    // Trier par date décroissante (mois les plus récents en premier)
    result.sort((a, b) => b.month.millisecondsSinceEpoch.compareTo(a.month.millisecondsSinceEpoch));
    return result;
  }

  @override
  String toString() {
    String result =
        'id:$id,month:${DateFormat('dd/MM/yyyy').format(month)},vol.volPdfs:${volPdfs.length} ,tags:$tags }';
    return result;
  }
}
