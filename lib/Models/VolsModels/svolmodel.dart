import 'package:objectbox/objectbox.dart';
import 'dart:convert';
import '../../controllers/database_controller.dart';
import '../../helpers/fct.dart';
import '../ActsModels/typ_const.dart';
import '../jsonModels/datas/airport_model.dart';
import 'vol.dart';

/// Modèle ObjectBox pour stocker les données de VolModel en format String
/// Optimisé pour le stockage en base de données avec tous les champs en String
@Entity()
class StringVolModel {
  @Id(assignable: true)
  int id;

  // ========== INFORMATIONS DE BASE ==========
  final String cle; // Unique key
  final String typ; // Flight type (Vol, MEP, TAX, HTL, etc.)
  final String nVol; // Flight number
  final String sAvion; // Aircraft type
  final String tsv; // TSV position ("debut tsv", "fin tsv", "dans tsv")
  final String crews; // Crews (stored as JSON string)

  // ========== DATES (format "dd/MM/yyyy HH:mm") ==========
  final String sDebut; // Departure date/time
  final String sFin; // Arrival date/time

  // ========== CODES AEROPORTS ==========
  final String depIata; // Departure IATA code
  final String arrIata; // Arrival IATA code
  final String depIcao; // Departure ICAO code
  final String arrIcao; // Arrival ICAO code

  // ========== DURÉES (format "XXhYY") ==========
  final String sDureevol; // Duration for Vol type
  final String sDureeMep; // Duration for MEP/TAX types
  final String sDureeForfait; // Forfait duration for Vol type
  final String sMepForfait; // Forfait duration for MEP/TAX types
  final String sNuitVol; // Night flight duration for Vol type
  final String sNuitForfait; // Night flight forfait duration for Vol type

  // ========== CUMULS MENSUELS (format "XXhYY") ==========
  final String sCumulDureeVol; // Monthly cumulative Vol duration
  final String sCumulDureeMep; // Monthly cumulative MEP duration
  final String sCumulDureeForfait; // Monthly cumulative Vol forfait
  final String sCumulMepForfait; // Monthly cumulative MEP forfait
  final String sCumulNuitVol; // Monthly cumulative night Vol
  final String sCumulNuitForfait; // Monthly cumulative night forfait

  StringVolModel({
    this.id = 0,
    required this.cle,
    required this.typ,
    required this.nVol,
    required this.sAvion,
    required this.tsv,
    required this.crews,
    required this.sDebut,
    required this.sFin,
    required this.depIata,
    required this.arrIata,
    required this.depIcao,
    required this.arrIcao,
    required this.sDureevol,
    required this.sDureeMep,
    required this.sDureeForfait,
    required this.sMepForfait,
    required this.sNuitVol,
    required this.sNuitForfait,
    required this.sCumulDureeVol,
    required this.sCumulDureeMep,
    required this.sCumulDureeForfait,
    required this.sCumulMepForfait,
    required this.sCumulNuitVol,
    required this.sCumulNuitForfait,
  });

  /// Factory: Create StringVolModel from VolModel
  /// Converts all DateTime and Duration fields to String format
  factory StringVolModel.fromVolModel(VolModel volModel) {
    try {
      // Get ICAO codes (avoid multiple calls to DatabaseController)
      final depIcao = DatabaseController.instance.getIcaoByIata(volModel.depIata);
      final arrIcao = DatabaseController.instance.getIcaoByIata(volModel.arrIata);

      // Calculate MEP duration if needed
      final sMepvol = (volModel.typ == tMEP.typ || volModel.typ == tTAX.typ)
          ? Fct.durationToString(volModel.dtFin.difference(volModel.dtDebut))
          : Fct.durationToString(Duration.zero);

      // Calculate Vol duration if needed
      final sDureevol = (volModel.typ == tVol.typ)
          ? Fct.durationToString(volModel.dtFin.difference(volModel.dtDebut))
          : Fct.durationToString(Duration.zero);

      // Calculate sunrise and sunset for Vol type
      DateTime? sunrise;
      DateTime? sunset;
      if (volModel.typ == tVol.typ) {
        sunrise = volModel.sunrise ??
            AeroportModel.calculateSunrise(
              volModel.typ,
              depIcao,
              arrIcao,
              volModel.dtDebut,
            );
        sunset = volModel.sunset ??
            AeroportModel.calculateSunset(
              volModel.typ,
              depIcao,
              arrIcao,
              volModel.dtDebut,
            );
      }

      // Calculate night flight time for Vol type
      final sNuitVol = (volModel.typ == tVol.typ)
          ? _calculateNightFlightTime(
              volModel.typ,
              sunrise,
              sunset,
              volModel.dtDebut,
              volModel.dtFin,
            )
          : Fct.durationToString(Duration.zero);

      // Get forfait value if user is PNT and Vol type
      final isPnt = DatabaseController.instance.currentUser?.isPnt ?? false;
      String sDureeForfait = '';
      String sMepForfait = '';
      DateTime? arrForfait;
      String sNuitForfait = '';

      if (isPnt && volModel.typ == tVol.typ) {
        sDureeForfait = _getForfaitValue(
          volModel.typ,
          depIcao,
          arrIcao,
          volModel.dtDebut,
          volModel.dtFin,
        );
        arrForfait = _calculateArrForfait(
          volModel.typ,
          volModel.dtDebut,
          sDureeForfait,
        );
        sNuitForfait = _calculateNightFlightTime(
          volModel.typ,
          sunrise,
          sunset,
          volModel.dtDebut,
          arrForfait,
        );
      } else if (isPnt && (volModel.typ == tMEP.typ || volModel.typ == tTAX.typ)) {
        sMepForfait = _getForfaitValue(
          volModel.typ,
          depIcao,
          arrIcao,
          volModel.dtDebut,
          volModel.dtFin,
        );
      }

      return StringVolModel(
        id: volModel.id,
        cle: volModel.cle,
        typ: volModel.typ,
        nVol: volModel.nVol,
        sAvion: volModel.sAvion,
        tsv: volModel.tsv,
        crews: volModel.crews.isEmpty ? '[]' : _crewsToJson(volModel.crews),
        sDebut: Fct.formatDateTimeToString(volModel.dtDebut),
        sFin: Fct.formatDateTimeToString(volModel.dtFin),
        depIata: volModel.depIata,
        arrIata: volModel.arrIata,
        depIcao: depIcao,
        arrIcao: arrIcao,
        sDureevol: sDureevol,
        sDureeMep: sMepvol,
        sDureeForfait: sDureeForfait,
        sMepForfait: sMepForfait,
        sNuitVol: sNuitVol,
        sNuitForfait: sNuitForfait,
        sCumulDureeVol: '00h00',
        sCumulDureeMep: '00h00',
        sCumulDureeForfait: '00h00',
        sCumulMepForfait: '00h00',
        sCumulNuitVol: '00h00',
        sCumulNuitForfait: '00h00',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Factory: Create StringVolModel with monthly cumulative calculations
  /// Calculates cumulative values from the start of the month to the current flight (inclusive)
  factory StringVolModel.withMonthlyCumuls(
    VolModel volModel,
    List<VolModel> allVolsInMonth,
  ) {
    // First create the base StringVolModel
    final baseStringVol = StringVolModel.fromVolModel(volModel);

    // Calculate monthly cumuls
    final sCumulDureeVol = _calculateCumulDureeVol(volModel, allVolsInMonth);
    final sCumulDureeMep = _calculateCumulDureeMep(volModel, allVolsInMonth);
    final sCumulDureeForfait = _calculateCumulDureeForfait(volModel, allVolsInMonth);
    final sCumulMepForfait = _calculateCumulMepForfait(volModel, allVolsInMonth);
    final sCumulNuitVol = _calculateCumulNuitVol(volModel, allVolsInMonth);
    final sCumulNuitForfait = _calculateCumulNuitForfait(volModel, allVolsInMonth);

    // Return new instance with cumuls
    return StringVolModel(
      id: baseStringVol.id,
      cle: baseStringVol.cle,
      typ: baseStringVol.typ,
      nVol: baseStringVol.nVol,
      sAvion: baseStringVol.sAvion,
      tsv: baseStringVol.tsv,
      crews: baseStringVol.crews,
      sDebut: baseStringVol.sDebut,
      sFin: baseStringVol.sFin,
      depIata: baseStringVol.depIata,
      arrIata: baseStringVol.arrIata,
      depIcao: baseStringVol.depIcao,
      arrIcao: baseStringVol.arrIcao,
      sDureevol: baseStringVol.sDureevol,
      sDureeMep: baseStringVol.sDureeMep,
      sDureeForfait: baseStringVol.sDureeForfait,
      sMepForfait: baseStringVol.sMepForfait,
      sNuitVol: baseStringVol.sNuitVol,
      sNuitForfait: baseStringVol.sNuitForfait,
      sCumulDureeVol: sCumulDureeVol,
      sCumulDureeMep: sCumulDureeMep,
      sCumulDureeForfait: sCumulDureeForfait,
      sCumulMepForfait: sCumulMepForfait,
      sCumulNuitVol: sCumulNuitVol,
      sCumulNuitForfait: sCumulNuitForfait,
    );
  }

  // ========== HELPER METHODS ==========

  /// Convert crews to JSON string
  static String _crewsToJson(dynamic crews) {
    try {
      if (crews is List) {
        return jsonEncode(crews);
      }
      return '[]';
    } catch (e) {
      return '[]';
    }
  }

  /// Check if type requires flight calculations
  static bool _requiresFlightCalculations(String typ) =>
      typ == tVol.typ || typ == tMEP.typ || typ == tTAX.typ;

  /// Get forfait value from database
  static String _getForfaitValue(
    String typ,
    String depIcao,
    String arrIcao,
    DateTime dtDebut,
    DateTime dtFin,
  ) {
    if (!_requiresFlightCalculations(typ)) return '';

    try {
      final saison = (dtDebut.month >= 5 && dtDebut.month <= 10) ? "ETE" : "HIVER";
      final cle = '$saison' 'MACHMC$depIcao$arrIcao';
      final forfaitModel = DatabaseController.instance.getForfaitByKey(cle);

      // If forfait not found in database, use durationString as fallback
      if (forfaitModel == null) {
        return Fct.durationToString(dtFin.difference(dtDebut));
      }

      // Ensure forfait is in 5-character format (e.g., "02h30")
      return forfaitModel.forfait.padLeft(5, '0');
    } catch (e) {
      // If error, use durationString as fallback
      return Fct.durationToString(dtFin.difference(dtDebut));
    }
  }

  /// Calculate arrival time based on forfait
  static DateTime? _calculateArrForfait(String typ, DateTime dtDebut, String forfait) {
    if (!_requiresFlightCalculations(typ)) return null;
    if (forfait.isEmpty) return null;

    try {
      // Parse forfait string (format: "02h30") using Fct
      final duration = Fct.stringToDuration(forfait);
      if (duration == Duration.zero) return null;
      return dtDebut.add(duration);
    } catch (e) {
      return null;
    }
  }

  /// Calculate night flight time
  static String _calculateNightFlightTime(
    String typ,
    DateTime? sunrise,
    DateTime? sunset,
    DateTime dtDebut,
    DateTime? dtFin,
  ) {
    if (!_requiresFlightCalculations(typ)) return '';
    if (sunset == null || sunrise == null || dtFin == null) {
      return '00h00';
    }

    // Night period starts at sunset and ends at sunrise (next day if needed)
    DateTime nightStart = sunset;
    DateTime nightEnd = sunrise;

    // If sunrise is before sunset, it means sunrise is the next day
    if (nightEnd.isBefore(nightStart)) {
      nightEnd = nightEnd.add(const Duration(days: 1));
    }

    // Flight period
    DateTime flightStart = dtDebut;
    DateTime flightEnd = dtFin;

    // Calculate overlap between flight period and night period
    DateTime overlapStart = flightStart.isAfter(nightStart) ? flightStart : nightStart;
    DateTime overlapEnd = flightEnd.isBefore(nightEnd) ? flightEnd : nightEnd;

    // If there's no overlap, return zero
    if (overlapStart.isAfter(overlapEnd) || overlapStart.isAtSameMomentAs(overlapEnd)) {
      return '00h00';
    }

    final duration = overlapEnd.difference(overlapStart);
    return Fct.durationToString(duration);
  }

  // ========== CUMULATIVE CALCULATION METHODS ==========

  /// Calculate cumulative Vol duration from start of month to current flight (inclusive)
  /// Only counts flights that start or end in the same month
  static String _calculateCumulDureeVol(VolModel currentVol, List<VolModel> allVolsInMonth) {
    try {
      Duration totalDuration = Duration.zero;
      final currentMonth = currentVol.dtDebut.month;
      final currentYear = currentVol.dtDebut.year;

      for (var vol in allVolsInMonth) {
        // Only process Vol type flights
        if (vol.typ != tVol.typ) continue;

        // Only include flights up to and including current flight
        if (vol.dtDebut.isAfter(currentVol.dtDebut)) continue;

        // Only count flights that start or end in the same month
        final volStartMonth = vol.dtDebut.month;
        final volStartYear = vol.dtDebut.year;
        final volEndMonth = vol.dtFin.month;
        final volEndYear = vol.dtFin.year;

        if ((volStartMonth == currentMonth && volStartYear == currentYear) ||
            (volEndMonth == currentMonth && volEndYear == currentYear)) {
          // Calculate duration within the month
          DateTime startInMonth = vol.dtDebut;
          DateTime endInMonth = vol.dtFin;

          // If flight starts before month, start from first day of month
          if (volStartMonth != currentMonth || volStartYear != currentYear) {
            startInMonth = DateTime(currentYear, currentMonth, 1);
          }

          // If flight ends after month, end at last day of month
          if (volEndMonth != currentMonth || volEndYear != currentYear) {
            final lastDay = DateTime(currentYear, currentMonth + 1, 0).day;
            endInMonth = DateTime(currentYear, currentMonth, lastDay, 23, 59, 59);
          }

          totalDuration += endInMonth.difference(startInMonth);
        }
      }

      return Fct.durationToString(totalDuration);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative MEP duration from start of month to current flight (inclusive)
  static String _calculateCumulDureeMep(VolModel currentVol, List<VolModel> allVolsInMonth) {
    try {
      Duration totalDuration = Duration.zero;
      final currentMonth = currentVol.dtDebut.month;
      final currentYear = currentVol.dtDebut.year;

      for (var vol in allVolsInMonth) {
        // Only process MEP/TAX type flights
        if (vol.typ != tMEP.typ && vol.typ != tTAX.typ) continue;

        // Only include flights up to and including current flight
        if (vol.dtDebut.isAfter(currentVol.dtDebut)) continue;

        // Only count flights that start or end in the same month
        final volStartMonth = vol.dtDebut.month;
        final volStartYear = vol.dtDebut.year;
        final volEndMonth = vol.dtFin.month;
        final volEndYear = vol.dtFin.year;

        if ((volStartMonth == currentMonth && volStartYear == currentYear) ||
            (volEndMonth == currentMonth && volEndYear == currentYear)) {
          DateTime startInMonth = vol.dtDebut;
          DateTime endInMonth = vol.dtFin;

          if (volStartMonth != currentMonth || volStartYear != currentYear) {
            startInMonth = DateTime(currentYear, currentMonth, 1);
          }

          if (volEndMonth != currentMonth || volEndYear != currentYear) {
            final lastDay = DateTime(currentYear, currentMonth + 1, 0).day;
            endInMonth = DateTime(currentYear, currentMonth, lastDay, 23, 59, 59);
          }

          totalDuration += endInMonth.difference(startInMonth);
        }
      }

      return Fct.durationToString(totalDuration);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative Vol forfait duration from start of month to current flight (inclusive)
  static String _calculateCumulDureeForfait(VolModel currentVol, List<VolModel> allVolsInMonth) {
    try {
      Duration totalDuration = Duration.zero;
      final currentMonth = currentVol.dtDebut.month;
      final currentYear = currentVol.dtDebut.year;

      for (var vol in allVolsInMonth) {
        // Only process Vol type flights
        if (vol.typ != tVol.typ) continue;

        // Only include flights up to and including current flight
        if (vol.dtDebut.isAfter(currentVol.dtDebut)) continue;

        // Only count flights that start or end in the same month
        final volStartMonth = vol.dtDebut.month;
        final volStartYear = vol.dtDebut.year;
        final volEndMonth = vol.dtFin.month;
        final volEndYear = vol.dtFin.year;

        if ((volStartMonth == currentMonth && volStartYear == currentYear) ||
            (volEndMonth == currentMonth && volEndYear == currentYear)) {
          // Use forfait duration if available, otherwise actual duration
          final forfaitStr = vol.sDureeForfait?.isNotEmpty == true ? vol.sDureeForfait : vol.sDureevol;
          if (forfaitStr != null && forfaitStr.isNotEmpty) {
            final duration = Fct.stringToDuration(forfaitStr);
            totalDuration += duration;
          }
        }
      }

      return Fct.durationToString(totalDuration);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative MEP forfait duration from start of month to current flight (inclusive)
  static String _calculateCumulMepForfait(VolModel currentVol, List<VolModel> allVolsInMonth) {
    try {
      Duration totalDuration = Duration.zero;
      final currentMonth = currentVol.dtDebut.month;
      final currentYear = currentVol.dtDebut.year;

      for (var vol in allVolsInMonth) {
        // Only process MEP/TAX type flights
        if (vol.typ != tMEP.typ && vol.typ != tTAX.typ) continue;

        // Only include flights up to and including current flight
        if (vol.dtDebut.isAfter(currentVol.dtDebut)) continue;

        // Only count flights that start or end in the same month
        final volStartMonth = vol.dtDebut.month;
        final volStartYear = vol.dtDebut.year;
        final volEndMonth = vol.dtFin.month;
        final volEndYear = vol.dtFin.year;

        if ((volStartMonth == currentMonth && volStartYear == currentYear) ||
            (volEndMonth == currentMonth && volEndYear == currentYear)) {
          // Use forfait duration if available, otherwise actual duration
          final forfaitStr = vol.sMepForfait?.isNotEmpty == true ? vol.sMepForfait : vol.sDureeMep;
          if (forfaitStr != null && forfaitStr.isNotEmpty) {
            final duration = Fct.stringToDuration(forfaitStr);
            totalDuration += duration;
          }
        }
      }

      return Fct.durationToString(totalDuration);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative night Vol duration from start of month to current flight (inclusive)
  static String _calculateCumulNuitVol(VolModel currentVol, List<VolModel> allVolsInMonth) {
    try {
      Duration totalDuration = Duration.zero;
      final currentMonth = currentVol.dtDebut.month;
      final currentYear = currentVol.dtDebut.year;

      for (var vol in allVolsInMonth) {
        // Only process Vol type flights
        if (vol.typ != tVol.typ) continue;

        // Only include flights up to and including current flight
        if (vol.dtDebut.isAfter(currentVol.dtDebut)) continue;

        // Only count flights that start or end in the same month
        final volStartMonth = vol.dtDebut.month;
        final volStartYear = vol.dtDebut.year;
        final volEndMonth = vol.dtFin.month;
        final volEndYear = vol.dtFin.year;

        if ((volStartMonth == currentMonth && volStartYear == currentYear) ||
            (volEndMonth == currentMonth && volEndYear == currentYear)) {
          if (vol.sNuitVol != null && vol.sNuitVol!.isNotEmpty) {
            final duration = Fct.stringToDuration(vol.sNuitVol!);
            totalDuration += duration;
          }
        }
      }

      return Fct.durationToString(totalDuration);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative night forfait duration from start of month to current flight (inclusive)
  static String _calculateCumulNuitForfait(VolModel currentVol, List<VolModel> allVolsInMonth) {
    try {
      Duration totalDuration = Duration.zero;
      final currentMonth = currentVol.dtDebut.month;
      final currentYear = currentVol.dtDebut.year;

      for (var vol in allVolsInMonth) {
        // Only process Vol type flights
        if (vol.typ != tVol.typ) continue;

        // Only include flights up to and including current flight
        if (vol.dtDebut.isAfter(currentVol.dtDebut)) continue;

        // Only count flights that start or end in the same month
        final volStartMonth = vol.dtDebut.month;
        final volStartYear = vol.dtDebut.year;
        final volEndMonth = vol.dtFin.month;
        final volEndYear = vol.dtFin.year;

        if ((volStartMonth == currentMonth && volStartYear == currentYear) ||
            (volEndMonth == currentMonth && volEndYear == currentYear)) {
          if (vol.sNuitForfait != null && vol.sNuitForfait!.isNotEmpty) {
            final duration = Fct.stringToDuration(vol.sNuitForfait!);
            totalDuration += duration;
          }
        }
      }

      return Fct.durationToString(totalDuration);
    } catch (e) {
      return '00h00';
    }
  }

  @override
  String toString() =>
      'StringVolModel(cle: $cle, typ: $typ, nVol: $nVol, sDebut: $sDebut, sFin: $sFin, depIata: $depIata, arrIata: $arrIata)';
}
