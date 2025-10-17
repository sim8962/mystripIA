import 'dart:math';

import 'package:objectbox/objectbox.dart';

import '../../helpers/constants.dart';
import '../../helpers/fct.dart';
import '../../helpers/myerrorinfo.dart';
import '../VolsModels/vol.dart';
import '../jsonModels/mystripjson/activity_activity_model.dart';
import '../jsonModels/mystripjson/duty.dart';
import '../jsonModels/mystripjson/mystrip_model.dart';
import 'crew.dart';
import 'myetape.dart';

import 'typ.dart';
import 'typ_const.dart';

@Entity()
class MyDuty {
  @Id(assignable: true)
  int id;
  @Property(type: PropertyType.date)
  final DateTime myMonth;
  @Property(type: PropertyType.date)
  final DateTime startTime;
  @Property(type: PropertyType.date)
  final DateTime endTime;
  final String dateLabel;
  final String typeLabel;
  final String detailLabel;

  final typ = ToOne<Typ>();

  final vols = ToMany<VolModel>();

  @Backlink('myDuty')
  final crews = ToMany<Crew>();

  @Backlink('myDuty')
  final etapes = ToMany<MyEtape>();

  MyDuty({
    this.id = 0,
    required this.myMonth,
    required this.startTime,
    required this.endTime,
    required this.dateLabel,
    required this.typeLabel,
    required this.detailLabel,
  });

  static List<MyDuty> getDuty({required MyStrip myStrip}) {
    String getTsvMax({required DateTime tsvDebut, required DateTime tsvFin, required int sect}) {
      DateTime wOclD({required DateTime de}) => DateTime(de.year, de.month, de.day, 01, 00);
      DateTime wOclF({required DateTime de}) => DateTime(de.year, de.month, de.day, 05, 00);
      // DateTime wO22({required DateTime de}) => DateTime(de.year, de.month, de.day, 21, 00);
      // DateTime wO00({required DateTime de}) => DateTime(de.year, de.month, de.day, 00, 00);

      Duration dP = const Duration(minutes: 0);
      // String lg = 'Sect:$sect';
      List<DateTime> wOClD = [wOclD(de: tsvDebut), wOclF(de: tsvDebut)];
      List<DateTime> wOClF = [wOclD(de: tsvFin), wOclF(de: tsvFin)];
      if (tsvDebut.isAfter(wOClD.last) && tsvFin.isBefore(wOClF.first)) {
        dP = const Duration(minutes: 0);
        //lg += ' ici1 ';
      } else if (tsvDebut.isAfter(wOClD.first) && tsvDebut.isBefore(wOClD.last)) {
        dP = Fct.minDt(dT1: wOClD.last, dT2: tsvFin).difference(tsvDebut);
        //lg += ' ici2 ';
        if (dP.inHours > 2) dP = const Duration(hours: 2);
      } else if (tsvFin.isAfter(wOClF.first) && tsvFin.isBefore(wOClF.last)) {
        dP = tsvFin.difference(Fct.supDt(dT1: wOClF.first, dT2: tsvDebut));
        dP = Duration(minutes: dP.inMinutes ~/ 2);
        //lg += ' ici3 ';
      } else if (tsvDebut.isBefore(wOClD.first) && tsvFin.isAfter(wOClF.last)) {
        dP = const Duration(hours: 2);
        //lg += ' ici4 ';
      }
      int d = 0;
      if (sect > 2) {
        d = dP.inMinutes + ((sect - 2) * 30);
      }

      Duration dMax = Duration(minutes: (13 * 60) - d);

      if (tsvDebut.hour > 20 || tsvDebut.hour < 4) {
        dMax = Duration(minutes: min((13 * 60) - d, (11 * 60 + 45)));
        //lg += ' ici6 ';
      }
      String s = Fct.getStringFromDuree(duree: dMax);

      return s;
    }

    List<MyDuty> myNewDutys = [];
    if (myStrip.entity == null || myStrip.entity!.periods == null) return [];

    final myEntityActivitys = myStrip.entity!.activities!;
    if (myEntityActivitys.isEmpty) return [];
    for (var activitie in myEntityActivitys) {
      MyDuty? myDuty;

      if (activitie.activities == null) {
        String cle = '';
        try {
          if (activitie.activityCode != null) {
            Typ typ = Typ.fromId(id: activitie.activityCode!.id);

            cle =
                '${activitie.activityCode?.id ?? ''}:${activitie.startStation!}-${activitie.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: activitie.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: activitie.endTime!))}';

            VolModel volTransit = VolModel(
              typ: typ.typ,
              nVol: activitie.activityCode?.id ?? '',
              dtDebut: activitie.startTime!,
              depIata: activitie.startStation!,
              arrIata: activitie.endStation!,
              dtFin: activitie.endTime!,
              cle: cle,
            );

            myDuty = MyDuty(
              myMonth: Fct.firstOfMonth(dt: activitie.startTime!),
              startTime: activitie.startTime!,
              endTime: activitie.endTime!,
              dateLabel:
                  '${dateFormatMMMm.format(activitie.startTime!)} - ${dateFormatMMMm.format(activitie.endTime!)}',
              typeLabel: '${activitie.activityCode!.description}',
              detailLabel: Fct.getStringDureeFromInt(dureeInMin: activitie.durationMinutes, inDay: true),
            );
            myDuty.typ.target = typ;
            myDuty.vols.add(volTransit);
            myNewDutys.add(myDuty);
          }
        } catch (e) {
          MyErrorInfo.erreurInos(content: ' getMyMonthsActivites()', label: cle);
        }
      } else {
        Typ? typ;

        bool isRotation = false;

        bool isGround = false;
        bool isBreifing = true;
        List<MyEtape> etapes = [];
        List<VolModel> vols = [];

        for (var act in activitie.activities!) {
          if (act.type!.contains("layover")) isRotation = true;
        }

        for (var act in activitie.activities!) {
          if (act.type!.contains("ground-task")) isGround = true;
        }

        List<String> lists = [];

        for (var i = 0; i < activitie.activities!.length; i++) {
          Activity act = activitie.activities![i];
          try {
            if (isRotation) {
              if (act.type!.contains("layover")) {
                lists.add("${act.startStation ?? ''} ");
              }
              if (act.type!.contains("flight-leg")) {}
            } else {
              if (act.type!.contains("flight-leg")) {
                lists.add("AT${act.flightNumber!} ");
              }
            }
          } catch (e) {
            MyErrorInfo.erreurInos(content: 'getMyMonthsActivites()', label: '4_e1:${e.toString()} act:$act');
          }
        }

        if (isGround) {
          for (var i = 0; i < activitie.activities!.length; i++) {
            Activity act = activitie.activities![i];
            try {
              if (act.type!.contains("ground-task")) {
                Typ typ = Typ.fromId(id: act.activityCode?.id);

                VolModel volTransit = VolModel(
                  typ: typ.typ,
                  nVol: act.activityCode?.id ?? '',
                  dtDebut: act.startTime!,
                  depIata: act.startStation!,
                  arrIata: act.endStation!,
                  dtFin: act.endTime!,
                  label: act.statusLabel ?? '',
                  cle:
                      '${act.activityCode?.id ?? ''}:${act.startStation!}-${act.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: act.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: act.endTime!))}',
                );

                volTransit.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));

                myDuty = MyDuty(
                  myMonth: Fct.firstOfMonth(dt: activitie.startTime!),
                  startTime: act.startTime!,
                  endTime: act.endTime!,
                  dateLabel:
                      '${dateFormatMMMm.format(act.startTime!)} - ${dateFormatMMMm.format(act.endTime!)}',
                  typeLabel: act.activityCode?.id ?? '',
                  detailLabel: Fct.getStringDureeFromInt(dureeInMin: activitie.durationMinutes, inDay: true),
                );
                myDuty.vols.add(volTransit);
                myDuty.typ.target = typ;
                myDuty.etapes.clear();
                myDuty.crews.clear();
                myDuty.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));
                volTransit.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));
                myNewDutys.add(myDuty);
              }
            } catch (e) {
              MyErrorInfo.erreurInos(
                content: 'getMyMonthsActivites()',
                label: '5_e1:${e.toString()} act:$act',
              );
            }
          }
        } else {
          for (var i = 0; i < activitie.activities!.length; i++) {
            Activity act = activitie.activities![i];
            MyEtape? etape;
            VolModel? volTransit;
            try {
              if (act.type != null &&
                  act.type!.contains("briefing") &&
                  isBreifing &&
                  activitie.duties != null) {
                Dutie? dutie = activitie.duties!.firstWhere(
                  (e) => (e.startTime!.compareTo(act.startTime!)) == 0,
                );
                List<Activity> mylegs = activitie.activities!
                    .where(
                      (e) =>
                          (e.type!.contains("flight-leg")) &&
                          dutie.startTime!.isBefore(e.startTime!) &&
                          e.endTime!.isBefore(dutie.endTime!),
                    )
                    .toList();

                isBreifing = false;

                String tsvMax = (mylegs.isNotEmpty)
                    ? getTsvMax(sect: mylegs.length, tsvDebut: dutie.startTime!, tsvFin: dutie.endTime!)
                    // ? getFdpMax(sect: mylegs.length, tsvDebut: dutie.startTime!, tsvFin: dutie.endTime!)
                    : '';
                String tsv = (mylegs.isEmpty)
                    ? ''
                    : Fct.getDatesDefference(
                        dateDebut: dutie.startTime!,
                        dateFin: dutie.endTime!,
                        inDay: false,
                      );
                Duration dt = Fct.getDureeFromString(sDuree: tsvMax);
                etape = MyEtape(
                  startTime: act.startTime!,
                  dateLabel: mylegs.isEmpty
                      ? ''
                      : "${mylegs.length} Etapes - TSV:$tsv/$tsvMax max. Fin Tsv: ${dateFormatMMM.format(dutie.startTime!.add(dt))}",
                  typeLabel: '',
                  detailLabel: '',
                );

                etape.typ.target = tTsv;
                etape.crews.clear();
                etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
              } else if (act.type!.contains("layover")) {
                typ = tHTL;
                isBreifing = true;
                String d = Fct.getStringDureeFromInt(dureeInMin: act.durationMinutes, inDay: false);
                String htl = act.hotel == null
                    ? ''
                    : act.hotel!.name!.split("-").isNotEmpty
                    ? act.hotel!.name!.split("-").first
                    : "";
                VolModel volTransit = VolModel(
                  typ: typ.typ,
                  nVol: tHTL.typ,
                  dtDebut: act.startTime!,
                  depIata: act.startStation!,
                  arrIata: act.endStation!,
                  dtFin: act.endTime!,
                  label: act.statusLabel ?? '',
                  cle:
                      '${act.activityCode?.id ?? ''}:${act.startStation!}-${act.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: act.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: act.endTime!))}',
                );
                volTransit.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));
                etape = MyEtape(
                  startTime: act.startTime!,
                  dateLabel:
                      '${dateFormatMMM.format(act.startTime!)} - ${dateFormatMMM.format(act.endTime!)} ( $d)',
                  typeLabel: "Hotel: $htl",
                  detailLabel: "Transport: ${act.hotel?.transport?.name ?? ''}",
                );
                etape.volTransit.target = volTransit;
                etape.typ.target = typ;
                etape.crews.clear();
                etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
              } else if (act.type != null && act.type!.contains("ground-transport")) {
                bool tax = (act.activityCode?.id == "CET");
                typ = tax ? tCet : tTAX;
                isBreifing = false;
                volTransit = VolModel(
                  typ: typ.typ,
                  nVol: "CET",
                  dtDebut: act.startTime!,
                  depIata: act.startStation!,
                  arrIata: act.endStation!,
                  dtFin: act.endTime!,
                  label: act.statusLabel ?? '',
                  sAvion: act.tail ?? '',
                  cle:
                      'CET: ${act.startStation!}-${act.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: act.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: act.endTime!))}',
                );
                volTransit.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));

                etape = MyEtape(
                  startTime: act.startTime!,
                  dateLabel: '${dateFormatHH.format(act.startTime!)} - ${dateFormatHH.format(act.endTime!)}',
                  typeLabel: "${act.startStation!}-${act.endStation}",
                  detailLabel: "",
                );
                etape.volTransit.target = volTransit;
                etape.crews.clear();
                etape.typ.target = typ;
                etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
              } else if (act.type != null && act.type!.contains("flight-leg")) {
                typ = act.role!.id!.contains('DH') ? tMEP : tVol;
                isBreifing = false;
                volTransit = VolModel(
                  typ: typ.typ,
                  nVol: "AT${act.flightNumber!}",
                  dtDebut: act.startTime!,
                  depIata: act.startStation!,
                  arrIata: act.endStation!,
                  dtFin: act.endTime!,
                  label: act.statusLabel ?? '',
                  sAvion: act.tail ?? '',
                  cle:
                      'AT${act.flightNumber!}:${act.startStation!}-${act.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: act.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: act.endTime!))}',
                );
                volTransit.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));

                String getLabel = (act.statusLabel == null) ? '' : "${act.statusLabel}";

                etape = MyEtape(
                  startTime: act.startTime!,
                  dateLabel: 'AT${act.flightNumber!} ${act.tail} $getLabel',
                  typeLabel:
                      "${dateFormatMMM.format(act.startTime!)} ${act.startStation!} - ${act.endStation} ${dateFormatMMM.format(act.endTime!)}",
                  detailLabel: act.statusLabel == null
                      ? ''
                      : "Initial: ${dateFormatMMM.format(act.scheduledStartTime!)}-${dateFormatMMM.format(act.scheduledEndTime!)} ",
                );
                etape.volTransit.target = volTransit;

                etape.typ.target = typ;
                etape.crews.clear();
                etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
              }
            } catch (e) {
              MyErrorInfo.erreurInos(
                content: 'getMyMonthsActivites() else',
                label: '6_e1:${e.toString()} act:$act',
              );
            }
            if (etape != null) {
              etapes.add(etape);
            }
            if (volTransit != null) {
              vols.add(volTransit);
            }
          }

          myDuty = MyDuty(
            myMonth: Fct.firstOfMonth(dt: activitie.startTime!),
            startTime: activitie.startTime!,
            endTime: activitie.endTime!,
            dateLabel:
                '${dateFormatMMMm.format(activitie.startTime!)} - ${dateFormatMMMm.format(activitie.endTime!)}',
            typeLabel: isRotation ? tRotation.typ : tVols.typ,
            detailLabel: lists.join("- "),
          );
          myDuty.typ.target = isRotation ? tRotation : tVols;
          myDuty.vols.addAll(vols);

          myDuty.etapes.clear();
          myDuty.etapes.addAll(etapes);

          myNewDutys.add(myDuty);
        }
      }
    }
    return myNewDutys;
  }
}
