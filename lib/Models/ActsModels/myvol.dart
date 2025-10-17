// import 'package:objectbox/objectbox.dart';
// import 'crew.dart';

// @Entity()
// class MyVol {
//   @Id(assignable: true)
//   int id;
//   final String cle;

//   final String typ;
//   final String nVol;
//   @Property(type: PropertyType.date)
//   late DateTime dtDebut;
//   final String dep;
//   final String arr;
//   @Property(type: PropertyType.date)
//   late DateTime dtFin;
//   late String label;
//   String sAvion;
//   final crews = ToMany<Crew>();

//   MyVol({
//     this.id = 0,
//     required this.typ,
//     required this.nVol,
//     required this.dtDebut,
//     required this.dep,
//     required this.arr,
//     required this.dtFin,

//     this.label = '',
//     this.cle = '',
//     this.sAvion = '',
//   });
// }
