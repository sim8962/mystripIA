import 'package:mystrip25/Models/ActsModels/typ_const.dart';
import 'package:objectbox/objectbox.dart';
import 'vol_traite.dart';

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

    // Calculer les cumuls totaux en additionnant les Duration
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
      // Additionner les durées
      totalDureeVol += _parseDuration(vol.sCumulDureeVol);
      totalDureeMep += _parseDuration(vol.sCumulDureeMep);
      totalDureeForfait += _parseDuration(vol.sCumulDureeForfait);
      totalMepForfait += _parseDuration(vol.sCumulMepForfait);
      totalNuitVol += _parseDuration(vol.sCumulNuitVol);
      totalNuitForfait += _parseDuration(vol.sCumulNuitForfait);

      // Compter par type
      if (vol.typ == tVol.typ) {
        countVolsVol++;
      } else if (vol.typ == tMEP.typ) {
        countVolsMep++;
      } else if (vol.typ == tTAX.typ) {
        countVolsTax++;
      }
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

  /// Parse une chaîne "XXhYY" en Duration
  static Duration _parseDuration(String? durationString) {
    if (durationString == null || durationString.isEmpty) return Duration.zero;

    try {
      final parts = durationString.toLowerCase().split('h');
      if (parts.length == 2) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        return Duration(hours: hours, minutes: minutes);
      }
    } catch (e) {
      return Duration.zero;
    }
    return Duration.zero;
  }

  /// Formate une Duration en chaîne "XXhYY"
  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}';
  }

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
      totalDureeVol += _parseDuration(vol.sCumulDureeVol);
      totalDureeMep += _parseDuration(vol.sCumulDureeMep);
      totalDureeForfait += _parseDuration(vol.sCumulDureeForfait);
      totalMepForfait += _parseDuration(vol.sCumulMepForfait);
      totalNuitVol += _parseDuration(vol.sCumulNuitVol);
      totalNuitForfait += _parseDuration(vol.sCumulNuitForfait);

      if (vol.typ == 'Vol') {
        countVolsVol++;
      } else if (vol.typ == 'MEP') {
        countVolsMep++;
      } else if (vol.typ == 'TAX') {
        countVolsTax++;
      }
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
