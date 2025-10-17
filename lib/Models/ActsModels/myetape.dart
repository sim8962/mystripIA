import 'package:objectbox/objectbox.dart';

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
  // Important to compare nullable VolTransit.

  @override
  int get hashCode => startTime.hashCode ^ dateLabel.hashCode ^ typeLabel.hashCode ^ detailLabel.hashCode;
}
