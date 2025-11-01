import 'package:objectbox/objectbox.dart';
import 'package:get/get.dart';
import '../VolsModels/vol.dart';
import './typ.dart';
import './myduty.dart';
import './crew.dart';

@Entity()
class MyEtape {
  @Id(assignable: true)
  int id;

  @Property(type: PropertyType.date)
  final DateTime startTime;
  final String dateLabel;
  final String typeLabel;
  final String detailLabel;
  final volTransit = ToOne<VolModel>();

  final crews = ToMany<Crew>();
  final typ = ToOne<Typ>();
  final myDuty = ToOne<MyDuty>();

  MyEtape({
    this.id = 0,
    required this.startTime,
    required this.dateLabel,
    required this.typeLabel,
    required this.detailLabel,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyEtape &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          dateLabel == other.dateLabel &&
          typeLabel == other.typeLabel &&
          detailLabel == other.detailLabel;
  //   vols?.target == other.volTraite.target;

  /// Retourne le dateLabel traduit dynamiquement
  String get translatedDateLabel {
    // Si c'est un TSV avec "Etapes"
    if (dateLabel.contains('Etapes') || dateLabel.contains('Legs')) {
      final regex = RegExp(r'(\d+)\s+(Etapes|Legs)\s+-\s+TSV:([^m]+)max\.\s+(Fin Tsv:|TSV End:)\s+(.+)');
      final match = regex.firstMatch(dateLabel);
      if (match != null) {
        final count = match.group(1);
        final tsv = match.group(3);
        final date = match.group(5);
        return "$count ${'duty_legs'.tr} - TSV:$tsv${'duty_tsv_max'.tr} ${'duty_tsv_end'.tr} $date";
      }
    }
    return dateLabel;
  }

  /// Retourne le typeLabel traduit dynamiquement
  String get translatedTypeLabel {
    // Si c'est un Hotel
    if (typeLabel.startsWith('Hotel:') || typeLabel.startsWith('Hôtel:')) {
      final hotelName = typeLabel.replaceFirst(RegExp(r'^(Hotel:|Hôtel:)\s*'), '');
      return "${'duty_hotel'.tr} $hotelName";
    }
    return typeLabel;
  }

  /// Retourne le detailLabel traduit dynamiquement
  String get translatedDetailLabel {
    // Si c'est un Transport
    if (detailLabel.startsWith('Transport:')) {
      final transportName = detailLabel.replaceFirst('Transport: ', '');
      return "${'duty_transport'.tr} $transportName";
    }
    return detailLabel;
  }
  // Important to compare nullable VolTransit.

  @override
  int get hashCode => startTime.hashCode ^ dateLabel.hashCode ^ typeLabel.hashCode ^ detailLabel.hashCode;
}
