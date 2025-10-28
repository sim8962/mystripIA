import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../../helpers/fct.dart';
import 'vol_pdf_list.dart';

@Entity()
class VolPdf {
  @Id()
  int id;

  final volPdfList = ToOne<VolPdfList>();
  VolPdf({
    this.id = 0,
  });
  @Property(type: PropertyType.date)
  DateTime dateVol = DateFormat('dd/MM/yyyy HH:mm').parse('01/01/2002 00:00');
  String month = '';
  String datej = '';
  String dateM = '';
  String myDepDate = '';
  String myArrDate = '';
  String myChInDate = '';
  String report = '';
  String tags = '';
  String pos = '';
  String path = '';
  String activity = '';
  String from = '';
  String to = '';
  String start = '';
  String end = '';
  String aC = '';
  String layover = '';
  String duty = '';

  String get cle => (myDepDate + activity + start + from + to + end);

  /// Vérifie si les champs essentiels sont valides
  bool get isValid => from.isNotEmpty && to.isNotEmpty && activity.isNotEmpty;

  /// Parse une chaîne de date/heure au format "dd/MM/yyyy HH:mm" en DateTime
  /// Utilise Fct.parseDateTimeFromString pour la centralisation
  static DateTime parseDateTimeFromString(String dateTimeStr, DateTime fallbackDate) {
    return Fct.parseDateTimeFromString(dateTimeStr, fallbackDate: fallbackDate);
  }

  @override
  String toString() {
    String result =

        // """ Act:$activity,dateM:$dateM ,datej:$datej Hdep :$myDepDate, from:$from,to:$to,HArr :$myArrDate, dateVol:${DateFormat('dd/MM/yyyy').format(dateVol)},
        """ dateM:$dateM, datej:$datej, Report:$report, Tags:$tags, Pos:$pos, Activity:$activity, From:$from, To:$to, Start:$start, End:$end, A/CLayover :$layover,Hdep :$myDepDate,dateVol:${DateFormat('dd/MM/yyyy').format(dateVol)}       
                   -----------------------------------------------------------------------------------------""";
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VolPdf &&
        other.dateVol == dateVol &&
        other.duty == duty &&
        other.activity == activity &&
        other.from == from &&
        other.myDepDate == myDepDate &&
        other.myArrDate == myArrDate &&
        other.to == to;
  }

  @override
  int get hashCode =>
      dateVol.hashCode ^
      duty.hashCode ^
      activity.hashCode ^
      from.hashCode ^
      myDepDate.hashCode ^
      myArrDate.hashCode ^
      to.hashCode;
}
