import 'package:objectbox/objectbox.dart';

import '../VolsModels/vol.dart';
import 'myetape.dart';
import '../jsonModels/basicModels/assigned_crew.dart';
import 'myduty.dart';

@Entity()
class Crew {
  final myEtape = ToOne<MyEtape>();
  final myDuty = ToOne<MyDuty>();
  final volModel = ToOne<VolModel>();
  @Id(assignable: true)
  int id = 0;
  String crewId;
  String firstname;
  String lastname;
  String sen;
  String pos;
  String base;

  Crew({
    this.id = 0,
    required this.crewId,
    required this.firstname,
    required this.lastname,
    required this.sen,
    required this.pos,
    required this.base,
  });
  factory Crew.fromAssignedCrew(AssignedCrew crew) => Crew(
    crewId: crew.crewId ?? '',
    firstname: crew.givenNames ?? '',
    lastname: crew.surname ?? '',
    sen: crew.seniority ?? '',
    pos: crew.position ?? '',
    base: crew.base ?? '',
  );

  /// Convert to JSON map for serialization
  Map<String, String> toJson() => {
    'crewId': crewId,
    'firstname': firstname,
    'lastname': lastname,
    'sen': sen,
    'pos': pos,
    'base': base,
  };

  @override
  String toString() {
    return 'Crew{crewId: $crewId, firstname: $firstname, lastname: $lastname, sen: $sen, pos: $pos, base: $base}';
  }
}
