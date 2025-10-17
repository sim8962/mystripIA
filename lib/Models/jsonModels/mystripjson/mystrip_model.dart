import 'my_entity_model.dart';

class MyStrip {
  MyStrip({required this.downloadTime, required this.entity});

  final DateTime? downloadTime;
  final MyEntity? entity;

  MyStrip copyWith({DateTime? downloadTime, MyEntity? entity}) {
    return MyStrip(downloadTime: downloadTime ?? this.downloadTime, entity: entity ?? this.entity);
  }

  factory MyStrip.fromJson(Map<String, dynamic> json) {
    return MyStrip(
      downloadTime: DateTime.tryParse(json["downloadTime"] ?? ""),
      entity: json["entity"] == null ? null : MyEntity.fromJson(json["entity"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "downloadTime": downloadTime?.toIso8601String(),
    "entity": entity?.toJson(),
  };

  @override
  String toString() {
    return "$downloadTime, $entity, ";
  }
}
