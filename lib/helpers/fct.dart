import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

import 'myerrorinfo.dart';

/// Utilitaires fonctionnels centralisés pour l'application.
///
/// Fournit des méthodes statiques pour :
/// - Vérifier la connectivité Internet
/// - Manipuler les durées et les dates
/// - Convertir les formats de temps
/// - Parser et formater les chaînes de durée
/// - Formater les dates et heures
class Fct {
  // =====================================================================
  // SECTION: CONNECTIVITÉ
  // =====================================================================

  /// Vérifie la disponibilité d'une connexion Internet.
  ///
  /// Retourne `true` si une connexion est disponible (WiFi, données cellulaires, etc.),
  /// `false` sinon. Gère les erreurs de manière sécurisée.
  static Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      // Check if any connection is available (WiFi, cellular, ethernet, etc.)
      bool hasConnection = connectivityResult.any((result) => result != ConnectivityResult.none);

      if (!hasConnection) {
        // MyErrorInfo.erreurInos(
        //   label: 'Connexion',
        //   content: 'Aucune connexion Internet disponible. Vérifiez votre WiFi ou données cellulaires.',
        // );
        return false;
      }

      return true;
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'Erreur Connexion',
        content: 'Erreur lors de la vérification de la connexion: $e',
      );
      return false;
    }
  }

  /// Retourne les détails de la connexion actuelle pour le débogage.
  ///
  /// Identifie le type de connexion (WiFi, cellulaire, VPN, etc.)
  /// ou retourne un message d'erreur en cas de problème.
  static Future<String> getConnectivityDetails() async {
    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        return 'WiFi connecté';
      } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
        return 'Données cellulaires connectées';
      } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
        return 'Ethernet connecté';
      } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
        return 'VPN connecté';
      } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
        return 'Bluetooth connecté';
      } else if (connectivityResult.contains(ConnectivityResult.other)) {
        return 'Autre type de connexion';
      } else {
        return 'Aucune connexion';
      }
    } catch (e) {
      return 'Erreur: $e';
    }
  }

  // =====================================================================
  // SECTION: UTILITAIRES DE DURÉE
  // =====================================================================

  /// Convertit une durée en minutes en chaîne formatée.
  /// Retourne "2 days 03H30" ou "03H30" selon [inDay].
  /// Si [dureeInMin] est null, retourne une chaîne vide.
  static String getStringDureeFromInt({required int? dureeInMin, required bool inDay}) {
    Duration duration = (dureeInMin == null) ? const Duration(seconds: 0) : Duration(minutes: dureeInMin);

    String sday = duration.inDays == 0 ? '' : '${duration.inDays.toString()} days ';

    String twoDigitHours = duration.inHours.remainder(24) == 0
        ? ''
        : '${padTwoDigits(duration.inHours.remainder(24))}H';
    if (!inDay) {
      sday = '';
      twoDigitHours = '${padTwoDigits(duration.inHours)}H';
    }
    String twoDigitMinutes = duration.inMinutes.remainder(60) == 0
        ? ''
        : padTwoDigits(duration.inMinutes.remainder(60));
    if (sday == '' && twoDigitHours == '' && twoDigitMinutes != '') twoDigitMinutes = "${twoDigitMinutes}mn";
    String sDuration = "$sday$twoDigitHours$twoDigitMinutes ";

    return (duration == const Duration(seconds: 0)) ? '' : sDuration;
  }

  /// Calcule la différence entre deux dates et la retourne formatée.
  /// Retourne une chaîne représentant la durée entre [dateDebut] et [dateFin].
  /// Si l'une des dates est null, retourne une chaîne vide.
  static String getDatesDefference({
    required DateTime? dateDebut,
    required DateTime? dateFin,
    required bool inDay,
  }) {
    if (dateDebut == null || dateFin == null) return '';
    Duration duree = dateFin.difference(dateDebut);
    return getStringDureeFromInt(dureeInMin: duree.inMinutes, inDay: inDay);
  }

  // =====================================================================
  // SECTION: UTILITAIRES DE DATE
  // =====================================================================

  /// Convertit une date en UTC sans modifier l'heure.
  static DateTime uTcDate({required DateTime dt}) {
    return DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, 0);
  }

  /// Retourne le premier jour du mois de la date donnée.
  static DateTime startOfMonth({required DateTime dt}) => DateTime(dt.year, dt.month, 1);

  /// Retourne le dernier jour du mois.
  static DateTime endOfMonth({required DateTime dt}) =>
      DateTime(dt.year, dt.month + 1, 1, 0, 0, 0).subtract(const Duration(minutes: 1));

  /// Retourne le jour (minuit) de la date donnée.
  static DateTime dayOfDate({required DateTime dt}) => DateTime(dt.year, dt.month, dt.day);

  static bool isSameDay(DateTime dt, DateTime other) =>
      dt.year == other.year && dt.month == other.month && dt.day == other.day;

  /// Retourne la date la plus récente entre deux dates.
  static DateTime supDt({required DateTime dT1, required DateTime dT2}) =>
      ((dT1.compareTo(dT2) != -1) ? dT1 : dT2);

  /// Retourne la date la plus ancienne entre deux dates.
  static DateTime minDt({required DateTime dT1, required DateTime dT2}) =>
      ((dT1.compareTo(dT2) != -1) ? dT2 : dT1);

  /// Vérifie si une date est comprise entre deux autres dates.
  static bool entreDeuxDts({required DateTime dTinf, required DateTime dTsup, required DateTime dT}) =>
      ((dT.compareTo(dTinf) != -1) && (dTsup.compareTo(dT) != -1));

  // =====================================================================
  // SECTION: CONVERSION DURÉE (Centralisée)
  // =====================================================================

  /// Convertit une chaîne de durée "XXhYY" en Duration.
  /// Format attendu: "02h30", "5h45", etc.
  /// Retourne Duration.zero si la chaîne est vide ou invalide.
  static Duration stringToDuration(String? durationString) {
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

  /// Convertit une Duration en chaîne formatée "XXhYY".
  /// Exemple: Duration(hours: 2, minutes: 30) -> "02h30"
  static String durationToString(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}';
  }

  // =====================================================================
  // SECTION: PARSING DATE/HEURE
  // =====================================================================

  /// Parse une chaîne de date/heure au format "dd/MM/yyyy HH:mm" en DateTime.
  /// Retourne [fallbackDate] si le parsing échoue.
  static DateTime parseDateTimeFromString(String dateTimeStr, {DateTime? fallbackDate}) {
    try {
      if (dateTimeStr.isEmpty) {
        return fallbackDate ?? DateTime.now();
      }
      return DateFormat('dd/MM/yyyy HH:mm').parse(dateTimeStr);
    } catch (e) {
      return fallbackDate ?? DateTime.now();
    }
  }

  /// Parse une chaîne de date au format "dd/MM/yyyy" en DateTime.
  /// Retourne [fallbackDate] si le parsing échoue.
  static DateTime parseDateFromString(String dateStr, {DateTime? fallbackDate}) {
    try {
      if (dateStr.isEmpty) {
        return fallbackDate ?? DateTime.now();
      }
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      return fallbackDate ?? DateTime.now();
    }
  }

  /// Parse une chaîne de temps au format "HH:mm" en Duration.
  /// Retourne Duration.zero si le parsing échoue.
  static Duration parseTimeFromString(String timeStr) {
    try {
      if (timeStr.isEmpty) return Duration.zero;
      final parts = timeStr.split(':');
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

  // =====================================================================
  // SECTION: FORMATAGE DATE/HEURE
  // =====================================================================

  /// Formate une DateTime en chaîne "dd/MM/yyyy HH:mm".
  static String formatDateTimeToString(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Formate une DateTime en chaîne "dd/MM/yyyy".
  static String formatDateToString(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Formate une DateTime en chaîne "HH:mm".
  static String formatTimeToString(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Formate une DateTime en chaîne "YYYY-MM" (pour les références de mois).
  static String formatMonthReference(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}';
  }

  /// Formate une DateTime en chaîne "dd/MM/yyyy HH:mm" (format complet avec secondes).
  static String formatDateTimeFullToString(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // =====================================================================
  // SECTION: UTILITAIRES DE FORMATAGE
  // =====================================================================

  /// Formate un nombre avec deux chiffres (ex: 5 -> "05").
  static String padTwoDigits(int n) => n.toString().padLeft(2, '0');

  /// Formate un nombre avec quatre chiffres (ex: 5 -> "0005").
  static String padFourDigits(int n) => n.toString().padLeft(4, '0');

  // =====================================================================
  // SECTION: WRAPPERS DE COMPATIBILITÉ (Anciennes méthodes)
  // =====================================================================

  /// Alias pour startOfMonth (compatibilité)
  static DateTime firstOfMonth({required DateTime dt}) => startOfMonth(dt: dt);

  /// Alias pour lastOfMonth (compatibilité)
  static DateTime lastOfMonth({required DateTime dt}) => DateTime.utc(dt.year, dt.month + 1, 1, 0, 0, 0);

  /// Alias pour stringToDuration (compatibilité)
  static Duration getDureeFromString({required String sDuree}) => stringToDuration(sDuree);

  /// Alias pour durationToString (compatibilité)
  static String getStringFromDuree({required Duration duree}) => durationToString(duree);

  /// Alias pour stringToDuration (compatibilité)
  static Duration parseDuration(String? durationString) => stringToDuration(durationString);

  /// Alias pour durationToString (compatibilité)
  static String formatDuration(Duration duration) => durationToString(duration);

  // =====================================================================
  // SECTION: PARSING DE FICHIERS
  // =====================================================================

  /// Parse une date depuis un nom de fichier (format: yyyyMM ou contenant yyyyMM).
  /// Supporte deux formats:
  /// 1. Exact yyyyMM (ex: "202510")
  /// 2. yyyyMM contenu dans le nom (ex: "forfaits_202510_data.xlsx")
  /// Retourne null si aucun format valide n'est trouvé.
  static DateTime? parseDateFromFilename(String filename) {
    final name = filename.trim();

    // 1) Exact yyyyMM
    if (RegExp(r'^\d{6}$').hasMatch(name)) {
      final y = int.tryParse(name.substring(0, 4));
      final m = int.tryParse(name.substring(4, 6));
      if (y != null && m != null && m >= 1 && m <= 12) {
        return DateTime(y, m, 1);
      }
      return null;
    }

    // 2) Extract first yyyyMM occurrence within any filename
    final match = RegExp(r'(20\d{2})(0[1-9]|1[0-2])').firstMatch(name);
    if (match != null) {
      final y = int.tryParse(match.group(1)!);
      final m = int.tryParse(match.group(2)!);
      if (y != null && m != null) {
        return DateTime(y, m, 1);
      }
    }
    return null;
  }

  // =====================================================================
  // SECTION: UTILITAIRES DE LISTE
  // =====================================================================

  /// Trie une liste par date extraite de chaque élément.
  /// [items] : Liste à trier
  /// [dateExtractor] : Fonction pour extraire la date de chaque élément
  /// [descending] : Si true, tri décroissant (plus récent en premier)
  static List<T> sortByDate<T>(List<T> items, DateTime Function(T) dateExtractor, {bool descending = false}) {
    final sorted = items.toList();
    sorted.sort((a, b) {
      final dateA = dateExtractor(a);
      final dateB = dateExtractor(b);
      final comparison = dateA.compareTo(dateB);
      return descending ? -comparison : comparison;
    });
    return sorted;
  }

  /// Trie une liste par chaîne de date au format "dd/MM/yyyy".
  /// [items] : Liste à trier
  /// [dateStringExtractor] : Fonction pour extraire la chaîne de date
  /// [descending] : Si true, tri décroissant
  static List<T> sortByDateString<T>(
    List<T> items,
    String Function(T) dateStringExtractor, {
    bool descending = false,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final sorted = items.toList();
    sorted.sort((a, b) {
      try {
        final dateA = dateFormat.parse(dateStringExtractor(a));
        final dateB = dateFormat.parse(dateStringExtractor(b));
        final comparison = dateA.compareTo(dateB);
        return descending ? -comparison : comparison;
      } catch (e) {
        return 0;
      }
    });
    return sorted;
  }

  /// Filtre une liste par critère de date.
  /// [items] : Liste à filtrer
  /// [dateExtractor] : Fonction pour extraire la date
  /// [startDate] : Date de début (incluse)
  /// [endDate] : Date de fin (incluse)
  static List<T> filterByDateRange<T>(
    List<T> items,
    DateTime Function(T) dateExtractor, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return items.where((item) {
      final date = dateExtractor(item);
      if (startDate != null && date.isBefore(startDate)) return false;
      if (endDate != null && date.isAfter(endDate)) return false;
      return true;
    }).toList();
  }

  /// Groupe une liste par mois.
  /// [items] : Liste à grouper
  /// [dateExtractor] : Fonction pour extraire la date
  /// Retourne une Map avec clé "YYYY-MM" et liste des éléments du mois
  static Map<String, List<T>> groupByMonth<T>(List<T> items, DateTime Function(T) dateExtractor) {
    final grouped = <String, List<T>>{};
    for (var item in items) {
      final date = dateExtractor(item);
      final monthKey = formatMonthReference(date);
      grouped.putIfAbsent(monthKey, () => []).add(item);
    }
    return grouped;
  }

  /// Extrait les mois uniques d'une liste de dates.
  /// Retourne une liste de DateTime triée (plus ancien en premier)
  static List<DateTime> extractUniqueMonths(List<DateTime> dates) {
    final months = <DateTime>{};
    for (var date in dates) {
      months.add(DateTime(date.year, date.month, 1));
    }
    final sorted = months.toList();
    sorted.sort((a, b) => a.compareTo(b));
    return sorted;
  }

  // =====================================================================
  // SECTION: FORFAIT TIME FORMATTING
  // =====================================================================

  /// Formate une chaîne de forfait de format "HH:mm" ou "HHmm" en "XXhYY".
  /// Exemple: "02:30" → "02h30", "5:45" → "05h45"
  /// Si le format est invalide, retourne la chaîne padée à 5 caractères.
  static String formatForfaitTime(String forfaitStr) {
    if (forfaitStr.isEmpty) return '00h00';

    try {
      // Essayer de parser au format "HH:mm"
      final parts = forfaitStr.split(':');
      if (parts.length == 2) {
        final hours = parts[0].trim();
        final minutes = parts[1].trim();
        return '${hours.padLeft(2, '0')}h${minutes.padLeft(2, '0')}';
      }

      // Si pas de ":", retourner padé à 5 caractères
      return forfaitStr.padLeft(5, '0');
    } catch (e) {
      return forfaitStr.padLeft(5, '0');
    }
  }
}
