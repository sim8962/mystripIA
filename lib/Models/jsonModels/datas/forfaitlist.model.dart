import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import '../../../helpers/myerrorinfo.dart';
import 'forfait_model.dart';

/// ForfaitListModel - ObjectBox Entity
/// Represents a collection of forfaits with metadata
@Entity()
class ForfaitListModel {
  @Id()
  int id = 0;

  @Property()
  String name;

  @Property(type: PropertyType.date)
  DateTime date;

  /// ObjectBox ToMany relationship with ForfaitModel
  final forfaits = ToMany<ForfaitModel>();

  ForfaitListModel({this.id = 0, required this.name, required this.date});

  /// Factory constructor from JSON
  factory ForfaitListModel.fromJson(Map<String, dynamic> json) {
    final model = ForfaitListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );

    // Parse forfaits list if present
    if (json['forfaits'] != null && json['forfaits'] is List) {
      final forfaitsList = (json['forfaits'] as List)
          .map((item) => ForfaitModel.fromJson(item as Map<String, dynamic>))
          .toList();
      model.forfaits.addAll(forfaitsList);
    }

    return model;
  }

  /// Factory constructor from JSON string
  factory ForfaitListModel.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ForfaitListModel.fromJson(json);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'forfaits': forfaits.map((f) => f.toJson()).toList(),
    };
  }

  /// Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Copy with method for updates
  ForfaitListModel copyWith({int? id, String? name, DateTime? date, List<ForfaitModel>? forfaits}) {
    final model = ForfaitListModel(id: id ?? this.id, name: name ?? this.name, date: date ?? this.date);
    List<ForfaitModel> newForfaits = [];
    // Copy forfaits if provided
    if (forfaits != null) {
      model.forfaits.clear();
      newForfaits = forfaits.map((forfait) => forfait.copyWith(id: 0)).toSet().toList();
      model.forfaits.addAll(newForfaits);
    } else {
      newForfaits = this.forfaits.map((forfait) => forfait.copyWith(id: 0)).toSet().toList();
    }
    model.forfaits.addAll(newForfaits);
    return model;
  }

  @override
  String toString() {
    return 'ForfaitListModel(id: $id, name: $name, date: $date, '
        'forfaitsCount: ${forfaits.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForfaitListModel &&
        other.id == id &&
        other.name == name &&
        other.forfaits.length == forfaits.length;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ forfaits.length;
  }

  static Future<ForfaitListModel?> getForfaitListFromExcel(File excelFile, DateFormat dateFormat) async {
    // Extract filename
    try {
      String fileName = excelFile.path.split('/').last;
      DateTime fileDate = dateFormat.parse(fileName);

      final bytes = await excelFile.readAsBytes();
      List<ForfaitModel> forfaitsFromFile = ForfaitModel.parseExcel(bytes);

      // Assign dateForfait to each forfait

      String sDateForfait = dateFormat.format(fileDate);
      for (var forfait in forfaitsFromFile) {
        forfait.dateForfait = sDateForfait;
      }

      // Create ForfaitListModel for this file
      final forfaitList = ForfaitListModel(name: sDateForfait, date: fileDate);
      forfaitList.forfaits.clear();
      forfaitList.forfaits.addAll(forfaitsFromFile);
      return forfaitList;
    } catch (e) {
      //print('e:$e');
      MyErrorInfo.erreurInos(
        label: 'ForfaitListModel getForfaitListFromExcel',
        content: 'Error during excel parse: $e',
      );
      return null;
    }
  }

  /// Add a forfait to the list
  // void addForfait(ForfaitModel forfait) {
  //   forfaits.add(forfait);
  // }

  // /// Add multiple forfaits to the list
  // void addForfaits(List<ForfaitModel> forfaitsList) {
  //   forfaits.addAll(forfaitsList);
  // }

  // /// Remove a forfait from the list
  // void removeForfait(ForfaitModel forfait) {
  //   forfaits.remove(forfait);
  // }

  // /// Clear all forfaits
  // void clearForfaits() {
  //   forfaits.clear();
  // }
}
