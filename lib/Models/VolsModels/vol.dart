import 'package:objectbox/objectbox.dart';
import 'package:adhan_dart/adhan_dart.dart';
import '../ActsModels/crew.dart';
import '../../controllers/database_controller.dart';
import '../ActsModels/typ_const.dart';
import '../volpdfs/vol_pdf.dart';
import '../../helpers/fct.dart';

@Entity()
class VolModel {
  @Id(assignable: true)
  int id;
  final String cle;

  final String typ;
  final String nVol;
  @Property(type: PropertyType.date)
  late DateTime dtDebut;
  final String depIata; // Departure IATA code
  final String depIcao; // Departure ICAO code
  final String arrIata; // Arrival IATA code
  final String arrIcao; // Arrival ICAO code
  @Property(type: PropertyType.date)
  late DateTime dtFin;
  late String label;
  String sAvion;
  String? sDureevol; // Duration in hhHmm format for Vol type only
  String? sDureeMep; // Duration in hhHmm format for MEP and TAX types
  @Property(type: PropertyType.date)
  DateTime? arrForfait; // Arrival time based on dtDebut + forfait for Vol type
  @Property(type: PropertyType.date)
  DateTime? arrMepForfait; // Arrival time based on dtDebut + forfait for MEP and TAX types
  @Property(type: PropertyType.date)
  DateTime? sunrise; // Le plus tôt des sunrise (départ, arrivée)
  @Property(type: PropertyType.date)
  DateTime? sunset; // Le plus tard des sunset (départ, arrivée)
  String? sNuitVol; // Night flight time in hhHmm format for Vol type only
  String? sDureeForfait; // Duration between dtDebut and arrForfait for Vol type
  String? sMepForfait; // Duration between dtDebut and arrMepForfait for MEP and TAX types
  String? sNuitForfait; // Night flight time for forfait duration (Vol type only)
  String tsv; // Position du vol dans la période TSV: "debut tsv", "fin tsv", "dans tsv"
  
  @Backlink('volModel')
  final crews = ToMany<Crew>();

  VolModel({
    this.id = 0,
    required this.typ,
    required this.nVol,
    required this.dtDebut,
    required this.depIata,
    required this.arrIata,
    required this.dtFin,
    String? depIcao,
    String? arrIcao,
    this.label = '',
    this.cle = '',
    this.sAvion = '',
    this.tsv = '',
    String? durationString,
    String? durationMepString,
    DateTime? arrForfait,
    DateTime? arrMepForfait,
    DateTime? sunrise,
    DateTime? sunset,
    String? nightFlightString,
    String? durationForfaitString,
    String? mepForfaitString,
    String? nightForfaitString,
  }) : depIcao = depIcao ?? _getIcaoByIata(depIata),
       arrIcao = arrIcao ?? _getIcaoByIata(arrIata) {
    // Calculate derived values only if not provided
    final resolvedDepIcao = this.depIcao;
    final resolvedArrIcao = this.arrIcao;

    // Séparer les calculs selon le type de vol
    if (typ == tVol.typ) {
      // Pour les vols normaux (Vol)
      sDureevol = durationString ?? _calculateDuration(typ, dtDebut, dtFin);
      sDureeMep = '';
      sDureeForfait =
          durationForfaitString ?? _getForfaitValue(typ, resolvedDepIcao, resolvedArrIcao, dtDebut, dtFin);
      sMepForfait = '';
      this.arrForfait = arrForfait ?? _calculateArrForfait(typ, dtDebut, sDureeForfait ?? '');
      this.arrMepForfait = null;
      this.sunrise = sunrise ?? _calculateSunrise(typ, resolvedDepIcao, resolvedArrIcao, dtDebut);
      this.sunset = sunset ?? _calculateSunset(typ, resolvedDepIcao, resolvedArrIcao, dtDebut);

      // Calculate night flight time for Vol type
      sNuitVol =
          nightFlightString ?? _calculateNightFlightTime(typ, this.sunrise, this.sunset, dtDebut, dtFin);
      sNuitForfait =
          nightForfaitString ??
          _calculateNightFlightTime(typ, this.sunrise, this.sunset, dtDebut, this.arrForfait);
    } else if (typ == tMEP.typ || typ == tTAX.typ) {
      // Pour MEP et TAX - pas de calcul de nuit
      sDureevol = '';
      sDureeMep = durationMepString ?? _calculateDuration(typ, dtDebut, dtFin);
      sDureeForfait = '';
      sMepForfait =
          mepForfaitString ?? _getForfaitValue(typ, resolvedDepIcao, resolvedArrIcao, dtDebut, dtFin);
      this.arrForfait = null;
      this.arrMepForfait = arrMepForfait ?? _calculateArrForfait(typ, dtDebut, sMepForfait ?? '');
      this.sunrise = null;
      this.sunset = null;
      sNuitVol = '';
      sNuitForfait = '';
    } else {
      // Pour les autres types
      sDureevol = '';
      sDureeMep = '';
      sDureeForfait = '';
      sMepForfait = '';
      this.arrForfait = null;
      this.arrMepForfait = null;
      this.sunrise = null;
      this.sunset = null;
      sNuitVol = '';
      sNuitForfait = '';
    }
  }

  // Check if this is a flight type (Vol, MEP, or TAX)
  bool get isFlightType => typ == tVol.typ || typ == tMEP.typ || typ == tTAX.typ;

  // Helper pour vérifier si le type nécessite des calculs de vol
  static bool _requiresFlightCalculations(String typ) =>
      typ == tVol.typ || typ == tMEP.typ || typ == tTAX.typ;

  // Helper method to get ICAO code from IATA using DatabaseController
  static String _getIcaoByIata(String iata) {
    try {
      final airports = DatabaseController.instance.airports;
      final airport = airports.firstWhere((airport) => airport.iata.toUpperCase() == iata.toUpperCase());
      return airport.icao;
    } catch (e) {
      return ''; // Return empty string if not found
    }
  }

  // Helper method to calculate duration string
  static String _calculateDuration(String typ, DateTime dtDebut, DateTime dtFin) {
    if (!_requiresFlightCalculations(typ)) return '';

    final duration = dtFin.difference(dtDebut);
    return Fct.durationToString(duration);
  }

  // Helper method to get forfait value from ForfaitModel
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
      final cle =
          '$saison'
          'MACHMC$depIcao$arrIcao';
      final forfaitModel = DatabaseController.instance.getForfaitByKey(cle);

      // If forfait not found in database, use durationString as fallback
      if (forfaitModel == null) {
        return _calculateDuration(typ, dtDebut, dtFin);
      }

      // Ensure forfait is in 5-character format (e.g., "02h30")
      return forfaitModel.forfait.padLeft(5, '0');
    } catch (e) {
      // If error, use durationString as fallback
      return _calculateDuration(typ, dtDebut, dtFin);
    }
  }

  // Helper method to calculate arrForfait (dtDebut + forfait)
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

  // Helper method to get prayer times for an airport
  static PrayerTimes? _getPrayerTimes(String icao, DateTime date) {
    try {
      final airport = DatabaseController.instance.getAeroportByOaci(icao);
      if (airport == null) return null;

      final coordinates = Coordinates(airport.latitude, airport.longitude);
      // Muslim World League: Fajr 18°, Isha 17°
      final params = CalculationParameters(
        method: CalculationMethod.muslimWorldLeague,
        fajrAngle: 18,
        ishaAngle: 17,
      );
      return PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params);
    } catch (e) {
      return null;
    }
  }

  // Helper method to calculate sunrise (le plus tôt des sunrise départ et arrivée)
  static DateTime? _calculateSunrise(String typ, String depIcao, String arrIcao, DateTime date) {
    if (!_requiresFlightCalculations(typ)) return null;

    try {
      final depPrayerTimes = _getPrayerTimes(depIcao, date);
      final arrPrayerTimes = _getPrayerTimes(arrIcao, date);

      final depSunrise = depPrayerTimes?.sunrise;
      final arrSunrise = arrPrayerTimes?.sunrise;

      // Return the earliest sunrise
      if (depSunrise != null && arrSunrise != null) {
        return depSunrise.isBefore(arrSunrise) ? depSunrise : arrSunrise;
      }
      return depSunrise ?? arrSunrise;
    } catch (e) {
      return null;
    }
  }

  // Helper method to calculate sunset (le plus tard des sunset départ et arrivée)
  static DateTime? _calculateSunset(String typ, String depIcao, String arrIcao, DateTime date) {
    if (!_requiresFlightCalculations(typ)) return null;

    try {
      final depPrayerTimes = _getPrayerTimes(depIcao, date);
      final arrPrayerTimes = _getPrayerTimes(arrIcao, date);

      final depSunset = depPrayerTimes?.maghrib;
      final arrSunset = arrPrayerTimes?.maghrib;

      // Return the latest sunset
      if (depSunset != null && arrSunset != null) {
        return depSunset.isAfter(arrSunset) ? depSunset : arrSunset;
      }
      return depSunset ?? arrSunset;
    } catch (e) {
      return null;
    }
  }

  // Helper method to calculate night flight time
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

  /// Factory pour créer un VolModel à partir d'un VolPdf
  /// Accepte les champs vides (from, to, activity) qui seront traités ultérieurement
  factory VolModel.fromVolPdf(VolPdf volPdf) {
    // Dates de départ et d'arrivée
    final dtDebut = volPdf.dateVol;
    final dtFin = VolPdf.parseDateTimeFromString(volPdf.myArrDate, volPdf.dateVol);

    // Codes IATA (peuvent être vides)
    final depIata = volPdf.from.isNotEmpty ? volPdf.from.toUpperCase() : '';
    final arrIata = volPdf.to.isNotEmpty ? volPdf.to.toUpperCase() : '';

    // Créer le VolModel
    return VolModel(
      id: 0, // ObjectBox génèrera l'ID
      typ: volPdf.duty.isNotEmpty ? volPdf.duty : '',
      nVol: volPdf.activity.isNotEmpty ? volPdf.activity : '',
      dtDebut: dtDebut,
      depIata: depIata,
      arrIata: arrIata,
      dtFin: dtFin,
      cle: volPdf.cle,
      sAvion: volPdf.aC.isNotEmpty ? volPdf.aC : '',
      tsv: '', // À déterminer selon la logique métier
    );
  }

  // Method to update ICAO codes manually if needed
  VolModel updateIcaoCodes() {
    return VolModel(
      id: id,
      typ: typ,
      nVol: nVol,
      dtDebut: dtDebut,
      depIata: depIata,
      arrIata: arrIata,
      dtFin: dtFin,
      depIcao: _getIcaoByIata(depIata),
      arrIcao: _getIcaoByIata(arrIata),
      label: label,
      cle: cle,
      sAvion: sAvion,
      tsv: tsv,
      durationString: sDureevol,
      durationMepString: sDureeMep,
      arrForfait: arrForfait,
      arrMepForfait: arrMepForfait,
      sunrise: sunrise,
      sunset: sunset,
      nightFlightString: sNuitVol,
      durationForfaitString: sDureeForfait,
      mepForfaitString: sMepForfait,
      nightForfaitString: sNuitForfait,
    );
  }

  // Method to update missing durationString and forfait values
  void updateMissingValues() {
    if (typ == tVol.typ) {
      // Pour les vols normaux (Vol)
      if (sDureevol == null || sDureevol!.isEmpty) {
        sDureevol = _calculateDuration(typ, dtDebut, dtFin);
      }
      if (sDureeForfait == null || sDureeForfait!.isEmpty) {
        sDureeForfait = _getForfaitValue(typ, depIcao, arrIcao, dtDebut, dtFin);
      }
      arrForfait ??= _calculateArrForfait(typ, dtDebut, sDureeForfait ?? '');
      sunrise ??= _calculateSunrise(typ, depIcao, arrIcao, dtDebut);
      sunset ??= _calculateSunset(typ, depIcao, arrIcao, dtDebut);

      // Update night flight time if missing
      sNuitVol ??= _calculateNightFlightTime(typ, sunrise, sunset, dtDebut, dtFin);
      sNuitForfait ??= _calculateNightFlightTime(typ, sunrise, sunset, dtDebut, arrForfait);

      // S'assurer que les champs MEP sont vides
      sDureeMep = '';
      sMepForfait = '';
    } else if (typ == tMEP.typ || typ == tTAX.typ) {
      // Pour MEP et TAX - pas de calcul de nuit
      if (sDureeMep == null || sDureeMep!.isEmpty) {
        sDureeMep = _calculateDuration(typ, dtDebut, dtFin);
      }
      if (sMepForfait == null || sMepForfait!.isEmpty) {
        sMepForfait = _getForfaitValue(typ, depIcao, arrIcao, dtDebut, dtFin);
      }
      arrMepForfait ??= _calculateArrForfait(typ, dtDebut, sMepForfait ?? '');

      // S'assurer que les champs Vol et nuit sont vides
      sDureevol = '';
      sDureeForfait = '';
      sNuitVol = '';
      sNuitForfait = '';
      sunrise = null;
      sunset = null;
    }
  }

  // Helper method to get airport name by IATA
  static String _getAirportNameByIata(String iata) {
    try {
      final airport = DatabaseController.instance.airports.firstWhere(
        (a) => a.iata.toUpperCase() == iata.toUpperCase(),
      );
      return airport.name;
    } catch (e) {
      return iata; // Return IATA if name not found
    }
  }

  // Getter for departure airport name
  String get depAirportName => _getAirportNameByIata(depIata);

  // Getter for arrival airport name
  String get arrAirportName => _getAirportNameByIata(arrIata);

  // ========== GETTERS DURATION POUR TOUS LES CHAMPS ==========

  /// Convertit une chaîne "XXhYY" en Duration (utilise Fct.stringToDuration)
  static Duration _stringToDuration(String? durationString) => Fct.stringToDuration(durationString);

  /// Convertit une Duration en chaîne "XXhYY" (utilise Fct.durationToString)
  static String _durationToString(Duration duration) => Fct.durationToString(duration);

  /// Durée du vol (dtFin - dtDebut)
  Duration get dureeBrute {
    return dtFin.difference(dtDebut);
  }

  /// Durée du vol pour type Vol (sDureevol)
  Duration get dureeVol {
    return _stringToDuration(sDureevol);
  }

  /// Durée du vol pour type MEP/TAX (sDureeMep)
  Duration get dureeMep {
    return _stringToDuration(sDureeMep);
  }

  /// Durée forfait pour type Vol (sDureeForfait)
  Duration get dureeForfait {
    return _stringToDuration(sDureeForfait);
  }

  /// Durée forfait pour type MEP/TAX (sMepForfait)
  Duration get mepForfait {
    return _stringToDuration(sMepForfait);
  }

  /// Durée de nuit pour type Vol (sNuitVol)
  Duration get nuitVol {
    return _stringToDuration(sNuitVol);
  }

  /// Durée de nuit forfait pour type Vol (sNuitForfait)
  Duration get nuitForfait {
    return _stringToDuration(sNuitForfait);
  }

  /// Alias pour compatibilité
  Duration get nightFlightDuration => nuitVol;

  // ========== MÉTHODES STATIQUES POUR LES CUMULS MENSUELS ==========

  /// Calcule le cumul mensuel pour un champ donné
  /// [vols] : Liste de tous les vols
  /// [referenceVol] : Vol de référence pour déterminer le mois
  /// [fieldExtractor] : Fonction pour extraire le champ à cumuler
  static String calculateMonthlyCumul(
    List<VolModel> vols,
    VolModel referenceVol,
    String? Function(VolModel) fieldExtractor,
  ) {
    // Début du mois de référence
    final startOfMonth = DateTime(referenceVol.dtDebut.year, referenceVol.dtDebut.month, 1);

    // Filtrer les vols du même mois jusqu'à dtDebut (inclus)
    final volsInPeriod = vols.where((v) {
      final fieldValue = fieldExtractor(v);
      return v.dtDebut.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
          v.dtDebut.isBefore(referenceVol.dtDebut.add(const Duration(seconds: 1))) &&
          fieldValue != null &&
          fieldValue.isNotEmpty;
    }).toList();

    // Calculer le cumul en utilisant Duration
    Duration totalDuration = Duration.zero;
    for (var v in volsInPeriod) {
      totalDuration += _stringToDuration(fieldExtractor(v));
    }

    // Convertir le résultat en String pour le stockage ObjectBox
    return _durationToString(totalDuration);
  }

  /// Calcule le cumul de sDureevol depuis le début du mois (pour type tVol)
  static String calculateCumulDureeVol(List<VolModel> vols, VolModel referenceVol) {
    return calculateMonthlyCumul(vols, referenceVol, (v) => v.sDureevol);
  }

  /// Calcule le cumul de sDureeForfait depuis le début du mois (pour type tVol)
  static String calculateCumulDureeForfait(List<VolModel> vols, VolModel referenceVol) {
    return calculateMonthlyCumul(vols, referenceVol, (v) => v.sDureeForfait);
  }

  /// Calcule le cumul de sNuitVol depuis le début du mois (pour type tVol)
  static String calculateCumulNuitVol(List<VolModel> vols, VolModel referenceVol) {
    return calculateMonthlyCumul(vols, referenceVol, (v) => v.sNuitVol);
  }

  /// get lists of crew
  static List<Map<String, String>> getCrews(List<Crew> crews) =>
      crews.map((crew) => {
        'Mat': crew.crewId, 
        'pos': crew.pos, 
        'name': '${crew.firstname} ${crew.lastname}'
      }).toList();

  /// Calcule le cumul de sNuitForfait depuis le début du mois (pour type tVol)
  static String calculateCumulNuitForfait(List<VolModel> vols, VolModel referenceVol) {
    return calculateMonthlyCumul(vols, referenceVol, (v) => v.sNuitForfait);
  }

  /// Calcule le cumul de sDureeMep depuis le début du mois (pour types tMEP et tTAX)
  static String calculateCumulDureeMep(List<VolModel> vols, VolModel referenceVol) {
    return calculateMonthlyCumul(vols, referenceVol, (v) => v.sDureeMep);
  }

  /// Calcule le cumul de sMepForfait depuis le début du mois (pour types tMEP et tTAX)
  static String calculateCumulMepForfait(List<VolModel> vols, VolModel referenceVol) {
    return calculateMonthlyCumul(vols, referenceVol, (v) => v.sMepForfait);
  }

  /// Crée une copie du VolModel avec les propriétés modifiées
  /// Note: Cette méthode ne copie PAS les relations ToMany (crews)
  /// Pour copier avec les crews, utilisez copyWithCrews()
  VolModel copyWith({
    int? id,
    String? cle,
    String? typ,
    String? nVol,
    DateTime? dtDebut,
    String? depIata,
    String? depIcao,
    String? arrIata,
    String? arrIcao,
    DateTime? dtFin,
    String? label,
    String? sAvion,
    String? tsv,
    String? sDureevol,
    String? sDureeMep,
    DateTime? arrForfait,
    DateTime? arrMepForfait,
    DateTime? sunrise,
    DateTime? sunset,
    String? sNuitVol,
    String? sDureeForfait,
    String? sMepForfait,
    String? sNuitForfait,
  }) {
    final copy = VolModel(
      id: id ?? this.id,
      typ: typ ?? this.typ,
      nVol: nVol ?? this.nVol,
      dtDebut: dtDebut ?? this.dtDebut,
      depIata: depIata ?? this.depIata,
      depIcao: depIcao ?? this.depIcao,
      arrIata: arrIata ?? this.arrIata,
      arrIcao: arrIcao ?? this.arrIcao,
      dtFin: dtFin ?? this.dtFin,
      label: label ?? this.label,
      cle: cle ?? this.cle,
      sAvion: sAvion ?? this.sAvion,
      tsv: tsv ?? this.tsv,
      durationString: sDureevol ?? this.sDureevol,
      durationMepString: sDureeMep ?? this.sDureeMep,
      arrForfait: arrForfait ?? this.arrForfait,
      arrMepForfait: arrMepForfait ?? this.arrMepForfait,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      nightFlightString: sNuitVol ?? this.sNuitVol,
      durationForfaitString: sDureeForfait ?? this.sDureeForfait,
      mepForfaitString: sMepForfait ?? this.sMepForfait,
      nightForfaitString: sNuitForfait ?? this.sNuitForfait,
    );
    
    // Copy crews by creating new independent Crew instances linked only to the new VolModel
    // This ensures the copied VolModel and its crews are independent from the original
    for (var crew in crews) {
      final newCrew = Crew(
        id: 0, // New crew with no ID to ensure it's a new entity
        crewId: crew.crewId,
        firstname: crew.firstname,
        lastname: crew.lastname,
        matricule: crew.matricule,
        pos: crew.pos,
        base: crew.base,
      );
      // Link the new crew ONLY to the new VolModel (not to MyDuty or MyEtape)
      newCrew.volModel.target = copy;
      copy.crews.add(newCrew);
    }
    
    return copy;
  }

  @override
  String toString() {
    return 'VolTransit(id: $id, typ: $typ, nVol: $nVol, depIata: $depIata, depIcao: $depIcao, arrIata: $arrIata, arrIcao: $arrIcao, dtDebut: $dtDebut, dtFin: $dtFin)';
  }
}
