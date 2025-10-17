import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Models/jsonModels/datas/airport_model.dart';
import '../../../controllers/database_controller.dart';

class AerportService extends GetxController {
  static AerportService instance = Get.find();
  // AerportService get _airSvc => AerportService.instance;

  // WARNING: Hardcoding API keys is not recommended for production apps.
  // You requested to hardcode it, so we provide a default key here.
  // Consider moving this to secure storage or build-time config for production builds.
  static const String _rapidApiKey = '6600dbd37emsha983825a3c51d0fp17a797jsn1c41ce82c1ac';

  Future<AeroportModel?> fetchAirportFromApiByIcao({required String icao}) async {
    final uri = Uri.parse('https://airports.p.rapidapi.com/v1/airports');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'x-rapidapi-host': 'airports.p.rapidapi.com',
      'x-rapidapi-key': _rapidApiKey,
    };

    // Body shape varies by provider; we include common keys used by such endpoints.
    final payload = <String, dynamic>{
      'icao': icao,
      'icaoCode': icao,
      'search': icao,
      // Some APIs support pagination or filters; not setting extras here.
    };

    try {
      final resp = await http.post(uri, headers: headers, body: jsonEncode(payload));

      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        return null;
      }

      final dynamic decoded = jsonDecode(resp.body);

      // Normalize possible response shapes to a list of maps
      List<dynamic> items;
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map<String, dynamic>) {
        items = (decoded['data'] ?? decoded['items'] ?? decoded['results'] ?? []) as List<dynamic>;
      } else {
        return null;
      }

      // Find best matching entry by ICAO
      Map<String, dynamic>? item;
      for (final it in items) {
        if (it is Map<String, dynamic>) {
          final itIcao = (it['ICAO'] ?? it['icao'] ?? it['codeIcaoAirport'] ?? '').toString();
          if (itIcao.toUpperCase() == icao.toUpperCase()) {
            item = it;
            break;
          }
        }
      }

      item ??= (items.isNotEmpty && items.first is Map<String, dynamic>)
          ? items.first as Map<String, dynamic>
          : null;
      if (item == null) return null;

      // Map various possible keys to AirportModel fields
      String mapString(dynamic v, [String def = '']) => (v ?? def).toString();
      double mapDouble(dynamic v) {
        if (v == null) return 0.0;
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString()) ?? 0.0;
      }

      final icaoCode = mapString(item['ICAO'] ?? item['icao'] ?? item['codeIcaoAirport'] ?? icao);
      final iataCode = mapString(item['IATA'] ?? item['iata'] ?? item['codeIataAirport']);
      final name = mapString(item['NAME'] ?? item['name'] ?? item['airportName'] ?? item['an']);
      final city = mapString(item['City'] ?? item['city'] ?? item['cityName'] ?? item['ct']);
      // Prefer full country name if available (cn), otherwise code (country/cc) or other variants
      final country = mapString(
        item['cn'] ?? item['contry'] ?? item['country'] ?? item['cc'] ?? item['countryName'],
      );

      double latitude = mapDouble(item['latitude'] ?? item['lat'] ?? (item['location']?['lat']));
      double longitude = mapDouble(
        item['longitude'] ?? item['lng'] ?? item['lon'] ?? (item['location']?['lng']),
      );
      final altitude = mapString(item['altitude'] ?? item['elevation'] ?? item['elevationFeet'] ?? '0');

      return AeroportModel(
        icao: icaoCode,
        iata: iataCode,
        name: name,
        city: city,
        country: country,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
      );
    } catch (_) {
      return null;
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   _crudService = ObjectBoxCrudService(Get.find<ObjectBoxService>());
  // }

  Future<AeroportModel?> fetchAirportFromApiByIata({required String iata}) async {
    final uri = Uri.parse('https://airports.p.rapidapi.com/v1/airports');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'x-rapidapi-host': 'airports.p.rapidapi.com',
      'x-rapidapi-key': _rapidApiKey,
    };

    // Body shape varies by provider; we include common keys used by such endpoints.
    final payload = <String, dynamic>{
      'iata': iata,
      'iataCode': iata,
      'search': iata,
      // Some APIs support pagination or filters; not setting extras here.
    };

    try {
      final resp = await http.post(uri, headers: headers, body: jsonEncode(payload));

      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        return null;
      }

      final dynamic decoded = jsonDecode(resp.body);

      // Normalize possible response shapes to a list of maps
      List<dynamic> items;
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map<String, dynamic>) {
        items = (decoded['data'] ?? decoded['items'] ?? decoded['results'] ?? []) as List<dynamic>;
      } else {
        return null;
      }

      // Find best matching entry by IATA
      Map<String, dynamic>? item;
      for (final it in items) {
        if (it is Map<String, dynamic>) {
          final itIata = (it['IATA'] ?? it['iata'] ?? it['codeIataAirport'] ?? '').toString();
          if (itIata.toUpperCase() == iata.toUpperCase()) {
            item = it;
            break;
          }
        }
      }

      item ??= (items.isNotEmpty && items.first is Map<String, dynamic>)
          ? items.first as Map<String, dynamic>
          : null;
      if (item == null) return null;

      // Map various possible keys to AirportModel fields
      String mapString(dynamic v, [String def = '']) => (v ?? def).toString();
      double mapDouble(dynamic v) {
        if (v == null) return 0.0;
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString()) ?? 0.0;
      }

      final icao = mapString(item['ICAO'] ?? item['icao'] ?? item['codeIcaoAirport']);
      final iataCode = mapString(item['IATA'] ?? item['iata'] ?? item['codeIataAirport'] ?? iata);
      final name = mapString(item['NAME'] ?? item['name'] ?? item['airportName'] ?? item['an']);
      final city = mapString(item['City'] ?? item['city'] ?? item['cityName'] ?? item['ct']);
      // Prefer full country name if available (cn), otherwise code (country/cc) or other variants
      final country = mapString(
        item['cn'] ?? item['contry'] ?? item['country'] ?? item['cc'] ?? item['countryName'],
      );

      double latitude = mapDouble(item['latitude'] ?? item['lat'] ?? (item['location']?['lat']));
      double longitude = mapDouble(
        item['longitude'] ?? item['lng'] ?? item['lon'] ?? (item['location']?['lng']),
      );
      final altitude = mapString(item['altitude'] ?? item['elevation'] ?? item['elevationFeet'] ?? '0');

      return AeroportModel(
        icao: icao,
        iata: iataCode,
        name: name,
        city: city,
        country: country,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
      );
    } catch (_) {
      return null;
    }
  }

  AeroportModel? getAeroportByIata({required String search}) {
    AeroportModel? existing;
    if (search.isEmpty) return existing;

    for (final a in DatabaseController.instance.airports) {
      if ((a.iata).toUpperCase() == search.toUpperCase()) {
        existing = a;
        break;
      }
    }
    return existing;
  }

  AeroportModel? getAeroportByIcao({required String search}) {
    AeroportModel? existing;
    if (search.isEmpty) return existing;

    for (final a in DatabaseController.instance.airports) {
      if ((a.icao).toUpperCase() == search.toUpperCase()) {
        existing = a;
        break;
      }
    }
    return existing;
  }

  Future<AeroportModel?> ensureAirportByIata(String iata) async {
    final code = iata.trim().toUpperCase();
    if (code.isEmpty) return null;

    // Refresh local airports list
    DatabaseController.instance.getAllAirports();

    // Check in-memory list first (without relying on extension methods)
    AeroportModel? existing = getAeroportByIata(search: code);
    if (existing != null) return existing;

    // Not found locally: fetch from API
    final fetched = await fetchAirportFromApiByIata(iata: code);
    if (fetched == null) return null;

    // Persist and refresh cache
    // Use service's add to both persist and refresh controller cache
    DatabaseController.instance.addAirport(fetched);

    return fetched;
  }

  // ===== Airports related helpers for AeroportForfaitScreen (MVC: move logic to Controller) =====

  /// Search by IATA or ICAO and fill the given text controllers. If not found,
  /// propose fetching via API (same UX as AeroportScreen._searchAeroportByIataOrIcao).
  Future<void> searchAndFillByIataOrIcao({
    required BuildContext context,
    required TextEditingController icaoCtl,
    required TextEditingController iataCtl,
    required TextEditingController nameCtl,
    required TextEditingController cityCtl,
    required TextEditingController countryCtl,
    required TextEditingController latCtl,
    required TextEditingController lngCtl,
    required TextEditingController altCtl,
  }) async {
    final iata = iataCtl.text.trim().toUpperCase();
    final icao = icaoCtl.text.trim().toUpperCase();
    if (iata.isEmpty && icao.isEmpty) {
      Get.snackbar('Info', 'Entrez un code IATA ou ICAO', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Ensure latest cache
    DatabaseController.instance.getAllAirports();
    final list = DatabaseController.instance.airports;
    final idx = list.indexWhere(
      (a) =>
          (iata.isNotEmpty && a.iata.toUpperCase() == iata) ||
          (icao.isNotEmpty && a.icao.toUpperCase() == icao),
    );
    final found = idx >= 0 ? list[idx] : null;

    if (found != null) {
      _fillControllersFromAirport(
        airport: found,
        icaoCtl: icaoCtl,
        iataCtl: iataCtl,
        nameCtl: nameCtl,
        cityCtl: cityCtl,
        countryCtl: countryCtl,
        latCtl: latCtl,
        lngCtl: lngCtl,
        altCtl: altCtl,
      );
      Get.snackbar('Succès', 'Aéroport trouvé et formulaire rempli', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final code = iata.isNotEmpty ? iata : icao;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Aéroport introuvable'),
        content: Text('Voulez-vous le récupérer via API pour "$code" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Fetcher')),
        ],
      ),
    );
    if (confirmed == true) {
      // Note: ensureAirportByIata uses IATA; mimics AeroportScreen behavior
      final res = await ensureAirportByIata(code);
      if (res != null) {
        _fillControllersFromAirport(
          airport: res,
          icaoCtl: icaoCtl,
          iataCtl: iataCtl,
          nameCtl: nameCtl,
          cityCtl: cityCtl,
          countryCtl: countryCtl,
          latCtl: latCtl,
          lngCtl: lngCtl,
          altCtl: altCtl,
        );
        Get.snackbar('Succès', 'Aéroport ${res.iata} récupéré', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Info', 'Introuvable pour "$code"', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void _fillControllersFromAirport({
    required AeroportModel airport,
    required TextEditingController icaoCtl,
    required TextEditingController iataCtl,
    required TextEditingController nameCtl,
    required TextEditingController cityCtl,
    required TextEditingController countryCtl,
    required TextEditingController latCtl,
    required TextEditingController lngCtl,
    required TextEditingController altCtl,
  }) {
    icaoCtl.text = airport.icao;
    iataCtl.text = airport.iata;
    nameCtl.text = airport.name;
    cityCtl.text = airport.city;
    countryCtl.text = airport.country;
    latCtl.text = airport.latitude.toString();
    lngCtl.text = airport.longitude.toString();
    altCtl.text = airport.altitude;
  }

  /// Create or update an airport from form fields.
  /// If an airport with provided IATA/ICAO exists, update it; otherwise create.
  void saveOrUpdateAirportFromForm({
    required TextEditingController icaoCtl,
    required TextEditingController iataCtl,
    required TextEditingController nameCtl,
    required TextEditingController cityCtl,
    required TextEditingController countryCtl,
    required TextEditingController latCtl,
    required TextEditingController lngCtl,
    required TextEditingController altCtl,
  }) {
    final icao = icaoCtl.text.trim();
    final iata = iataCtl.text.trim();
    final existing =
        DatabaseController.instance.getAeroportByIata(iata) ??
        DatabaseController.instance.getAeroportByOaci(icao);

    final lat = double.tryParse(latCtl.text.trim()) ?? (existing?.latitude ?? 0.0);
    final lng = double.tryParse(lngCtl.text.trim()) ?? (existing?.longitude ?? 0.0);

    if (existing != null) {
      final updated = existing.copyWith(
        icao: icao,
        iata: iata,
        name: nameCtl.text.trim(),
        city: cityCtl.text.trim(),
        country: countryCtl.text.trim(),
        latitude: lat,
        longitude: lng,
        altitude: altCtl.text.trim(),
        updatedAt: DateTime.now(),
      );
      DatabaseController.instance.updateAirport(updated);
      Get.snackbar('Succès', 'Aéroport mis à jour', snackPosition: SnackPosition.BOTTOM);
    } else {
      final created = AeroportModel(
        icao: icao,
        iata: iata,
        name: nameCtl.text.trim(),
        city: cityCtl.text.trim(),
        country: countryCtl.text.trim(),
        latitude: lat,
        longitude: lng,
        altitude: altCtl.text.trim(),
      );
      DatabaseController.instance.addAirport(created);
      Get.snackbar('Succès', 'Aéroport ajouté', snackPosition: SnackPosition.BOTTOM);
    }
  }

  //  /// Check if airport exists by ICAO code
  //   bool airportExistsByIcao(String icao) {
  //     return _crudService.airportExistsByIcao(icao);
  //   }
  //   void clearAllAirports() {
  //     _crudService.clearAllAirports();
  //     getAllAirports();
  //   }

  //   /// Check if airport exists by IATA code
  //   bool airportExistsByIata(String iata) {
  //     return _crudService.airportExistsByIata(iata);
  //   }

  //   AeroportModel? getAirportByIcao(String icao) {
  //     return _crudService.getAirportByIcao(icao);
  //   }

  // AeroportModel? getAirportByIata(String iata) {
  //   return _crudService.getAirportByIata(iata);
  // }

  //   List<AeroportModel> getAirportsByCountry(String country) {
  //     return _crudService.getAirportsByCountry(country);
  //   }

  //   List<AeroportModel> getAirportsByCity(String city) {
  //     return _crudService.getAirportsByCity(city);
  //   }

  //   List<AeroportModel> searchAirportsByName(String searchTerm) {
  //     return _crudService.searchAirportsByName(searchTerm);
  //   }
  //   // void addAirport(AeroportModel airport) {
  //   //   _crudService.addAirport(airport);
  //   //   getAllAirports();
  //   // }

  //   // AeroportModel? getAirport(int id) {
  //   //   return _crudService.getAirport(id);
  //   // }
  //   void getAllAirports() {
  //     DatabaseController.instance.airports.assignAll(_crudService.getAllAirports());
  //   }

  //   void updateAirport(AeroportModel airport) {
  //     _crudService.updateAirport(airport);
  //     getAllAirports();
  //   }

  //   void deleteAirport(int id) {
  //     _crudService.deleteAirport(id);
  //     getAllAirports();
  //   }

  //   /// Get airports count
  //   int getAirportsCount() {
  //     return _crudService.getAirportsCount();
  //   }

  /// Fetch a single airport from RapidAPI (World Airports) by ICAO code.
  /// This only fetches and returns the mapped AirportModel; persistence is up to caller.
  /// - Uses POST https://airports.p.rapidapi.com/v1/airports
  /// - Required header: x-rapidapi-key (pass in parameter; do NOT hardcode)
  /// - The API may return a list; we pick the item matching the ICAO.

  /// Fetch a single airport from RapidAPI (World Airports) by IATA code.
  /// This only fetches and returns the mapped AirportModel; persistence is up to caller.
  /// - Uses POST https://airports.p.rapidapi.com/v1/airports
  /// - Required header: x-rapidapi-key (pass in parameter; do NOT hardcode)
  /// - The API may return a list; we pick the item matching the IATA.
  ///
  /// Delete an airport by IATA/ICAO from the form fields
  // void deleteAirportByCodes({
  //   required TextEditingController icaoCtl,
  //   required TextEditingController iataCtl,
  // }) {
  //   final icao = icaoCtl.text.trim();
  //   final iata = iataCtl.text.trim();
  //   final existing = _airSvc.getAirportByIata(iata) ?? _airSvc.getAirportByIcao(icao);
  //   if (existing == null) {
  //     Get.snackbar('Info', 'Aéroport introuvable', snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //   _airSvc.deleteAirport(existing.id);
  //   Get.snackbar('Succès', 'Aéroport supprimé', snackPosition: SnackPosition.BOTTOM);
  // }
}
