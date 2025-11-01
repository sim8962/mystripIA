import 'dart:convert';
import 'package:mystrip25/Models/ActsModels/typ_const.dart';
import 'package:objectbox/objectbox.dart';

import '../../helpers/fct.dart';
import 'vol.dart';

/// Modèle ObjectBox pour stocker les données traitées d'un vol
/// Contient tous les champs calculés et cumuls pour optimiser les performances
@Entity()
class VolTraiteModel {
  @Id(assignable: true)
  int id;

  // ========== INFORMATIONS DE BASE ==========

  /// Référence au VolModel d'origine
  // final int volModelId;

  /// Type de vol (Vol, MEP, TAX, etc.)
  final String typ;

  /// Numéro de vol
  final String nVol;

  /// Date et heure de début
  @Property(type: PropertyType.date)
  final DateTime dtDebut;

  /// Date et heure de fin
  @Property(type: PropertyType.date)
  final DateTime dtFin;

  /// Date et heure de début (format string HH:mm)
  final String sDebut;

  /// Date et heure de fin (format string HH:mm)
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

  /// Durée vol (pour type Vol uniquement) - même nom que VolModel
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

  /// Heure d'arrivée forfait Vol (format string HH:mm)
  final String sArrForfait;

  /// Heure d'arrivée forfait MEP (format string HH:mm)
  final String sArrMepForfait;

  /// Lever du soleil (format string HH:mm)
  final String sSunrise;

  /// Coucher du soleil (format string HH:mm)
  final String sSunset;

  // ========== MÉTADONNÉES ==========

  /// Date de calcul/traitement (format string)
  final String sDateTraitement;

  /// Mois de référence pour les cumuls (format YYYY-MM)
  final String moisReference;

  VolTraiteModel({
    this.id = 0,
    // required this.volModelId,
    required this.typ,
    required this.nVol,
    required this.dtDebut,
    required this.dtFin,
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

  /// Crée un VolTraiteModel à partir d'un VolModel avec tous les cumuls calculés
  factory VolTraiteModel.fromVolModel(VolModel volModel, List<VolModel> allVols) {
    // Calculer les cumuls mensuels
    final cumulDureeVol = VolModel.calculateCumulDureeVol(allVols, volModel);
    final cumulDureeMep = VolModel.calculateCumulDureeMep(allVols, volModel);
    final cumulDureeForfait = VolModel.calculateCumulDureeForfait(allVols, volModel);
    final cumulMepForfait = VolModel.calculateCumulMepForfait(allVols, volModel);
    final cumulNuitVol = VolModel.calculateCumulNuitVol(allVols, volModel);
    final cumulNuitForfait = VolModel.calculateCumulNuitForfait(allVols, volModel);

    // Calculer la durée brute (utilise Fct.durationToString)
    final dureeBrute = volModel.dureeBrute;
    final sDureeBrute = Fct.durationToString(dureeBrute);

    // Mois de référence (utilise Fct.formatMonthReference)
    final moisRef = Fct.formatMonthReference(volModel.dtDebut);

    // Formater les dates en strings (utilise Fct.formatTimeToString)
    final sDebut = Fct.formatTimeToString(volModel.dtDebut);
    final sFin = Fct.formatTimeToString(volModel.dtFin);
    final sArrForfait = volModel.arrForfait != null ? Fct.formatTimeToString(volModel.arrForfait!) : '';
    final sArrMepForfait = volModel.arrMepForfait != null
        ? Fct.formatTimeToString(volModel.arrMepForfait!)
        : '';
    final sSunrise = volModel.sunrise != null ? Fct.formatTimeToString(volModel.sunrise!) : '';
    final sSunset = volModel.sunset != null ? Fct.formatTimeToString(volModel.sunset!) : '';
    final now = DateTime.now();
    final sDateTraitement = Fct.formatDateTimeFullToString(now);
    final List<Map<String, String>> crewsList = VolModel.getCrews(volModel.crews);
    final String crewsJson = jsonEncode(crewsList);
    return VolTraiteModel(
      id: 0,
      // volModelId: volModel.id,
      typ: volModel.typ,
      nVol: volModel.nVol,
      dtDebut: volModel.dtDebut,
      dtFin: volModel.dtFin,
      sDebut: sDebut,
      sFin: sFin,
      depIata: volModel.depIata,
      arrIata: volModel.arrIata,
      depIcao: volModel.depIcao,
      arrIcao: volModel.arrIcao,
      sAvion: volModel.sAvion,
      tsv: volModel.tsv,
      crews: crewsJson,
      sDureeBrute: sDureeBrute,
      sDureevol: volModel.sDureevol ?? '',
      sDureeMep: volModel.sDureeMep ?? '',
      sDureeForfait: volModel.sDureeForfait ?? '',
      sMepForfait: volModel.sMepForfait ?? '',
      sNuitVol: volModel.sNuitVol ?? '',
      sNuitForfait: volModel.sNuitForfait ?? '',
      sCumulDureeVol: cumulDureeVol,
      sCumulDureeMep: cumulDureeMep,
      sCumulDureeForfait: cumulDureeForfait,
      sCumulMepForfait: cumulMepForfait,
      sCumulNuitVol: cumulNuitVol,
      sCumulNuitForfait: cumulNuitForfait,
      sArrForfait: sArrForfait,
      sArrMepForfait: sArrMepForfait,
      sSunrise: sSunrise,
      sSunset: sSunset,
      sDateTraitement: sDateTraitement,
      moisReference: moisRef,
    );
  }

  /// Vérifie si le vol est de type Vol, MEP ou TAX
  bool get isFlightType {
    return typ == tVol.typ || typ == tMEP.typ || typ == tTAX.typ;
  }

  /// Vérifie si le vol est de type Vol
  bool get isVolType {
    return typ == tVol.typ;
  }

  /// Vérifie si le vol est de type MEP ou TAX
  bool get isMepOrTaxType {
    return typ == tMEP.typ || typ == tTAX.typ;
  }

  /// Décode les crews depuis le JSON
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
    return 'VolTraiteModel(id: $id, typ: $typ, nVol: $nVol, dtDebut: $dtDebut, cumuls: Vol=$sCumulDureeVol, MEP=$sCumulDureeMep)';
  }
}
