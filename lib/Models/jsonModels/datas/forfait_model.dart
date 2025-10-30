import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

import 'package:mystrip25/Models/jsonModels/datas/airport_model.dart';

import 'package:objectbox/objectbox.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/myerrorinfo.dart';
import '../../../helpers/fct.dart';
import '../../../controllers/database_controller.dart';
import 'forfaitlist.model.dart';

@Entity()
class ForfaitModel {
  @Id()
  int id = 0;

  @Property()
  String cle;

  @Property()
  String saison;

  @Property()
  String secteur;

  @Property()
  String depICAO;

  @Property()
  String arrICAO;

  @Property()
  String depIATA;

  @Property()
  String arrIATA;

  @Property()
  String forfait;

  @Property()
  String table;

  @Property()
  String dateForfait;

  ForfaitModel({
    this.id = 0,
    required this.cle,
    required this.saison,
    required this.secteur,
    required this.depICAO,
    required this.arrICAO,
    required this.depIATA,
    required this.arrIATA,
    required this.forfait,
    required this.table,
    required this.dateForfait,
  });

  // Factory constructor from JSON
  factory ForfaitModel.fromJson(Map<String, dynamic> json) {
    final forfaitStr = json['Forfait'] ?? '';
    final sheure = Fct.formatForfaitTime(forfaitStr);

    return ForfaitModel(
      id: json['id'] ?? 0,
      cle: json['Clé'] ?? '',
      saison: json['Saison'] ?? '',
      secteur: json['Secteur'] ?? '',
      depICAO: json['depICAO'] ?? '',
      arrICAO: json['arrICAO'] ?? '',
      depIATA: json['depIATA'] ?? '',
      arrIATA: json['arrIATA'] ?? '',
      forfait: sheure,
      table: json['Table'] ?? '',
      dateForfait: json['date forfait'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      "Clé": cle,
      "Saison": saison,
      "Secteur": secteur,
      "depICAO": depICAO,
      "arrICAO": arrICAO,
      "depIATA": depIATA,
      "arrIATA": arrIATA,
      "Forfait": forfait.padLeft(5, "0"),
      "Table": table,
      "date forfait": dateForfait,
      // 'createdAt': createdAt?.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for updates
  ForfaitModel copyWith({
    int? id,
    String? cle,
    String? saison,
    String? secteur,
    String? escaleDepart,
    String? escaleArrivee,
    String? depIATA,
    String? arrIATA,
    String? forfait,
    String? table,
    String? dateForfait,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ForfaitModel(
      id: id ?? this.id,
      cle: cle ?? this.cle,
      saison: saison ?? this.saison,
      secteur: secteur ?? this.secteur,
      depICAO: escaleDepart ?? depICAO,
      arrICAO: escaleArrivee ?? arrICAO,
      depIATA: depIATA ?? this.depIATA,
      arrIATA: arrIATA ?? this.arrIATA,
      forfait: forfait ?? this.forfait,
      table: table ?? this.table,
      dateForfait: dateForfait ?? this.dateForfait,
    );
  }

  @override
  String toString() {
    return 'ForfaitModel(id: $id, cle: $cle, saison: $saison, secteur: $secteur, depIATA: $depIATA, arrIATA: $arrIATA, forfait: $forfait, table: $table, dateForfait: $dateForfait)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForfaitModel && other.cle == cle && other.dateForfait == dateForfait;
  }

  @override
  int get hashCode {
    return cle.hashCode ^ dateForfait.hashCode;
  }

  static Future<List<ForfaitModel>> fetchFromJson() async {
    List<ForfaitModel> forfaits = [];
    // Load forfaits from JSON asset
    final String jsonString = await rootBundle.loadString(pathForfaitJson);
    final List<dynamic> jsonList = json.decode(jsonString);

    // Convert JSON to ForfaitModel list

    for (final jsonItem in jsonList) {
      try {
        final forfait = ForfaitModel.fromJson(jsonItem);

        // Add to forfaits list
        forfaits.add(forfait);
      } catch (e) {
        // Skip invalid forfait entries
        MyErrorInfo.erreurInos(
          label: 'ForfaitModel.fillForfaitModelBoxIfEmpty',
          content: 'Error parsing forfait: $e',
        );
        continue;
      }
    }
    return forfaits;
    // Bulk insert forfaits if we have any
  }

  static Future<void> fillForfaitModelBoxIfEmpty() async {
    final dbController = DatabaseController.instance;
    try {
      // Check if forfaits box is empty
      if (dbController.forfaits.isEmpty) {
        List<ForfaitModel> forfaits = await ForfaitModel.fetchFromJson();

        // Bulk insert forfaits if we have any
        if (forfaits.isNotEmpty) {
          List<ForfaitListModel> forfaitLists = dbController.getForfaitListsFromForfaits(forfaits);
          dbController.addForfaitLists(forfaitLists);

          // Check if Aeroport.icao in forfaits box existe in airports box
          await AeroportModel.addAeroportFromFrorfait();
          await DatabaseController.instance.exportAeroportToJson(
            fileName: 'aeropors_${DateFormat('ddMMyyyy').format(DateTime.now())}.json',
          );
        }
      }
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'AcceuilController._fillForfaitModelBoxIfEmpty',
        content: 'Error loading forfaits from JSON: $e',
      );
      // print(e);
    }
  }

  //import Excel methode

  static List<ForfaitModel> parseExcel(Uint8List bytes) {
    try {
      final excel = Excel.decodeBytes(bytes);
      if (excel.tables.isEmpty) return [];
      final sheet = excel.tables[excel.tables.keys.first]!;
      if (sheet.maxRows == 0) return [];

      final headerRow = sheet.row(0);
      final headers = headerRow.map((c) => (c?.value?.toString() ?? '').trim()).toList();

      int idxOf(String name) => headers.indexWhere((h) => h.toLowerCase() == name.toLowerCase());

      final idxCle = idxOf('Clé');
      final idxSaison = idxOf('Saison');
      final idxSecteur = idxOf('Secteur');
      final idxEscaleDep = idxOf('Escale_dep');
      final idxEscaleArr = idxOf('Escale_arr');
      // final idxDepIATA = idxOf('depIATA');
      // final idxArrIATA = idxOf('arrIATA');
      final idxForfait = idxOf('Forfait');
      final idxTable = idxOf('Table');
      // final idxDateForfait = idxOf('date forfait');

      final List<ForfaitModel> results = [];
      for (int r = 1; r < sheet.maxRows; r++) {
        final row = sheet.row(r);

        String read(int idx) {
          if (idx < 0 || idx >= row.length) return '';
          final v = row[idx]?.value;
          return (v == null) ? '' : v.toString().trim();
        }

        String depIata = AeroportModel.getAeroportByOaci(read(idxEscaleDep))?.iata ?? '';
        String arrIata = AeroportModel.getAeroportByOaci(read(idxEscaleArr))?.iata ?? '';

        String forfait = Fct.formatForfaitTime(read(idxForfait));
        // print('depIata: $depIata ,arrIata:$arrIata');

        // Build cle: use column if exists, otherwise construct from other columns
        String cle = '';
        if (idxCle >= 0) {
          cle = read(idxCle).trim().toUpperCase();
        }

        // If cle is empty or column doesn't exist, construct it
        if (cle.isEmpty) {
          //ETEMACHLCCYMXEBBR
          cle =
              read(idxSaison).trim().toUpperCase() +
              read(idxSecteur).trim().toUpperCase() +
              read(idxEscaleDep).trim().toUpperCase() +
              read(idxEscaleArr).trim().toUpperCase();
        }

        final model = ForfaitModel(
          cle: cle,
          saison: read(idxSaison).trim().toUpperCase(),
          secteur: read(idxSecteur).trim().toUpperCase(),
          depICAO: read(idxEscaleDep).trim().toUpperCase(),
          arrICAO: read(idxEscaleArr).trim().toUpperCase(),
          depIATA: depIata.trim().toUpperCase(),
          arrIATA: arrIata.trim().toUpperCase(),
          forfait: forfait.trim(),
          table: read(idxTable).trim().toUpperCase(),
          dateForfait: '01/09/2025',
        );

        if (model.cle.isEmpty && model.saison.isEmpty) continue;
        //print('R: ${(r + 1).toString().padLeft(4, '0')} ${model.cle.toString()} ${model.dateForfait}');
        results.add(model);
      }
      return results;
    } catch (e) {
      MyErrorInfo.erreurInos(
        label: 'ForfaitListModel getForfaitListFromExcel',
        content: 'Error during excel parse: $e',
      );
      return [];
    }
  }
}
