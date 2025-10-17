import 'package:connectivity_plus/connectivity_plus.dart';

import 'myerrorinfo.dart';

class Fct {
  /// Check internet connection with improved error handling and connection type detection
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

  /// Get detailed connectivity information for debugging purposes
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

  static String twoDigits(int n) => n.toString().padLeft(2, "0");

  static String getStringDureeFromInt({required int? dureeInMin, required bool inDay}) {
    Duration duration = (dureeInMin == null) ? const Duration(seconds: 0) : Duration(minutes: dureeInMin);

    String sday = duration.inDays == 0 ? '' : '${duration.inDays.toString()} days ';

    String twoDigitHours = duration.inHours.remainder(24) == 0
        ? ''
        : '${twoDigits(duration.inHours.remainder(24))}H';
    if (!inDay) {
      sday = '';
      twoDigitHours = '${twoDigits(duration.inHours)}H';
    }
    String twoDigitMinutes = duration.inMinutes.remainder(60) == 0
        ? ''
        : twoDigits(duration.inMinutes.remainder(60));
    if (sday == '' && twoDigitHours == '' && twoDigitMinutes != '') twoDigitMinutes = "${twoDigitMinutes}mn";
    String sDuration = "$sday$twoDigitHours$twoDigitMinutes ";

    return (duration == const Duration(seconds: 0)) ? '' : sDuration;
  }

  static String getDatesDefference({
    required DateTime? dateDebut,
    required DateTime? dateFin,
    required bool inDay,
  }) {
    if (dateDebut == null || dateFin == null) return '';
    Duration duree = dateFin.difference(dateDebut);

    return getStringDureeFromInt(dureeInMin: duree.inMinutes, inDay: inDay);
  }

  static Duration getDureeFromString({required String sDuree}) {
    if (sDuree.contains('h')) {
      List<String> duree = sDuree.split('h');

      if (duree.isNotEmpty) {
        return Duration(hours: int.parse(sDuree.split('h')[0]), minutes: int.parse(sDuree.split('h')[1]));
      } else {
        return Duration(minutes: int.parse(sDuree.split('h')[1]));
      }
    } else {
      return const Duration(microseconds: 0);
    }
  }

  static DateTime uTcDate({required DateTime dt}) {
    return DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, 0);
  }

  static DateTime firstOfMonth({required DateTime dt}) {
    return DateTime.utc(dt.year, dt.month, 1, 0, 0, 0);
  }

  static DateTime dayOfDate({required DateTime dt}) {
    return DateTime.utc(dt.year, dt.month, dt.day, 0, 0, 0);
  }

  static DateTime lastOfMonth({required DateTime dt}) {
    return DateTime.utc(dt.year, dt.month + 1, 1, 0, 0, 0);
  }

  static DateTime supDt({required DateTime dT1, required DateTime dT2}) =>
      ((dT1.compareTo(dT2) != -1) ? dT1 : dT2);

  static DateTime minDt({required DateTime dT1, required DateTime dT2}) =>
      ((dT1.compareTo(dT2) != -1) ? dT2 : dT1);
  static bool entreDeuxDts({required DateTime dTinf, required DateTime dTsup, required DateTime dT}) =>
      ((dT.compareTo(dTinf) != -1) && (dTsup.compareTo(dT) != -1));
  static String getStringFromDuree({required Duration duree}) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duree.inMinutes.remainder(60));
    return (duree == const Duration(seconds: 0)) ? '' : '${twoDigits(duree.inHours)}h$twoDigitMinutes';
  }
}
