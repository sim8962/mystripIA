import 'package:objectbox/objectbox.dart';
import 'package:get/get.dart';

import 'typ_const.dart';

@Entity()
class Typ {
  @Id(assignable: true)
  int id = 0;
  final String typ;
  final String color;
  final String icon;
  Typ({this.id = 0, required this.typ, required this.color, required this.icon});
  factory Typ.copy({required Typ copy}) => Typ(typ: copy.typ, color: copy.color, icon: copy.icon);

  factory Typ.fromId({required String? id}) {
    if (id == null) {
      return tDuty;
    } else if (id.contains('FOR')) {
      return tFor;
    } else if (id.contains('Vols')) {
      return tVols;
    } else if (id.contains(tHTL.typ)) {
      return tHTL;
    } else if (id.contains('RV')) {
      return tRV;
    } else if (id.contains(tVol.typ)) {
      return tVol;
    } else if (id.contains(tRotation.typ)) {
      return tRotation;
    } else if (id.contains('F') && !id.contains('OFF')) {
      return tSimu;
    } else if (id.contains('CM')) {
      return tCM;
    } else if (id.contains('CA') || id.contains('CRE')) {
      return tConge;
    } else if (id.contains('ABS')) {
      return tABS;
    } else if (id.contains('OFF')) {
      return tOff;
    } else if (id.contains('REU')) {
      return tReu;
    } else {
      return tDuty;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Typ && other.typ == typ && other.color == color && other.icon == icon;
  }

  @override
  int get hashCode => typ.hashCode ^ color.hashCode ^ icon.hashCode;

  /// Retourne le label traduit du type d'activité
  String get label {
    final key = 'type_${typ.toLowerCase()}';
    return key.tr;
  }
}
