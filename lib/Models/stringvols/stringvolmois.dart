import 'package:objectbox/objectbox.dart';

import '../../helpers/constants.dart';
import '../../helpers/fct.dart';
import '../ActsModels/typ_const.dart';
import 'svolmodel.dart';

/*
ETAPES CLAIRES (PAS À PAS) POUR CRÉER StringVolModelMois

But: Construire une entité ObjectBox « mois » qui regroupe des StringVolModel
par mois (YYYY-MM), calcule les cumuls mensuels et les cumuls annuels.

====================================================================
0) Contexte & conventions
--------------------------------------------------------------------
- Les durées sont au format "XXhYY" et doivent être manipulées via
  Fct.stringToDuration() / Fct.durationToString().
- Les dates des StringVolModel sont des String (sDebut/sFin: "dd/MM/yyyy HH:mm").
  Utiliser Fct.parseDateTimeFromString() pour les convertir.
- Les types de vols: tVol, tMEP, tTAX (mêmes conventions que StringVolModel).

====================================================================
1) Champs de l'entité (déjà posés dans ce fichier)
--------------------------------------------------------------------
- id (ObjectBox)
- premierJourMois (DateTime, unique) => 1er jour du mois 00:00:00
- moisReference (String) => "YYYY-MM"
- annee (int) / mois (int)
- Cumuls mensuels (String):
  cumulTotalDureeVol, cumulTotalDureeMep, cumulTotalDureeForfait,
  cumulTotalMepForfait, cumulTotalNuitVol, cumulTotalNuitForfait
- Cumuls annuels (String):
  cumulAnTotalDureeVol, cumulAnTotalDureeMep, cumulAnTotalNuitVol
- Relation: ToMany<StringVolModel> stringVolModels (vols rattachés au mois)

====================================================================
2) Méthodes utilitaires (à ajouter après le constructeur)
--------------------------------------------------------------------
- static String _monthKey(DateTime d) => "YYYY-MM"
- static DateTime _firstDayOfMonth(String yyyymm) => DateTime(YYYY, MM, 1)
- static DateTime _lastMomentOfMonth(String yyyymm) => DateTime(YYYY, MM+1, 0, 23,59,59)
- static Duration _sum(List<Duration> list)
- static String _safeAdd(String a, String b)
    -> additionne deux durées String avec Fct.stringToDuration/durationToString
- static bool _isFlight(String typ)
    -> typ == tVol.typ || typ == tMEP.typ || typ == tTAX.typ
- static bool _isVol(String typ) -> typ == tVol.typ
- static bool _isMepOrTax(String typ) -> typ == tMEP.typ || typ == tTAX.typ
- static DateTime _parse(String s) -> Fct.parseDateTimeFromString(s)

====================================================================
3) Regroupement par mois (fonction principale)
--------------------------------------------------------------------
Implémenter:
static List<StringVolModelMois> groupByMonth(List<StringVolModel> all)
  a) Grouper par clé moisReference = _monthKey(_parse(sDebut)) ou sFin si sDebut vide.
  b) Pour chaque mois:
     - Trier les vols du mois par sDebut croissant
     - Calculer premierJourMois, annee, mois à partir de moisReference
     - Calculer les cumuls mensuels:
        • cumulTotalDureeVol: somme des durées réelles des vols typ Vol
          - Si un vol chevauche le mois, compter seulement l'intersection
            [max(start, firstDay), min(end, lastMoment)]
        • cumulTotalDureeMep: idem pour MEP/TAX (durées réelles)
        • cumulTotalDureeForfait: Vol -> sDureeForfait si non vide sinon sDureevol
        • cumulTotalMepForfait: MEP/TAX -> sMepForfait si non vide sinon sDureeMep
        • cumulTotalNuitVol: Vol -> sNuitVol (addition simple, ou recalcul si besoin)
        • cumulTotalNuitForfait: Vol -> sNuitForfait (addition simple)
     - Créer l'instance StringVolModelMois et y attacher les vols du mois via
       .stringVolModels.addAll(volsDuMois)
  c) Retourner la liste triée par premierJourMois DESC (plus récent en premier)

Conseil pour chevauchement:
  DateTime start = _parse(sDebut);
  DateTime end = _parse(sFin);
  DateTime a = max(start, firstDayOfMonth);
  DateTime b = min(end, lastMomentOfMonth);
  if (a < b) add b.difference(a)

====================================================================
4) Calcul des cumuls annuels
--------------------------------------------------------------------
Après avoir construit la liste mensuelle (triée par date croissante),
parcourir mois par mois et maintenir trois accumulateurs:
- anVol, anMep, anNuit (Duration)
Mettre à jour pour chaque mois:
  cumulAnTotalDureeVol = anVol + cumulTotalDureeVol
  cumulAnTotalDureeMep = anMep + cumulTotalDureeMep
  cumulAnTotalNuitVol  = anNuit + cumulTotalNuitVol
Puis convertir en "XXhYY".

====================================================================
5) API publique à exposer dans cette classe
--------------------------------------------------------------------
- static List<StringVolModelMois> fromStringVols(List<StringVolModel> all)
    -> appelle groupByMonth(all), puis applique le remplissage des cumuls annuels
- static String _format(Duration d) => Fct.durationToString(d)

====================================================================
6) Intégration (contrôleurs/services)
--------------------------------------------------------------------
- ObjectBoxService: ajouter Box<StringVolModelMois> + CRUD (si persistance requise)
- DatabaseController: exposer RxList<StringVolModelMois> + méthodes:
    replaceAllStringVolMois, getAllStringVolMois, clearAllStringVolMois
- UI: utiliser ces mois pour l'affichage cumulé (liste des mois + cartes)

====================================================================
7) Tests rapides (manuels)
--------------------------------------------------------------------
- Cas simple avec 2 vols Vol dans le même mois
- Cas chevauchant (fin dans mois+1) -> vérifier découpage
- Cas MEP/TAX -> vérifier MEP et forfaits
- Vérifier tri DESC et cumuls annuels croissants

====================================================================
8) Performance & sécurité
--------------------------------------------------------------------
- Éviter les parse DateTime dans des boucles profondes (cacher sDebut/sFin parsés)
- Protéger contre les champs vides (retourner Duration.zero)
- Toujours normaliser via Fct.durationToString avant assignation aux String cumul
*/

@Entity()
class StringVolModelMois {
  @Id(assignable: true)
  int id;

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
  // ========== CUMULS MENSUELS TOTAUX (format "XXhYY") ==========

  /// Cumul total mensuel sDureevol en duree VolModel de typ tVol dont date  depart ou arrivee dans le mois
  /// si volmodel est a cheval entre deux mois en calcul la duree du vol pendant  ce mois
  String cumulTotalDureeVol;

  /// Cumul total mensuel du sDureeForfait en duree VolModel de typ tVol dont date  depart ou arrivee dans le mois
  /// si volmodel est a cheval entre deux mois en calcul la duree du vol pendant  ce mois
  String cumulTotalDureeForfait;

  /// Cumul total mensuel sDureeMep en durée VolModel  de typ tMep ou tTax dont date  depart ou arrivee dans le mois
  /// si volmodel est a cheval entre deux mois en calcul la duree du vol pendant  ce mois
  String cumulTotalDureeMep;

  /// Cumul total mensuel sMepForfait en durée VolModel  de typ tMep ou tTax dont date  depart ou arrivee dans le mois
  /// si volmodel est a cheval entre deux mois en calcul la duree du vol pendant  ce mois
  String cumulTotalMepForfait;

  /// Cumul total mensuel sNuitVol en duree VolModel de typ tVol dont date  depart ou arrivee dans le mois
  /// si volmodel est a cheval entre deux mois en calcul la duree du vol pendant  ce mois
  String cumulTotalNuitVol;

  /// Cumul total mensuel sNuitForfait en duree VolModel de typ tVol dont date  depart ou arrivee dans le mois
  /// si volmodel est a cheval entre deux mois en calcul la duree du vol pendant  ce mois
  String cumulTotalNuitForfait;

  /// Cumul total annuel depuis le 1er janvier de cumulTotalDureeVol en duree :
  String cumulAnTotalDureeVol;

  /// Cumul total annuel depuis le 1er janvier de cumulTotalDureeMep en duree :
  String cumulAnTotalDureeMep;

  /// Cumul total annuel depuis le 1er janvier de cumulTotalNuitVol en duree :
  String cumulAnTotalNuitVol;

  /// Tous les vols traités de ce mois dont depart ou arrivee est dans le mois
  final stringVolModels = ToMany<StringVolModel>();

  StringVolModelMois({
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
    required this.cumulAnTotalDureeVol,
    required this.cumulAnTotalDureeMep,
    required this.cumulAnTotalNuitVol,
  });

  // Etape 3: remplace ce stub par l'implémentation décrite ci-dessus
  // - Grouper par mois
  // - Calculer tous les cumuls mensuels
  // - Puis cumuls annuels
  // - Retourner la liste triée
  List<StringVolModelMois> getListStringVolModelMois({required List<StringVolModel> stringVolModels}) {
    return StringVolModelMois.fromStringVols(stringVolModels);
  }

  static List<StringVolModelMois> fromStringVols(List<StringVolModel> all) {
    final Map<String, List<StringVolModel>> byMonth = {};

    for (final sv in all) {
      final DateTime? dStart = _parseSafe(sv.sDebut);
      final DateTime? dEnd = _parseSafe(sv.sFin);
      if (dStart == null && dEnd == null) continue;

      final String startKey = dStart != null ? _monthKey(dStart) : (dEnd != null ? _monthKey(dEnd) : '');
      if (startKey.isNotEmpty) {
        byMonth.putIfAbsent(startKey, () => <StringVolModel>[]).add(sv);
      }

      if (dStart != null && dEnd != null) {
        final String endKey = _monthKey(dEnd);
        if (endKey != startKey) {
          byMonth.putIfAbsent(endKey, () => <StringVolModel>[]).add(sv);
        }
      }
    }

    final List<StringVolModelMois> result = [];
    final monthKeys = byMonth.keys.toList()..sort((a, b) => a.compareTo(b));

    for (final key in monthKeys) {
      final vols = byMonth[key]!;
      vols.sort((a, b) {
        final da = _parseSafe(a.sDebut) ?? _parseSafe(a.sFin) ?? DateTime.fromMillisecondsSinceEpoch(0);
        final db = _parseSafe(b.sDebut) ?? _parseSafe(b.sFin) ?? DateTime.fromMillisecondsSinceEpoch(0);
        return da.compareTo(db);
      });

      final DateTime firstDay = _firstDayOfMonth(key);
      final DateTime lastMoment = _lastMomentOfMonth(key);
      final int year = int.parse(key.split('-')[0]);
      final int month = int.parse(key.split('-')[1]);

      Duration dVol = Duration.zero;
      Duration dMep = Duration.zero;
      Duration dVolForfait = Duration.zero;
      Duration dMepForfait = Duration.zero;
      Duration dNuitVol = Duration.zero;
      Duration dNuitForfait = Duration.zero;

      for (final sv in vols) {
        final typ = sv.typ;
        final DateTime? s = _parseSafe(sv.sDebut);
        final DateTime? e = _parseSafe(sv.sFin);

        if (s != null && e != null) {
          final Duration inter = _intersectionWithinMonth(s, e, firstDay, lastMoment);
          if (typ == tVol.typ) {
            dVol += inter;
          } else if (typ == tMEP.typ || typ == tTAX.typ) {
            dMep += inter;
          }
        }

        if (typ == tVol.typ) {
          final String forf = (sv.sDureeForfait.isNotEmpty) ? sv.sDureeForfait : sv.sDureevol;
          if (forf.isNotEmpty) dVolForfait += Fct.stringToDuration(forf);
          if (sv.sNuitVol.isNotEmpty) dNuitVol += Fct.stringToDuration(sv.sNuitVol);
          if (sv.sNuitForfait.isNotEmpty) dNuitForfait += Fct.stringToDuration(sv.sNuitForfait);
        } else if (typ == tMEP.typ || typ == tTAX.typ) {
          final String forf = (sv.sMepForfait.isNotEmpty) ? sv.sMepForfait : sv.sDureeMep;
          if (forf.isNotEmpty) dMepForfait += Fct.stringToDuration(forf);
        }
      }

      final moisEntity = StringVolModelMois(
        premierJourMois: firstDay,
        moisReference: key,
        annee: year,
        mois: month,
        cumulTotalDureeVol: Fct.durationToString(dVol),
        cumulTotalDureeMep: Fct.durationToString(dMep),
        cumulTotalDureeForfait: Fct.durationToString(dVolForfait),
        cumulTotalMepForfait: Fct.durationToString(dMepForfait),
        cumulTotalNuitVol: Fct.durationToString(dNuitVol),
        cumulTotalNuitForfait: Fct.durationToString(dNuitForfait),
        cumulAnTotalDureeVol: '00h00',
        cumulAnTotalDureeMep: '00h00',
        cumulAnTotalNuitVol: '00h00',
      );

      moisEntity.stringVolModels.addAll(vols);
      result.add(moisEntity);
    }

    result.sort((a, b) => a.premierJourMois.compareTo(b.premierJourMois));

    int? currentYear;
    Duration anVol = Duration.zero;
    Duration anMep = Duration.zero;
    Duration anNuit = Duration.zero;

    for (final m in result) {
      if (currentYear == null || currentYear != m.annee) {
        currentYear = m.annee;
        anVol = Duration.zero;
        anMep = Duration.zero;
        anNuit = Duration.zero;
      }
      anVol += Fct.stringToDuration(m.cumulTotalDureeVol);
      anMep += Fct.stringToDuration(m.cumulTotalDureeMep);
      anNuit += Fct.stringToDuration(m.cumulTotalNuitVol);

      m.cumulAnTotalDureeVol = Fct.durationToString(anVol);
      m.cumulAnTotalDureeMep = Fct.durationToString(anMep);
      m.cumulAnTotalNuitVol = Fct.durationToString(anNuit);
    }

    result.sort((a, b) => b.premierJourMois.compareTo(a.premierJourMois));
    return result;
  }

  static String _monthKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

  static DateTime _firstDayOfMonth(String yyyymm) {
    final parts = yyyymm.split('-');
    final y = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    return DateTime(y, m, 1);
  }

  static DateTime _lastMomentOfMonth(String yyyymm) {
    final parts = yyyymm.split('-');
    final y = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final lastDay = DateTime(y, m + 1, 0).day;
    return DateTime(y, m, lastDay, 23, 59, 59);
  }

  static DateTime? _parseSafe(String s) {
    try {
      if (s.isEmpty) return null;
      return dateFormatDDHH.tryParse(s);
    } catch (_) {
      return null;
    }
  }

  static Duration _intersectionWithinMonth(
    DateTime start,
    DateTime end,
    DateTime firstDay,
    DateTime lastMoment,
  ) {
    if (!end.isAfter(start)) return Duration.zero;
    final DateTime a = start.isAfter(firstDay) ? start : firstDay;
    final DateTime b = end.isBefore(lastMoment) ? end : lastMoment;
    if (!b.isAfter(a)) return Duration.zero;
    return b.difference(a);
  }
}
