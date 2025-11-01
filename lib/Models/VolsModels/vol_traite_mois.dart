import 'package:mystrip25/Models/ActsModels/typ_const.dart';
import 'package:objectbox/objectbox.dart';
import 'vol.dart';
import 'vol_traite.dart';

import '../volpdfs/vol_pdf_list.dart';
import '../../helpers/fct.dart';

/// Modèle ObjectBox pour stocker les cumuls mensuels de tous les vols
/// Contient les totaux mensuels et une relation vers tous les VolTraiteModel du mois
@Entity()
class VolTraiteMoisModel {
  @Id(assignable: true)
  int id;

  // ========== INFORMATIONS DE BASE ==========

  /// Premier jour du mois (format: YYYY-MM-01 00:00:00)
  @Property(type: PropertyType.date)
  @Unique()
  final DateTime premierJourMois;

  /// Mois de référence (format "YYYY-MM")
  final String moisReference;

  /// Année
  final int annee;

  /// Mois (1-12)
  final int mois;

  // ========== RELATION VERS LES VOLS DU MOIS ==========

  /// Tous les vols traités de ce mois
  final volsTraites = ToMany<VolTraiteModel>();

  // ========== CUMULS MENSUELS TOTAUX (format "XXhYY") ==========

  /// Cumul total mensuel durée Vol
  String cumulTotalDureeVol;

  /// Cumul total mensuel durée MEP
  String cumulTotalDureeMep;

  /// Cumul total mensuel forfait Vol
  String cumulTotalDureeForfait;

  /// Cumul total mensuel forfait MEP
  String cumulTotalMepForfait;

  /// Cumul total mensuel nuit Vol
  String cumulTotalNuitVol;

  /// Cumul total mensuel nuit forfait Vol
  String cumulTotalNuitForfait;

  // ========== STATISTIQUES DU MOIS ==========

  /// Nombre total de vols dans le mois
  int nombreVolsTotal;

  /// Nombre de vols de type Vol
  int nombreVolsVol;

  /// Nombre de vols de type MEP
  int nombreVolsMep;

  /// Nombre de vols de type TAX
  int nombreVolsTax;

  // ========== MÉTADONNÉES ==========

  /// Date de calcul/traitement
  @Property(type: PropertyType.date)
  DateTime dateTraitement;

  /// Indique si les cumuls sont à jour
  bool estAJour;

  VolTraiteMoisModel({
    this.id = 0,
    required this.premierJourMois,
    required this.moisReference,
    required this.annee,
    required this.mois,
    required this.cumulTotalDureeVol,
    required this.cumulTotalDureeMep,
    required this.cumulTotalDureeForfait,
    required this.cumulTotalMepForfait,
    required this.cumulTotalNuitVol,
    required this.cumulTotalNuitForfait,
    required this.nombreVolsTotal,
    required this.nombreVolsVol,
    required this.nombreVolsMep,
    required this.nombreVolsTax,
    required this.dateTraitement,
    this.estAJour = true,
  });

  /// Crée un VolTraiteMoisModel à partir d'une liste de VolTraiteModel du même mois
  factory VolTraiteMoisModel.fromVolsTraites(int year, int month, List<VolTraiteModel> volsTraitesDuMois) {
    // Premier jour du mois
    final premierJour = DateTime(year, month, 1);
    final moisRef = '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';

    // Calculer les cumuls totaux en additionnant les durées BRUTES (pas les cumuls mensuels)
    Duration totalDureeVol = Duration.zero;
    Duration totalDureeMep = Duration.zero;
    Duration totalDureeForfait = Duration.zero;
    Duration totalMepForfait = Duration.zero;
    Duration totalNuitVol = Duration.zero;
    Duration totalNuitForfait = Duration.zero;

    // Compteurs par type
    int countVolsTotal = volsTraitesDuMois.length;
    int countVolsVol = 0;
    int countVolsMep = 0;
    int countVolsTax = 0;

    for (var vol in volsTraitesDuMois) {
      // Additionner les durées BRUTES (sDureeBrute) pas les cumuls mensuels
      // sDureeBrute = dtFin - dtDebut (durée réelle du vol)
      // Les champs sDureevol, sDureeMep, etc. sont vides pour certains types
      // Les cumuls mensuels (sCumulDureeVol, etc.) sont des cumuls jusqu'au vol courant (inutilisables)
      if (vol.typ == tVol.typ) {
        totalDureeVol += _parseDuration(vol.sDureeBrute);
        totalDureeForfait += _parseDuration(vol.sDureeForfait);
        totalNuitVol += _parseDuration(vol.sNuitVol);
        totalNuitForfait += _parseDuration(vol.sNuitForfait);
        countVolsVol++;
      } else if (vol.typ == tMEP.typ) {
        totalDureeMep += _parseDuration(vol.sDureeBrute);
        totalMepForfait += _parseDuration(vol.sMepForfait);
        countVolsMep++;
      } else if (vol.typ == tTAX.typ) {
        totalDureeMep += _parseDuration(vol.sDureeBrute);
        totalMepForfait += _parseDuration(vol.sMepForfait);
        countVolsTax++;
      }
      // Note: Les autres types (HTL, Conge, RV, etc.) ne sont pas comptabilisés
    }

    // Créer le modèle
    final model = VolTraiteMoisModel(
      premierJourMois: premierJour,
      moisReference: moisRef,
      annee: year,
      mois: month,
      cumulTotalDureeVol: _formatDuration(totalDureeVol),
      cumulTotalDureeMep: _formatDuration(totalDureeMep),
      cumulTotalDureeForfait: _formatDuration(totalDureeForfait),
      cumulTotalMepForfait: _formatDuration(totalMepForfait),
      cumulTotalNuitVol: _formatDuration(totalNuitVol),
      cumulTotalNuitForfait: _formatDuration(totalNuitForfait),
      nombreVolsTotal: countVolsTotal,
      nombreVolsVol: countVolsVol,
      nombreVolsMep: countVolsMep,
      nombreVolsTax: countVolsTax,
      dateTraitement: DateTime.now(),
      estAJour: true,
    );

    // Ajouter les vols à la relation
    model.volsTraites.addAll(volsTraitesDuMois);

    return model;
  }

  /// Crée un VolTraiteMoisModel à partir d'une VolPdfList
  /// Convertit les VolPdf en VolModel, puis en VolTraiteModel
  factory VolTraiteMoisModel.fromVolPdfList(VolPdfList volPdfList, List<VolModel> allVolModels) {
    // Convertir les VolPdf en VolModel
    final volModels = <VolModel>[];
    for (var volPdf in volPdfList.volPdfs) {
      try {
        final volModel = VolModel.fromVolPdf(volPdf);
        volModels.add(volModel);
      } catch (e) {
        // Ignorer les VolPdf invalides
        continue;
      }
    }

    // Convertir les VolModel en VolTraiteModel
    final volsTraites = <VolTraiteModel>[];
    for (var volModel in volModels) {
      final volTraite = VolTraiteModel.fromVolModel(volModel, allVolModels);
      volsTraites.add(volTraite);
    }

    // Créer le VolTraiteMoisModel
    if (volsTraites.isEmpty) {
      throw ArgumentError('Aucun vol valide dans VolPdfList');
    }

    final year = volPdfList.month.year;
    final month = volPdfList.month.month;
    return VolTraiteMoisModel.fromVolsTraites(year, month, volsTraites);
  }

  /// Parse une chaîne "XXhYY" en Duration (utilise Fct.stringToDuration)
  static Duration _parseDuration(String? durationString) => Fct.stringToDuration(durationString);

  /// Formate une Duration en chaîne "XXhYY" (utilise Fct.durationToString)
  static String _formatDuration(Duration duration) => Fct.durationToString(duration);

  /// Recalcule les cumuls à partir des vols de la relation
  void recalculerCumuls() {
    Duration totalDureeVol = Duration.zero;
    Duration totalDureeMep = Duration.zero;
    Duration totalDureeForfait = Duration.zero;
    Duration totalMepForfait = Duration.zero;
    Duration totalNuitVol = Duration.zero;
    Duration totalNuitForfait = Duration.zero;

    int countVolsVol = 0;
    int countVolsMep = 0;
    int countVolsTax = 0;

    for (var vol in volsTraites) {
      // Additionner les durées BRUTES (sDureeBrute) pas les cumuls mensuels
      // sDureeBrute = dtFin - dtDebut (durée réelle du vol)
      if (vol.typ == tVol.typ) {
        totalDureeVol += _parseDuration(vol.sDureeBrute);
        totalDureeForfait += _parseDuration(vol.sDureeForfait);
        totalNuitVol += _parseDuration(vol.sNuitVol);
        totalNuitForfait += _parseDuration(vol.sNuitForfait);
        countVolsVol++;
      } else if (vol.typ == tMEP.typ) {
        totalDureeMep += _parseDuration(vol.sDureeBrute);
        totalMepForfait += _parseDuration(vol.sMepForfait);
        countVolsMep++;
      } else if (vol.typ == tTAX.typ) {
        totalDureeMep += _parseDuration(vol.sDureeBrute);
        totalMepForfait += _parseDuration(vol.sMepForfait);
        countVolsTax++;
      }
      // Note: Les autres types (HTL, Conge, RV, etc.) ne sont pas comptabilisés
    }

    cumulTotalDureeVol = _formatDuration(totalDureeVol);
    cumulTotalDureeMep = _formatDuration(totalDureeMep);
    cumulTotalDureeForfait = _formatDuration(totalDureeForfait);
    cumulTotalMepForfait = _formatDuration(totalMepForfait);
    cumulTotalNuitVol = _formatDuration(totalNuitVol);
    cumulTotalNuitForfait = _formatDuration(totalNuitForfait);
    nombreVolsTotal = volsTraites.length;
    nombreVolsVol = countVolsVol;
    nombreVolsMep = countVolsMep;
    nombreVolsTax = countVolsTax;
    dateTraitement = DateTime.now();
    estAJour = true;
  }

  /// Getter pour le nom du mois en français
  String get nomMois {
    const moisFr = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return moisFr[mois - 1];
  }

  /// Getter pour l'affichage "Mois Année"
  String get moisAnneeFormate {
    return '$nomMois $annee';
  }

  @override
  String toString() {
    return 'VolTraiteMoisModel(mois: $moisAnneeFormate, vols: $nombreVolsTotal, cumulVol: $cumulTotalDureeVol)';
  }
}
