import 'package:get/get.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:intl/intl.dart';
import 'package:mystrip25/Models/VolsModels/vol_traite.dart';

import '../../Models/ActsModels/typ_const.dart';
import '../../controllers/database_controller.dart';
import '../../helpers/fct.dart';
import '../../helpers/myerrorinfo.dart';
import '../../theming/app_color.dart';

class VersCalenderCtl extends GetxController {
  static VersCalenderCtl instance = Get.find();
  late DeviceCalendarPlugin deviceCalendarPlugin;

  final RxList<Calendar> _calendars = <Calendar>[].obs;
  List<Calendar> get calendars => _calendars;
  set calendars(List<Calendar> val) => _calendars.value = val;

  final Rx<int> _intChoice = 0.obs;
  int get intChoice => _intChoice.value;
  set intChoice(int index) => _intChoice.value = index;

  final Rx<int> _intLenght = 0.obs;
  int get intLenght => _intLenght.value;
  set intLenght(int index) => _intLenght.value = index;

  bool isHtl = true;
  final Rx<bool> _isExportCalender = true.obs;
  bool get isExportCalender => _isExportCalender.value;
  set isExportCalender(bool opened) => _isExportCalender.value = opened;

  final Rx<String> _idCalendar = ''.obs;
  String get idCalendar => _idCalendar.value;
  set idCalendar(String index) => _idCalendar.value = index;

  final RxBool _addCalender = false.obs;
  bool get addCalender => _addCalender.value;
  set addCalender(bool index) => _addCalender.value = index;
  // Date Range for Filtering Vols
  final Rx<DateTime> _startDate = Fct.startOfMonth(dt: DateTime.now()).obs; // Start of the current month
  DateTime get startDate => _startDate.value;
  set startDate(DateTime value) => _startDate.value = value;

  final Rx<DateTime> _endDate = Fct.endOfMonth(
    dt: DateTime.now().add(const Duration(days: 60)),
  ).obs; // End of the month + 2
  DateTime get endDate => _endDate.value;
  set endDate(DateTime value) => _endDate.value = value;

  // Permission Status
  final RxBool _permissionGranted = false.obs;
  bool get permissionGranted => _permissionGranted.value;
  set permissionGranted(bool value) => _permissionGranted.value = value;

  final RxString _permissionError = ''.obs;
  String get permissionError => _permissionError.value;
  set permissionError(String value) => _permissionError.value = value;

  @override
  void onInit() async {
    deviceCalendarPlugin = DeviceCalendarPlugin();
    await retrieveCalendars();
    super.onInit();
  }

  Future<void> retrieveCalendars() async {
    List<Calendar> myCs = [];
    try {
      // Check permissions
      var permissionsGranted = await deviceCalendarPlugin.hasPermissions();
      if (!permissionsGranted.isSuccess || permissionsGranted.data == null || !permissionsGranted.data!) {
        // Request permissions
        permissionsGranted = await deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || permissionsGranted.data == null || !permissionsGranted.data!) {
          permissionGranted = false;
          permissionError = 'error_calendar_permission_denied'.tr;
          MyErrorInfo.erreurInos(
            label: 'error_calendar_permission',
            content: 'error_calendar_permission_denied'.tr,
          );
          return;
        }
      }
      
      permissionGranted = true;
      permissionError = '';

      final calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
      final List<Calendar>? myCalendars = calendarsResult.data;

      if (myCalendars == null || myCalendars.isEmpty) {
        addCalender = true;
        return;
      }
      
      int i = myCalendars.indexWhere((cal) => cal.name?.toUpperCase() == 'MYSTRIP');
      if (i == -1) {
        await addStripCalender(name: 'MYSTRIP'.toUpperCase());
        final calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
        final List<Calendar>? myCalendars = calendarsResult.data;
        if (myCalendars == null || myCalendars.isEmpty) {
          addCalender = true;
          return;
        }
      }
      
      final calendarsResult2 = await deviceCalendarPlugin.retrieveCalendars();
      final List<Calendar>? myCalendars2 = calendarsResult2.data;
      if (myCalendars2 == null || myCalendars2.isEmpty) {
        addCalender = true;
        return;
      }
      
      for (var cal in myCalendars2) {
        if (cal.isReadOnly != true && cal.name != null) {
          myCs.add(cal);
        }
      }
      
      calendars = myCs;
      intLenght = calendars.length;
      intChoice = 0;
      addCalender = calendars.isEmpty;
    } catch (e) {
      permissionGranted = false;
      permissionError = 'error_retrieve_calendars'.tr;
      MyErrorInfo.erreurInos(
        label: 'retrieveCalendars',
        content: '${'error_retrieve_calendars'.tr}: ${e.toString()}',
      );
    }
  }

  Future<bool> addStripCalender({required String name}) async {
    if (calendars.any((e) => e.name != null && e.name!.contains(name))) {
      return false;
    }
    final result = await deviceCalendarPlugin.createCalendar(
      name,
      calendarColor: myColorRed,
      localAccountName: name,
    );

    if (!result.isSuccess) {
      MyErrorInfo.erreurInos(
        label: 'addStripCalender',
        content:
            'Erreur add Strip Calender: ${result.errors.map((err) => '[${err.errorCode}] ${err.errorMessage}').join(' | ')}',
      );
      return false;
    } else {
      await retrieveCalendars();
      return true;
    }
  }

  Future<void> deleteCalendar({required int index}) async {
    if (calendars.isEmpty || index < 0 || index >= calendars.length) return;
    try {
      final calendarId = calendars[index].id;
      if (calendarId == null || calendarId.isEmpty) {
        return;
      }

      final returnValue = await deviceCalendarPlugin.deleteCalendar(calendarId);
      if (returnValue.isSuccess) {
        await retrieveCalendars();
      }
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'deleteCalendar', content: 'deleteCalendar ${e.toString()}');
    }
  }

  Future<void> addSelectedEvents() async {
    if (calendars.isEmpty) return;

    try {
      // Supprimer les événements existants dans la plage de dates
      await deletsSelectedEvents(startDate: startDate, endDate: endDate, calendarId: calendars[intChoice].id);
      
      // Filtrer les vols dans la plage de dates sélectionnée
      final filteredVols = DatabaseController.instance.volTraiteModels.where((vol) {
        return vol.dtDebut.isAfter(startDate) && vol.dtFin.isBefore(endDate);
      }).toList();
      
      // Ajouter les événements filtrés
      for (final vol in filteredVols) {
        await addVolEvent(volTraiteModel: vol, calendar: calendars[intChoice]);
      }
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'addSelectedEvents', content: 'addSelectedEvents ${e.toString()}');
    }
  }

  Event buildEvent({required VolTraiteModel myVolTraite, required Calendar myCalendar}) {
    final event = Event(myCalendar.id)
      ..start = TZDateTime.from(myVolTraite.dtDebut, UTC)
      ..end = TZDateTime.from(myVolTraite.dtFin, UTC);

    if ([tVol.typ, tMEP.typ, tTAX.typ, tCNL.typ].contains(myVolTraite.typ)) {
      final duree = myVolTraite.sDureevol.isNotEmpty ? 'Duree: ${myVolTraite.sDureevol}' : '';
      final nuit = myVolTraite.sNuitVol.isNotEmpty ? '-Nuit: ${myVolTraite.sNuitVol}' : '';
      final avion = myVolTraite.sAvion.isNotEmpty ? myVolTraite.sAvion : '';
      final forf = myVolTraite.sDureeForfait.isNotEmpty ? 'Forf: ${myVolTraite.sDureeForfait}' : '';

      final title = '${myVolTraite.nVol} ${myVolTraite.depIata} - ${myVolTraite.arrIata}';

      var description1 = '${myVolTraite.nVol}\n \n';
      description1 +=
          '${myVolTraite.depIata}:${DateFormat('HH:mm').format(myVolTraite.dtDebut.toUtc())} UTC \n';
      description1 +=
          '${myVolTraite.arrIata}:${DateFormat('HH:mm').format(myVolTraite.dtFin.toUtc())} UTC  \n\n';

      event
        ..reminders = [Reminder(minutes: 120)]
        ..title = title
        ..location = '$avion ${myVolTraite.depIcao}-${myVolTraite.arrIcao}'
        ..description = '$duree - $forf $nuit\n$description1'
        ..availability = Availability.Busy;
    } else if ([tRV.typ, tSimu.typ].contains(myVolTraite.typ)) {
      final location =
          '${DateFormat(' HH:mm').format(myVolTraite.dtDebut.toUtc())}z -${DateFormat(' HH:mm').format(myVolTraite.dtFin.toUtc())}z';

      var description1 = '${myVolTraite.nVol}\n \n';
      description1 +=
          '${myVolTraite.depIata}:${DateFormat('HH:mm').format(myVolTraite.dtDebut.toUtc())} UTC \n';
      description1 +=
          '${myVolTraite.arrIata}:${DateFormat('HH:mm').format(myVolTraite.dtFin.toUtc())} UTC  \n\n ';

      if (myVolTraite.crewsList.isNotEmpty) {
        description1 += 'Crew:\n ';
        for (final crew in myVolTraite.crewsList) {
          final matricule = crew['matricule'] ?? '';
          final pos = crew['pos'] ?? '';
          final firstname = crew['firstname'] ?? '';
          final lastname = crew['lastname'] ?? '';
          
          event.attendees?.add(
            Attendee(
              name: '${matricule.padLeft(5, ' ')} ${pos.padRight(3, ' ')} $firstname $lastname',
            ),
          );
          description1 +=
              '   ${matricule.padLeft(5, ' ')} ${pos.padRight(3, ' ')} $firstname $lastname\n';
        }
      }
      event
        ..title = myVolTraite.nVol
        ..location = location
        ..description = description1
        ..availability = Availability.Busy;
    } else if (myVolTraite.typ == tHTL.typ) {
      if (isHtl) {
        event
          ..title = myVolTraite.nVol
          ..location =
              '${myVolTraite.depIcao} : ${DateFormat('dd HH:mm').format(myVolTraite.dtDebut.toUtc())}z -${DateFormat('dd HH:mm').format(myVolTraite.dtFin.toUtc())}z'
          ..description = 'Hotel'
          ..availability = Availability.Busy;
      } else {
        return event; // Skip hotel if isHtl is false
      }
    } else {
      final location =
          '${myVolTraite.depIcao} : ${DateFormat('dd HH:mm').format(myVolTraite.dtDebut.toUtc())}z -${DateFormat('dd HH:mm').format(myVolTraite.dtFin.toUtc())}z';
      var description1 = '${myVolTraite.nVol}\n \n';
      description1 +=
          '${myVolTraite.depIata}:${DateFormat('HH:mm').format(myVolTraite.dtDebut.toUtc())} UTC  \n';
      description1 +=
          '${myVolTraite.arrIata}:${DateFormat('HH:mm').format(myVolTraite.dtFin.toUtc())} UTC  \n\n ';

      if (myVolTraite.crewsList.isNotEmpty) {
        description1 += 'Crew:\n ';
        for (final crew in myVolTraite.crewsList) {
          final matricule = crew['matricule'] ?? '';
          final pos = crew['pos'] ?? '';
          final firstname = crew['firstname'] ?? '';
          final lastname = crew['lastname'] ?? '';
          
          event.attendees?.add(
            Attendee(
              name: '${matricule.padLeft(5, ' ')} ${pos.padRight(3, ' ')} $firstname $lastname',
            ),
          );
          description1 +=
              '   ${matricule.padLeft(5, ' ')} ${pos.padRight(3, ' ')} $firstname $lastname \n';
        }
      }
      event
        ..title = myVolTraite.nVol
        ..location = location
        ..description = description1
        ..availability = Availability.Busy;
    }

    return event;
  }

  Future<bool> addVolEvent({required VolTraiteModel volTraiteModel, required Calendar calendar}) async {
    // Skip hotel events if isHtl is false
    if (volTraiteModel.typ == tHTL.typ && !isHtl) {
      return false;
    }
    
    try {
      final event = buildEvent(myCalendar: calendar, myVolTraite: volTraiteModel);
      final createEventResult = await deviceCalendarPlugin.createOrUpdateEvent(event);
      return createEventResult?.isSuccess ?? false;
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'addVolEvent',
        content: 'Erreur ajout événement: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> deletsEvents() async {
    if (DatabaseController.instance.volTraiteModels.isEmpty) return;

    DatabaseController.instance.volTraiteModels.sort(
      (a, b) => a.dtDebut.compareTo(b.dtDebut),
    );

    final startDate = DatabaseController.instance.volTraiteModels.first.dtDebut.subtract(
      const Duration(days: 10),
    );
    final endDate = DatabaseController.instance.volTraiteModels.last.dtFin.add(const Duration(days: 1));

    try {
      final calendarId = calendars[intChoice].id;
      if (calendarId == null || calendarId.isEmpty) {
        return;
      }

      final calendarEventsResult = await deviceCalendarPlugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(startDate: startDate, endDate: endDate),
      );

      if (calendarEventsResult.data == null) {
        return;
      }
      final calendarEvents = calendarEventsResult.data as List<Event>;
      for (final evt in calendarEvents) {
        await deviceCalendarPlugin.deleteEvent(calendarId, evt.eventId);
      }
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'deletsEvents', content: 'deletsEvents ${e.toString()}');
    }
  }

  Future<void> deletsSelectedEvents({
    required DateTime startDate,
    required DateTime endDate,
    required String? calendarId,
  }) async {
    try {
      if (calendarId == null || calendarId.isEmpty) {
        return;
      }

      final calendarEventsResult = await deviceCalendarPlugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(startDate: startDate, endDate: endDate),
      );

      if (calendarEventsResult.data == null) {
        return;
      }
      final calendarEvents = calendarEventsResult.data as List<Event>;
      for (final evt in calendarEvents) {
        await deviceCalendarPlugin.deleteEvent(calendarId, evt.eventId);
      }
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'deletsEvents', content: 'deletsEvents ${e.toString()}');
    }
  }
}
