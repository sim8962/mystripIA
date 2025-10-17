import 'package:mystrip25/Models/ActsModels/typ_const.dart';
import 'package:objectbox/objectbox.dart';
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

  // ========== DATES CALCULÉES ==========

  /// Heure d'arrivée forfait Vol
  @Property(type: PropertyType.date)
  final DateTime? arrForfait;

  /// Heure d'arrivée forfait MEP
  @Property(type: PropertyType.date)
  final DateTime? arrMepForfait;

  /// Lever du soleil
  @Property(type: PropertyType.date)
  final DateTime? sunrise;

  /// Coucher du soleil
  @Property(type: PropertyType.date)
  final DateTime? sunset;

  // ========== MÉTADONNÉES ==========

  /// Date de calcul/traitement
  @Property(type: PropertyType.date)
  final DateTime dateTraitement;

  /// Mois de référence pour les cumuls (format YYYY-MM)
  final String moisReference;

  VolTraiteModel({
    this.id = 0,
    // required this.volModelId,
    required this.typ,
    required this.nVol,
    required this.dtDebut,
    required this.dtFin,
    required this.depIata,
    required this.arrIata,
    required this.depIcao,
    required this.arrIcao,
    required this.sAvion,
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
    this.arrForfait,
    this.arrMepForfait,
    this.sunrise,
    this.sunset,
    required this.dateTraitement,
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

    // Calculer la durée brute
    final dureeBrute = volModel.dureeBrute;
    final hours = dureeBrute.inHours;
    final minutes = dureeBrute.inMinutes.remainder(60);
    final sDureeBrute = '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}';

    // Mois de référence
    final moisRef =
        '${volModel.dtDebut.year.toString().padLeft(4, '0')}-${volModel.dtDebut.month.toString().padLeft(2, '0')}';

    return VolTraiteModel(
      id: 0,
      // volModelId: volModel.id,
      typ: volModel.typ,
      nVol: volModel.nVol,
      dtDebut: volModel.dtDebut,
      dtFin: volModel.dtFin,
      depIata: volModel.depIata,
      arrIata: volModel.arrIata,
      depIcao: volModel.depIcao,
      arrIcao: volModel.arrIcao,

      sAvion: volModel.sAvion,
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
      arrForfait: volModel.arrForfait,
      arrMepForfait: volModel.arrMepForfait,
      sunrise: volModel.sunrise,
      sunset: volModel.sunset,
      dateTraitement: DateTime.now(),
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

  @override
  String toString() {
    return 'VolTraiteModel(id: $id, typ: $typ, nVol: $nVol, dtDebut: $dtDebut, cumuls: Vol=$sCumulDureeVol, MEP=$sCumulDureeMep)';
  }
}
