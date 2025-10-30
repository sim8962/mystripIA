import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import '../../helpers/fct.dart';
import '../ActsModels/typ_const.dart';
import 'vol_traite.dart';
import 'svolmodel.dart';

/// Modèle ObjectBox pour stocker les données traitées d'un vol en format String
/// Contient tous les champs calculés et cumuls pour optimiser les performances
/// Identique à VolTraiteModel mais tous les champs sont en String
@Entity()
class StringVolTraiteModel {
  @Id(assignable: true)
  int id;

  // ========== INFORMATIONS DE BASE ==========

  /// Type de vol (Vol, MEP, TAX, etc.)
  final String typ;

  /// Numéro de vol
  final String nVol;

  /// Date et heure de début (format string "dd/MM/yyyy HH:mm")
  final String sDebut;

  /// Date et heure de fin (format string "dd/MM/yyyy HH:mm")
  final String sFin;

  /// Code IATA départ
  final String depIata;

  /// Code IATA arrivée
  final String arrIata;

  /// Code ICAO départ
  final String depIcao;

  /// Code ICAO  arrivée
  final String arrIcao;

  /// Avion
  final String sAvion;

  /// Position du vol dans la période TSV ("debut tsv", "fin tsv", "dans tsv")
  final String tsv;

  /// Crews (stored as JSON string)
  final String crews;

  // ========== DURÉES CALCULÉES (format "XXhYY") ==========

  /// Durée brute (dtFin - dtDebut)
  final String sDureeBrute;

  /// Durée vol (pour type Vol uniquement)
  final String sDureevol;

  /// Durée MEP (pour types MEP et TAX)
  final String sDureeMep;

  /// Durée forfait Vol
  final String sDureeForfait;

  /// Durée forfait MEP
  final String sMepForfait;

  /// Durée de nuit Vol
  final String sNuitVol;

  /// Durée de nuit forfait Vol
  final String sNuitForfait;

  // ========== CUMULS MENSUELS (format "XXhYY") ==========

  /// Cumul mensuel durée Vol
  final String sCumulDureeVol;

  /// Cumul mensuel durée MEP
  final String sCumulDureeMep;

  /// Cumul mensuel forfait Vol
  final String sCumulDureeForfait;

  /// Cumul mensuel forfait MEP
  final String sCumulMepForfait;

  /// Cumul mensuel nuit Vol
  final String sCumulNuitVol;

  /// Cumul mensuel nuit forfait Vol
  final String sCumulNuitForfait;

  // ========== DATES CALCULÉES (format string) ==========

  /// Heure d'arrivée forfait Vol (format string "HH:mm")
  final String sArrForfait;

  /// Heure d'arrivée forfait MEP (format string "HH:mm")
  final String sArrMepForfait;

  /// Lever du soleil (format string "HH:mm")
  final String sSunrise;

  /// Coucher du soleil (format string "HH:mm")
  final String sSunset;

  // ========== MÉTADONNÉES ==========

  /// Date de calcul/traitement (format string "dd/MM/yyyy HH:mm")
  final String sDateTraitement;

  /// Mois de référence pour les cumuls (format YYYY-MM)
  final String moisReference;

  StringVolTraiteModel({
    this.id = 0,
    required this.typ,
    required this.nVol,
    required this.sDebut,
    required this.sFin,
    required this.depIata,
    required this.arrIata,
    required this.depIcao,
    required this.arrIcao,
    required this.sAvion,
    required this.tsv,
    required this.crews,
    required this.sDureeBrute,
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
    required this.sArrForfait,
    required this.sArrMepForfait,
    required this.sSunrise,
    required this.sSunset,
    required this.sDateTraitement,
    required this.moisReference,
  });

  /// Factory: Create StringVolTraiteModel from VolTraiteModel
  factory StringVolTraiteModel.fromVolTraiteModel(VolTraiteModel volTraite) {
    return StringVolTraiteModel(
      id: volTraite.id,
      typ: volTraite.typ,
      nVol: volTraite.nVol,
      sDebut: volTraite.sDebut,
      sFin: volTraite.sFin,
      depIata: volTraite.depIata,
      arrIata: volTraite.arrIata,
      depIcao: volTraite.depIcao,
      arrIcao: volTraite.arrIcao,
      sAvion: volTraite.sAvion,
      tsv: volTraite.tsv,
      crews: volTraite.crews,
      sDureeBrute: volTraite.sDureeBrute,
      sDureevol: volTraite.sDureevol,
      sDureeMep: volTraite.sDureeMep,
      sDureeForfait: volTraite.sDureeForfait,
      sMepForfait: volTraite.sMepForfait,
      sNuitVol: volTraite.sNuitVol,
      sNuitForfait: volTraite.sNuitForfait,
      sCumulDureeVol: volTraite.sCumulDureeVol,
      sCumulDureeMep: volTraite.sCumulDureeMep,
      sCumulDureeForfait: volTraite.sCumulDureeForfait,
      sCumulMepForfait: volTraite.sCumulMepForfait,
      sCumulNuitVol: volTraite.sCumulNuitVol,
      sCumulNuitForfait: volTraite.sCumulNuitForfait,
      sArrForfait: volTraite.sArrForfait,
      sArrMepForfait: volTraite.sArrMepForfait,
      sSunrise: volTraite.sSunrise,
      sSunset: volTraite.sSunset,
      sDateTraitement: volTraite.sDateTraitement,
      moisReference: volTraite.moisReference,
    );
  }

  /// Factory: Create StringVolTraiteModel from StringVolModel with monthly cumuls
  /// Calculates cumulative values from month start to this vol's date
  factory StringVolTraiteModel.fromStringVolModel(
    StringVolModel stringVol,
    List<StringVolModel> allVolsInMonth,
  ) {
    try {
      // Parse dates from string format
      final dtDebut = Fct.parseDateTimeFromString(stringVol.sDebut);

      // Calculate cumuls from month start to this vol
      final sCumulDureeVol = _calculateCumulDureeVol(stringVol, allVolsInMonth);
      final sCumulDureeMep = _calculateCumulDureeMep(stringVol, allVolsInMonth);
      final sCumulDureeForfait = _calculateCumulDureeForfait(stringVol, allVolsInMonth);
      final sCumulMepForfait = _calculateCumulMepForfait(stringVol, allVolsInMonth);
      final sCumulNuitVol = _calculateCumulNuitVol(stringVol, allVolsInMonth);
      final sCumulNuitForfait = _calculateCumulNuitForfait(stringVol, allVolsInMonth);

      // Mois de référence
      final moisRef = Fct.formatMonthReference(dtDebut);

      // Date de traitement
      final now = DateTime.now();
      final sDateTraitement = Fct.formatDateTimeFullToString(now);

      return StringVolTraiteModel(
        id: stringVol.id,
        typ: stringVol.typ,
        nVol: stringVol.nVol,
        sDebut: stringVol.sDebut,
        sFin: stringVol.sFin,
        depIata: stringVol.depIata,
        arrIata: stringVol.arrIata,
        depIcao: stringVol.depIcao,
        arrIcao: stringVol.arrIcao,
        sAvion: stringVol.sAvion,
        tsv: stringVol.tsv,
        crews: stringVol.crews,
        sDureeBrute: stringVol.sDureevol.isNotEmpty
            ? stringVol.sDureevol
            : (stringVol.sDureeMep.isNotEmpty ? stringVol.sDureeMep : '00h00'),
        sDureevol: stringVol.sDureevol,
        sDureeMep: stringVol.sDureeMep,
        sDureeForfait: stringVol.sDureeForfait,
        sMepForfait: stringVol.sMepForfait,
        sNuitVol: stringVol.sNuitVol,
        sNuitForfait: stringVol.sNuitForfait,
        sCumulDureeVol: sCumulDureeVol,
        sCumulDureeMep: sCumulDureeMep,
        sCumulDureeForfait: sCumulDureeForfait,
        sCumulMepForfait: sCumulMepForfait,
        sCumulNuitVol: sCumulNuitVol,
        sCumulNuitForfait: sCumulNuitForfait,
        sArrForfait: '', // Will be calculated from forfait
        sArrMepForfait: '', // Will be calculated from forfait
        sSunrise: '', // Will be calculated from sunrise
        sSunset: '', // Will be calculated from sunset
        sDateTraitement: sDateTraitement,
        moisReference: moisRef,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ========== CUMUL CALCULATION METHODS ==========

  /// Calculate cumulative Vol duration from month start to this vol
  /// Only includes duration that falls within the same month
  static String _calculateCumulDureeVol(
    StringVolModel referenceVol,
    List<StringVolModel> allVols,
  ) {
    try {
      final refDate = Fct.parseDateTimeFromString(referenceVol.sDebut);
      final monthStart = DateTime(refDate.year, refDate.month, 1);
      final monthEnd = DateTime(refDate.year, refDate.month + 1, 1).subtract(const Duration(days: 1));

      Duration cumul = Duration.zero;

      for (var vol in allVols) {
        if (vol.typ != tVol.typ) continue;

        final volDate = Fct.parseDateTimeFromString(vol.sDebut);

        // Only include vols up to and including reference vol
        if (volDate.isAfter(refDate)) break;

        // Only include vols that start or end in this month
        final volEndDate = Fct.parseDateTimeFromString(vol.sFin);
        if (volEndDate.isBefore(monthStart) || volDate.isAfter(monthEnd)) continue;

        // Add duration, but only the part that falls within this month
        final duration = Fct.stringToDuration(vol.sDureevol);
        cumul = cumul + duration;
      }

      return Fct.durationToString(cumul);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative MEP duration from month start to this vol
  static String _calculateCumulDureeMep(
    StringVolModel referenceVol,
    List<StringVolModel> allVols,
  ) {
    try {
      final refDate = Fct.parseDateTimeFromString(referenceVol.sDebut);
      final monthStart = DateTime(refDate.year, refDate.month, 1);
      final monthEnd = DateTime(refDate.year, refDate.month + 1, 1).subtract(const Duration(days: 1));

      Duration cumul = Duration.zero;

      for (var vol in allVols) {
        if (vol.typ != tMEP.typ && vol.typ != tTAX.typ) continue;

        final volDate = Fct.parseDateTimeFromString(vol.sDebut);

        // Only include vols up to and including reference vol
        if (volDate.isAfter(refDate)) break;

        // Only include vols that start or end in this month
        final volEndDate = Fct.parseDateTimeFromString(vol.sFin);
        if (volEndDate.isBefore(monthStart) || volDate.isAfter(monthEnd)) continue;

        // Add duration
        final duration = Fct.stringToDuration(vol.sDureeMep);
        cumul = cumul + duration;
      }

      return Fct.durationToString(cumul);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative Vol forfait duration from month start to this vol
  static String _calculateCumulDureeForfait(
    StringVolModel referenceVol,
    List<StringVolModel> allVols,
  ) {
    try {
      final refDate = Fct.parseDateTimeFromString(referenceVol.sDebut);
      final monthStart = DateTime(refDate.year, refDate.month, 1);
      final monthEnd = DateTime(refDate.year, refDate.month + 1, 1).subtract(const Duration(days: 1));

      Duration cumul = Duration.zero;

      for (var vol in allVols) {
        if (vol.typ != tVol.typ) continue;

        final volDate = Fct.parseDateTimeFromString(vol.sDebut);

        // Only include vols up to and including reference vol
        if (volDate.isAfter(refDate)) break;

        // Only include vols that start or end in this month
        final volEndDate = Fct.parseDateTimeFromString(vol.sFin);
        if (volEndDate.isBefore(monthStart) || volDate.isAfter(monthEnd)) continue;

        // Add forfait duration
        final duration = Fct.stringToDuration(vol.sDureeForfait);
        cumul = cumul + duration;
      }

      return Fct.durationToString(cumul);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative MEP forfait duration from month start to this vol
  static String _calculateCumulMepForfait(
    StringVolModel referenceVol,
    List<StringVolModel> allVols,
  ) {
    try {
      final refDate = Fct.parseDateTimeFromString(referenceVol.sDebut);
      final monthStart = DateTime(refDate.year, refDate.month, 1);
      final monthEnd = DateTime(refDate.year, refDate.month + 1, 1).subtract(const Duration(days: 1));

      Duration cumul = Duration.zero;

      for (var vol in allVols) {
        if (vol.typ != tMEP.typ && vol.typ != tTAX.typ) continue;

        final volDate = Fct.parseDateTimeFromString(vol.sDebut);

        // Only include vols up to and including reference vol
        if (volDate.isAfter(refDate)) break;

        // Only include vols that start or end in this month
        final volEndDate = Fct.parseDateTimeFromString(vol.sFin);
        if (volEndDate.isBefore(monthStart) || volDate.isAfter(monthEnd)) continue;

        // Add MEP forfait duration
        final duration = Fct.stringToDuration(vol.sMepForfait);
        cumul = cumul + duration;
      }

      return Fct.durationToString(cumul);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative Vol night flight duration from month start to this vol
  static String _calculateCumulNuitVol(
    StringVolModel referenceVol,
    List<StringVolModel> allVols,
  ) {
    try {
      final refDate = Fct.parseDateTimeFromString(referenceVol.sDebut);
      final monthStart = DateTime(refDate.year, refDate.month, 1);
      final monthEnd = DateTime(refDate.year, refDate.month + 1, 1).subtract(const Duration(days: 1));

      Duration cumul = Duration.zero;

      for (var vol in allVols) {
        if (vol.typ != tVol.typ) continue;

        final volDate = Fct.parseDateTimeFromString(vol.sDebut);

        // Only include vols up to and including reference vol
        if (volDate.isAfter(refDate)) break;

        // Only include vols that start or end in this month
        final volEndDate = Fct.parseDateTimeFromString(vol.sFin);
        if (volEndDate.isBefore(monthStart) || volDate.isAfter(monthEnd)) continue;

        // Add night flight duration
        final duration = Fct.stringToDuration(vol.sNuitVol);
        cumul = cumul + duration;
      }

      return Fct.durationToString(cumul);
    } catch (e) {
      return '00h00';
    }
  }

  /// Calculate cumulative Vol night flight forfait duration from month start to this vol
  static String _calculateCumulNuitForfait(
    StringVolModel referenceVol,
    List<StringVolModel> allVols,
  ) {
    try {
      final refDate = Fct.parseDateTimeFromString(referenceVol.sDebut);
      final monthStart = DateTime(refDate.year, refDate.month, 1);
      final monthEnd = DateTime(refDate.year, refDate.month + 1, 1).subtract(const Duration(days: 1));

      Duration cumul = Duration.zero;

      for (var vol in allVols) {
        if (vol.typ != tVol.typ) continue;

        final volDate = Fct.parseDateTimeFromString(vol.sDebut);

        // Only include vols up to and including reference vol
        if (volDate.isAfter(refDate)) break;

        // Only include vols that start or end in this month
        final volEndDate = Fct.parseDateTimeFromString(vol.sFin);
        if (volEndDate.isBefore(monthStart) || volDate.isAfter(monthEnd)) continue;

        // Add night flight forfait duration
        final duration = Fct.stringToDuration(vol.sNuitForfait);
        cumul = cumul + duration;
      }

      return Fct.durationToString(cumul);
    } catch (e) {
      return '00h00';
    }
  }

  // ========== GETTER METHODS ==========

  /// Check if this is a flight type (Vol, MEP, or TAX)
  bool get isFlightType => typ == tVol.typ || typ == tMEP.typ || typ == tTAX.typ;

  /// Check if this is a Vol type
  bool get isVolType => typ == tVol.typ;

  /// Check if this is a MEP or TAX type
  bool get isMepOrTaxType => typ == tMEP.typ || typ == tTAX.typ;

  /// Decode crews from JSON
  List<Map<String, String>> get crewsList {
    try {
      final decoded = jsonDecode(crews);
      return (decoded as List).map((item) => Map<String, String>.from(item as Map)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  String toString() {
    return 'StringVolTraiteModel(id: $id, typ: $typ, nVol: $nVol, sDebut: $sDebut, cumuls: Vol=$sCumulDureeVol, MEP=$sCumulDureeMep)';
  }
}
