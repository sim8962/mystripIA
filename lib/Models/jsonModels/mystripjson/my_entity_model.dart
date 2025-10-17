import 'entity_activity_model.dart';
import '../basicModels/period.dart';

class MyEntity {
  MyEntity({this.customAttributes, this.activities, this.periods, this.crewId, this.tradeWindows});

  final List<dynamic>? customAttributes;
  final List<Activities>? activities;
  final List<Period>? periods;
  final String? crewId;
  final List<dynamic>? tradeWindows;

  MyEntity copyWith({
    List<dynamic>? customAttributes,
    List<Activities>? activities,
    List<Period>? periods,
    String? crewId,
    List<dynamic>? tradeWindows,
  }) {
    return MyEntity(
      customAttributes: customAttributes ?? this.customAttributes,
      activities: activities ?? this.activities,
      periods: periods ?? this.periods,
      crewId: crewId ?? this.crewId,
      tradeWindows: tradeWindows ?? this.tradeWindows,
    );
  }

  factory MyEntity.fromJson(Map<String, dynamic> json) {
    return MyEntity(
      customAttributes: json["customAttributes"] == null
          ? null
          : List<dynamic>.from(json["customAttributes"]!.map((x) => x)),
      activities: json["activities"] == null
          ? null
          : List<Activities>.from(json["activities"]!.map((x) => Activities.fromJson(x))),
      periods: json["periods"] == null
          ? null
          : List<Period>.from(json["periods"]!.map((x) => Period.fromJson(x))),
      crewId: json["crewId"],
      tradeWindows: json["tradeWindows"] == null
          ? null
          : List<dynamic>.from(json["tradeWindows"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "customAttributes": customAttributes?.map((x) => x).toList(),
    "activities": activities?.map((x) => x.toJson()).toList(),
    "periods": periods?.map((x) => x.toJson()).toList(),
    "crewId": crewId,
    "tradeWindows": tradeWindows?.map((x) => x).toList(),
  };

  @override
  String toString() {
    return "$customAttributes, $activities, $periods, $crewId, $tradeWindows, ";
  }
}
