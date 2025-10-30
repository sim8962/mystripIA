import 'package:flutter/services.dart';

import 'package:objectbox/objectbox.dart';
import 'package:http/http.dart' as http;
import 'package:adhan_dart/adhan_dart.dart';
import 'dart:convert';

import '../../../helpers/constants.dart';
import '../../../helpers/myerrorinfo.dart';
import '../../../controllers/database_controller.dart';

@Entity()
class AeroportModel {
  @Id()
  int id = 0;

  @Property()
  String icao;

  @Property()
  String iata;

  @Property()
  String name;

  @Property()
  String city;

  @Property()
  String country;

  @Property()
  double latitude;

  @Property()
  double longitude;

  @Property()
  String altitude;

  AeroportModel({
    this.id = 0,
    required this.icao,
    required this.iata,
    required this.name,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  // Factory constructor from JSON
  factory AeroportModel.fromJson(Map<String, dynamic> json) {
    return AeroportModel(
      id: json['id'] ?? 0,
      icao: json['ICAO'] ?? '',
      iata: json['IATA'] ?? '',
      name: json['NAME'] ?? '',
      city: json['City'] ?? '',
      country: json['contry'] ?? '', // Note: keeping original typo from JSON
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      altitude: json['altitude']?.toString() ?? '0',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': 0,
      'ICAO': icao,
      'IATA': iata,
      'NAME': name,
      'City': city,
      'contry': country,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
    };
  }

  // Copy with method for updates
  AeroportModel copyWith({
    int? id,
    String? icao,
    String? iata,
    String? name,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? altitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AeroportModel(
      id: id ?? this.id,
      icao: icao ?? this.icao,
      iata: iata ?? this.iata,
      name: name ?? this.name,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
    );
  }

  @override
  String toString() {
    return 'AirportModel(id: $id, icao: $icao, iata: $iata, name: $name, city: $city, country: $country)';
  }

  // ============================================================================
  // AIRPORT LOOKUP METHODS (Static)
  // ============================================================================

  /// Récupère un aéroport par son code OACI.
  /// Retourne l'aéroport ou null si non trouvé.
  static AeroportModel? getAeroportByOaci(String icao) {
    try {
      final airports = DatabaseController.instance.airports;
      final index = airports.indexWhere((a) => a.icao == icao);
      return (index == -1) ? null : airports[index];
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // PRAYER TIMES & SUNRISE/SUNSET METHODS (Static)
  // ============================================================================

  /// Récupère les heures de prière pour un aéroport à une date donnée.
  /// Utilise la méthode Muslim World League (Fajr 18°, Isha 17°).
  /// Retourne null si l'aéroport n'est pas trouvé ou le calcul échoue.
  static PrayerTimes? getPrayerTimes(String icao, DateTime date) {
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

  /// Calcule le lever de soleil le plus tôt entre les aéroports de départ et d'arrivée.
  /// Retourne null si le type n'est pas un vol ou si le calcul échoue.
  /// [typ] : Type de vol (Vol, MEP, TAX, etc.)
  /// [depIcao] : Code ICAO de départ
  /// [arrIcao] : Code ICAO d'arrivée
  /// [date] : Date pour le calcul
  static DateTime? calculateSunrise(String typ, String depIcao, String arrIcao, DateTime date) {
    if (typ != 'Vol') return null;

    try {
      final depPrayerTimes = getPrayerTimes(depIcao, date);
      final arrPrayerTimes = getPrayerTimes(arrIcao, date);

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

  /// Calcule le coucher de soleil le plus tard entre les aéroports de départ et d'arrivée.
  /// Retourne null si le type n'est pas un vol ou si le calcul échoue.
  /// [typ] : Type de vol (Vol, MEP, TAX, etc.)
  /// [depIcao] : Code ICAO de départ
  /// [arrIcao] : Code ICAO d'arrivée
  /// [date] : Date pour le calcul
  static DateTime? calculateSunset(String typ, String depIcao, String arrIcao, DateTime date) {
    if (typ != 'Vol') return null;

    try {
      final depPrayerTimes = getPrayerTimes(depIcao, date);
      final arrPrayerTimes = getPrayerTimes(arrIcao, date);

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AeroportModel && other.icao == icao && other.iata == iata;
  }

  @override
  int get hashCode {
    return icao.hashCode ^ iata.hashCode;
  }

  factory AeroportModel.fromAeroportJson(Map<String, dynamic> json) => AeroportModel(
    icao: json['icao_code'] ?? '',
    iata: json['iata_code'] ?? '',
    name: json['name'] ?? '',
    city: json['municipality'] ?? '',
    country: json['iso_country'] ?? '',
    latitude: json['latitude_deg'] is double
        ? json['latitude_deg']
        : (json['latitude_deg'] is int ? json['latitude_deg'].toDouble() : 0.0),
    longitude: json['longitude_deg'] is double
        ? json['longitude_deg']
        : (json['longitude_deg'] is int ? json['longitude_deg'].toDouble() : 0.0),
    altitude: json['elevation_ft'] ?? '0',
  );

  static Future<AeroportModel> fetchAirportIcao({required String icao}) async {
    //final url = Uri.parse('https://api.airportdb.io/airports?icao=$icao'); // Replace this with the actual API URL
    String token =
        'a224d07081b781ad66de60659a9d0e8b7756e9b781d9b33e213cb1fc31d8d43bf3651ac525c6319d46fc9c7797a531b1';
    final url = Uri.parse(
      'https://airportdb.io/api/v1/airport/$icao?apiToken=$token',
    ); // Replace this with the actual API URL
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body);
      //log(response.body);
      AeroportModel er = AeroportModel.fromAeroportJson(jsonResponse);
      // print(er.toString());
      return er;
    } else {
      // print('ici: $icao');
      throw Exception('Failed to load airport');
    }
  }

  static Future<AeroportModel> fetchAirportIata({required String iata}) async {
    //final url = Uri.parse('https://api.airportdb.io/airports?icao=$icao'); // Replace this with the actual API URL
    String token =
        'a224d07081b781ad66de60659a9d0e8b7756e9b781d9b33e213cb1fc31d8d43bf3651ac525c6319d46fc9c7797a531b1';
    final url = Uri.parse(
      'https://airportdb.io/api/v1/airport/$iata?apiToken=$token',
    ); // Replace this with the actual API URL
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body);
      //log(response.body);
      AeroportModel er = AeroportModel.fromAeroportJson(jsonResponse);
      // print(er.toString());
      return er;
    } else {
      throw Exception('Failed to load airport');
    }
  }

  static Future<void> fillAirportModelsIfEmpty() async {
    final dbController = DatabaseController.instance;
    try {
      // Check if airports box is empty
      if (dbController.airports.isEmpty) {
        // Load airports from JSON asset
        final String jsonString = await rootBundle.loadString(pathAeroportJson);
        final List<dynamic> jsonList = json.decode(jsonString);

        // Convert JSON to AirportModel list
        final List<AeroportModel> aeroports = [];
        final Set<String> existingIcaoCodes = {};
        final Set<String> existingIataCodes = {};

        for (final jsonItem in jsonList) {
          try {
            final airport = AeroportModel.fromJson(jsonItem);

            // Check for duplicates using ICAO and IATA codes
            final icaoKey = airport.icao.toUpperCase();
            final iataKey = airport.iata.toUpperCase();

            // Skip if duplicate ICAO or IATA code already exists
            if (existingIcaoCodes.contains(icaoKey) || existingIataCodes.contains(iataKey)) {
              continue;
            }

            // Add to tracking sets
            existingIcaoCodes.add(icaoKey);
            existingIataCodes.add(iataKey);

            // Add to airports list

            aeroports.add(airport);
          } catch (e) {
            // Skip invalid airport entries
            //print(e);
            MyErrorInfo.erreurInos(
              label: 'AeroportModel.fillAirportsIfEmpty',
              content: 'Error parsing airport: $e',
            );

            continue;
          }
        }

        // Bulk insert airports if we have any
        if (aeroports.isNotEmpty) {
          dbController.addAirports(aeroports);
        }
      }
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'AcceuilController._loadAirportsIfEmpty',
        content: 'Error loading airports from JSON: $e',
      );
    }
  }

  static Future<AeroportModel?> _findAirportInAssetByIcao(String icao) async {
    try {
      final String jsonString = await rootBundle.loadString(pathAeroportJson);
      final List<dynamic> jsonList = json.decode(jsonString);
      final target = icao.trim().toUpperCase();
      for (final jsonItem in jsonList) {
        try {
          final airport = AeroportModel.fromJson(jsonItem);
          if (airport.icao.trim().toUpperCase() == target) {
            return airport;
          }
        } catch (_) {}
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> addAeroportFromFrorfait() async {
    int count = 0;
    DatabaseController dbController = DatabaseController.instance;
    final List<AeroportModel> aeroports = dbController.airports;
    List<String> listDeps = dbController.forfaits.map((e) => e.depICAO.trim().toUpperCase()).toSet().toList();
    List<String> listArrs = dbController.forfaits.map((e) => e.arrICAO.trim().toUpperCase()).toSet().toList();
    List<String> listAeroports = (listDeps + listArrs).toSet().toList();

    for (String icao in listAeroports) {
      int index = aeroports.indexWhere((e) => e.icao.trim().toUpperCase() == icao.trim().toUpperCase());
      if (index == -1 && icao.isNotEmpty) {
        final local = await _findAirportInAssetByIcao(icao);
        if (local != null) {
          aeroports.add(local);
          count++;
          continue;
        }
        try {
          // print('AeroportModel.addAeroportFromFrorfait : $icao');

          AeroportModel aeroport = await AeroportModel.fetchAirportIcao(icao: icao.trim().toUpperCase());
          aeroports.add(aeroport);
          count++;
        } catch (e) {
          //print('AeroportModel.addAeroportFromFrorfait catch : $e | $icao');
          MyErrorInfo.erreurInos(
            label: 'AeroportModel.addAeroportFromFrorfait',
            content: 'Failed to fetch airport with ICAO: $icao - Error: $e',
          );
          continue;
        }
      }
    }
    if (count > 0) {
      dbController.addAirports(aeroports);
    }
  }
}
