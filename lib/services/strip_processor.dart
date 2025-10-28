import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Models/ActsModels/crew.dart';
import '../Models/ActsModels/myduty.dart';
import '../Models/ActsModels/myetape.dart';
import '../Models/VolsModels/vol.dart';

import '../Models/ActsModels/typ.dart';
import '../Models/ActsModels/typ_const.dart';
import '../helpers/constants.dart';
import '../helpers/fct.dart';
import '../helpers/myerrorinfo.dart';

import '../Models/jsonModels/mystripjson/activity_activity_model.dart';

import '../Models/jsonModels/mystripjson/entity_activity_model.dart';
import '../Models/jsonModels/mystripjson/mystrip_model.dart';

class StripProcessor {
  /// Parses the entire strip and organizes events into a hierarchical structure
  /// of Rotations > Duties > Events.

  /// Loads the JSON file, extracts all events into a flat list, and sorts them chronologically.
  Future<List<Activity>> getAllEventsChronologically() async {
    // 1. Load the JSON file from assets
    final String jsonString = await rootBundle.loadString('assets/myjson.json');

    // 2. Parse the JSON string using the Mystrip model
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final MyStrip mystrip = MyStrip.fromJson(jsonMap);

    // 3. Extract all nested activities into a single list
    final List<Activity> allEvents = [];
    if (mystrip.entity?.activities != null) {
      for (var entityActivity in mystrip.entity!.activities!) {
        if (entityActivity.activities != null) {
          allEvents.addAll(entityActivity.activities!);
        }
      }
    }

    // 4. Sort the list of events chronologically by startTime
    // Events without a startTime will be placed at the end.
    allEvents.sort((a, b) {
      if (a.startTime == null && b.startTime == null) return 0;
      if (a.startTime == null) return 1; // a is greater (goes to the end)
      if (b.startTime == null) return -1; // b is greater (goes to the end)
      return a.startTime!.compareTo(b.startTime!);
    });

    return allEvents;
  }

  // =======================================================================
  // New Methods for MyDuty Parsing
  // =======================================================================

  List<MyDuty> processMyStripIntoDuties(MyStrip myStrip) {
    final List<MyDuty> myNewDutys = [];
    if (myStrip.entity?.activities == null) {
      return myNewDutys;
    }

    for (final activities in myStrip.entity!.activities!) {
      if (activities.activities == null) {
        // Handle single, non-grouped activities (e.g., 'Jour Off')
        final duty = _processSingleActivity(activities);
        if (duty != null) {
          myNewDutys.add(duty);
        }
      } else {
        // Handle complex rotations (flights, ground tasks, etc.)
        final duty = _processActivityRotation(activities);
        if (duty != null) {
          myNewDutys.add(duty);
        }
      }
    }
    return myNewDutys;
  }

  MyDuty? _processSingleActivity(Activities activity) {
    try {
      if (activity.activityCode != null) {
        final typ = Typ.fromId(id: activity.activityCode!.id);
        final cle =
            '${activity.activityCode?.id ?? ''}:${activity.startStation!}-${activity.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: activity.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: activity.endTime!))}';

        final volTransit = VolModel(
          typ: typ.typ,
          nVol: activity.activityCode?.id ?? '',
          dtDebut: activity.startTime!,
          depIata: activity.startStation!,
          arrIata: activity.endStation!,
          dtFin: activity.endTime!,
          cle: cle,
        );

        final myDuty = MyDuty(
          myMonth: Fct.firstOfMonth(dt: activity.startTime!),
          startTime: activity.startTime!,
          endTime: activity.endTime!,
          dateLabel:
              '${dateFormatMMMm.format(activity.startTime!)} - ${dateFormatMMMm.format(activity.endTime!)}',
          typeLabel: activity.activityCode!.description ?? '',
          detailLabel: Fct.getStringDureeFromInt(dureeInMin: activity.durationMinutes, inDay: true),
        );

        myDuty.typ.target = typ;
        myDuty.vols.add(volTransit);
        return myDuty;
      }
    } catch (e) {
      MyErrorInfo.erreurInos(content: '_processSingleActivity()', label: e.toString());
    }
    return null;
  }

  MyDuty? _processActivityRotation(Activities rotation) {
    final bool isRotationWithLayover = rotation.activities?.any((act) => act.type == 'layover') ?? false;
    final bool isGroundTask = rotation.activities?.any((act) => act.type == 'ground-task') ?? false;

    if (isGroundTask) {
      // For now, we'll assume a ground task rotation results in one MyDuty.
      // The original logic created a MyDuty for each ground-task activity, which might be a bug.
      // Here we take the first one.
      final groundActivity = rotation.activities!.firstWhere((act) => act.type == 'ground-task');
      return _createDutyForGroundTask(rotation, groundActivity);
    }

    // Process as a flight rotation
    return _createDutyForFlightRotation(rotation, isRotationWithLayover);
  }

  MyDuty _createDutyForGroundTask(Activities rotation, Activity groundActivity) {
    final typ = Typ.fromId(id: groundActivity.activityCode?.id);
    final volTransit = VolModel(
      typ: typ.typ,
      nVol: groundActivity.activityCode?.id ?? '',
      dtDebut: groundActivity.startTime!,
      depIata: groundActivity.startStation!,
      arrIata: groundActivity.endStation!,
      dtFin: groundActivity.endTime!,
      label: groundActivity.statusLabel ?? '',
      cle:
          '${groundActivity.activityCode?.id ?? ''}:${groundActivity.startStation!}-${groundActivity.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: groundActivity.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: groundActivity.endTime!))}',
    );
    volTransit.crews.addAll(groundActivity.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));

    final myDuty = MyDuty(
      myMonth: Fct.firstOfMonth(dt: rotation.startTime!),
      startTime: groundActivity.startTime!,
      endTime: groundActivity.endTime!,
      dateLabel:
          '${dateFormatMMMm.format(groundActivity.startTime!)} - ${dateFormatMMMm.format(groundActivity.endTime!)}',
      typeLabel: groundActivity.activityCode?.id ?? '',
      detailLabel: Fct.getStringDureeFromInt(dureeInMin: rotation.durationMinutes, inDay: true),
    );

    myDuty.typ.target = typ;
    myDuty.vols.add(volTransit);
    myDuty.crews.addAll(groundActivity.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));

    return myDuty;
  }

  MyDuty _createDutyForFlightRotation(Activities rotation, bool isRotationWithLayover) {
    final List<MyEtape> etapes = [];
    final List<VolModel> vols = [];
    String titleDetail = '';
    bool isBriefing = true;
    final Map<Activity, String> tsvPositions = {}; // Map pour stocker les positions TSV

    // Build title
    if (isRotationWithLayover) {
      titleDetail =
          rotation.activities
              ?.where((act) => act.type == 'layover')
              .map((act) => act.startStation ?? '')
              .join(' - ') ??
          '';
    } else {
      titleDetail =
          rotation.activities
              ?.where((act) => act.type == 'flight-leg')
              .map((act) => 'AT${act.flightNumber ?? ''}')
              .join(' / ') ??
          '';
    }

    for (final act in rotation.activities!) {
      MyEtape? etape;
      VolModel? volTransit;
      Typ? typ;

      try {
        if (act.type == 'briefing' && isBriefing && rotation.duties != null) {
          final dutie = rotation.duties!.firstWhereOrNull(
            (e) => e.startTime!.isAtSameMomentAs(act.startTime!),
          );
          if (dutie != null) {
            final mylegs = rotation.activities!
                .where(
                  (e) =>
                      e.type == 'flight-leg' &&
                      dutie.startTime!.isBefore(e.startTime!) &&
                      e.endTime!.isBefore(dutie.endTime!),
                )
                .toList();

            isBriefing = false;

            String tsvMax = mylegs.isNotEmpty
                ? _getTsvMax(sect: mylegs.length, tsvDebut: dutie.startTime!, tsvFin: dutie.endTime!)
                : '';
            String tsv = mylegs.isEmpty
                ? ''
                : Fct.getDatesDefference(dateDebut: dutie.startTime!, dateFin: dutie.endTime!, inDay: false);
            Duration dt = Fct.getDureeFromString(sDuree: tsvMax);

            // Assigner les positions TSV aux vols dans mylegs
            for (int i = 0; i < mylegs.length; i++) {
              final leg = mylegs[i];
              if (mylegs.length == 1) {
                // Si un seul vol, assigner "Tsv"
                tsvPositions[leg] = 'Tsv';
              } else if (i == 0) {
                // Premier vol de plusieurs
                tsvPositions[leg] = 'debut tsv';
              } else if (i == mylegs.length - 1) {
                // Dernier vol de plusieurs
                tsvPositions[leg] = 'fin tsv';
              } else {
                // Vols intermédiaires
                tsvPositions[leg] = 'dans tsv';
              }
            }

            etape = MyEtape(
              startTime: act.startTime!,
              dateLabel: mylegs.isEmpty
                  ? ''
                  : "${mylegs.length} ${'duty_legs'.tr} - TSV:$tsv/$tsvMax ${'duty_tsv_max'.tr} ${'duty_tsv_end'.tr} ${dateFormatMMM.format(dutie.startTime!.add(dt))}",
              typeLabel: '',
              detailLabel: '',
            );
            etape.typ.target = tTsv;
            etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
          }
        } else if (act.type == 'layover') {
          typ = tHTL;
          isBriefing = true;
          String d = Fct.getStringDureeFromInt(dureeInMin: act.durationMinutes, inDay: false);
          String htl = act.hotel?.name?.split("-").first ?? '';

          volTransit = VolModel(
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
            typeLabel: "${'duty_hotel'.tr} $htl",
            detailLabel: "${'duty_transport'.tr} ${act.hotel?.transport?.name ?? ''}",
          );
          etape.volTransit.target = volTransit;
          etape.typ.target = typ;
          etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
        } else if (act.type == 'ground-transport') {
          bool tax = (act.activityCode?.id == "CET");
          typ = tax ? tCet : tTAX;
          isBriefing = false;

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
          etape.typ.target = typ;
          etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
        } else if (act.type == 'flight-leg') {
          typ = act.role?.id?.contains('DH') ?? false ? tMEP : tVol;
          isBriefing = false;

          volTransit = VolModel(
            typ: typ.typ,
            nVol: "AT${act.flightNumber!}",
            dtDebut: act.startTime!,
            depIata: act.startStation!,
            arrIata: act.endStation!,
            dtFin: act.endTime!,
            label: act.statusLabel ?? '',
            sAvion: act.tail ?? '',
            tsv: tsvPositions[act] ?? '', // Assigner la position TSV si elle existe
            cle:
                'AT${act.flightNumber!}:${act.startStation!}-${act.endStation!}:${dateFormatDD.format(Fct.uTcDate(dt: act.startTime!))}:${dateFormatDD.format(Fct.uTcDate(dt: act.endTime!))}',
          );
          volTransit.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)));

          String getLabel = (act.statusLabel == null) ? '' : "${act.statusLabel}";

          etape = MyEtape(
            startTime: act.startTime!,
            dateLabel: 'AT${act.flightNumber!} ${act.tail ?? ''} $getLabel',
            typeLabel:
                "${dateFormatMMM.format(act.startTime!)} ${act.startStation!} - ${act.endStation} ${dateFormatMMM.format(act.endTime!)}",
            detailLabel: act.statusLabel == null
                ? ''
                : "Initial: ${dateFormatMMM.format(act.scheduledStartTime!)}-${dateFormatMMM.format(act.scheduledEndTime!)} ",
          );
          etape.volTransit.target = volTransit;
          etape.typ.target = typ;
          etape.crews.addAll(act.assignedCrew.map((e) => Crew.fromAssignedCrew(e)).toList());
        }
      } catch (e) {
        MyErrorInfo.erreurInos(
          content: '_createDutyForFlightRotation()',
          label: 'e1:${e.toString()} act:$act',
        );
      }

      if (etape != null) {
        etapes.add(etape);
      }
      if (volTransit != null) {
        vols.add(volTransit);
      }
    }

    final myDuty = MyDuty(
      myMonth: Fct.firstOfMonth(dt: rotation.startTime!),
      startTime: rotation.startTime!,
      endTime: rotation.endTime!,
      dateLabel:
          '${dateFormatMMMm.format(rotation.startTime!)} - ${dateFormatMMMm.format(rotation.endTime!)}',
      typeLabel: isRotationWithLayover ? tRotation.label : tVols.label,
      detailLabel: titleDetail,
    );

    myDuty.typ.target = isRotationWithLayover ? tRotation : tVols;
    myDuty.etapes.addAll(etapes);
    myDuty.vols.addAll(vols);

    return myDuty;
  }

  String _getTsvMax({required DateTime tsvDebut, required DateTime tsvFin, required int sect}) {
    DateTime wOclD({required DateTime de}) => DateTime(de.year, de.month, de.day, 1, 0);
    DateTime wOclF({required DateTime de}) => DateTime(de.year, de.month, de.day, 5, 0);

    Duration dP = const Duration(minutes: 0);
    List<DateTime> wOClD = [wOclD(de: tsvDebut), wOclF(de: tsvDebut)];
    List<DateTime> wOClF = [wOclD(de: tsvFin), wOclF(de: tsvFin)];

    if (tsvDebut.isAfter(wOClD.last) && tsvFin.isBefore(wOClF.first)) {
      dP = const Duration(minutes: 0);
    } else if (tsvDebut.isAfter(wOClD.first) && tsvDebut.isBefore(wOClD.last)) {
      dP = Fct.minDt(dT1: wOClD.last, dT2: tsvFin).difference(tsvDebut);
      if (dP.inHours > 2) dP = const Duration(hours: 2);
    } else if (tsvFin.isAfter(wOClF.first) && tsvFin.isBefore(wOClF.last)) {
      dP = tsvFin.difference(Fct.supDt(dT1: wOClF.first, dT2: tsvDebut));
      dP = Duration(minutes: dP.inMinutes ~/ 2);
    } else if (tsvDebut.isBefore(wOClD.first) && tsvFin.isAfter(wOClF.last)) {
      dP = const Duration(hours: 2);
    }

    int d = 0;
    if (sect > 2) {
      d = dP.inMinutes + ((sect - 2) * 30);
    }

    Duration dMax = Duration(minutes: (13 * 60) - d);

    if (tsvDebut.hour > 20 || tsvDebut.hour < 4) {
      dMax = Duration(minutes: (11 * 60 + 45)); // Simplified from original min comparison
    }
    return Fct.getStringFromDuree(duree: dMax);
  }

  // =======================================================================
  // New Methods for MyDuty Widgets
  // =======================================================================
  void getWidget({required MyDuty myDuty}) {
    if (myDuty.typ.target != tVols && myDuty.typ.target != tRotation) {
      if (myDuty.crews.isEmpty) {
        //return a card widget  crewless :
        // if (duty.typ.target != null) Cardeduty1 else Cardeduty2
      } else {
        //return a card widget with crews list in datatable CardeRv
      }
    } else {
      // return ExpansionTile with title widget: if (duty.typ.target != null) Cardeduty1 else Cardeduty2
      for (var myEtape in myDuty.etapes) {
        if (myEtape.crews.isEmpty) {
          //return CardeTyp(etape: myEtape)
        } else {
          //ExpansionTile with title Widget: CardeTyp(etape: myEtape),children: [DataBle of crews]
        }
      }
    }
  }
}
