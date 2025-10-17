class Dutie {
  Dutie({
    required this.customAttributes,
    required this.annotations,
    required this.startStation,
    required this.endStation,
    required this.startTime,
    required this.endTime,
    required this.startTimeOffset,
    required this.endTimeOffset,
    required this.duration,
    required this.durationMinutes,
    required this.isWholeDayActivity,
    required this.id,
    required this.length,
    required this.time,
    required this.timeMinutes,
    required this.type,
  });

  final List<dynamic> customAttributes;
  final List<dynamic> annotations;
  final String? startStation;
  final String? endStation;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? startTimeOffset;
  final int? endTimeOffset;
  final int? duration;
  final int? durationMinutes;
  final bool? isWholeDayActivity;
  final int? id;
  final int? length;
  final int? time;
  final int? timeMinutes;
  final String? type;

  Dutie copyWith({
    List<dynamic>? customAttributes,
    List<dynamic>? annotations,
    String? startStation,
    String? endStation,
    DateTime? startTime,
    DateTime? endTime,
    int? startTimeOffset,
    int? endTimeOffset,
    int? duration,
    int? durationMinutes,
    bool? isWholeDayActivity,
    int? id,
    int? length,
    int? time,
    int? timeMinutes,
    String? type,
  }) {
    return Dutie(
      customAttributes: customAttributes ?? this.customAttributes,
      annotations: annotations ?? this.annotations,
      startStation: startStation ?? this.startStation,
      endStation: endStation ?? this.endStation,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startTimeOffset: startTimeOffset ?? this.startTimeOffset,
      endTimeOffset: endTimeOffset ?? this.endTimeOffset,
      duration: duration ?? this.duration,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isWholeDayActivity: isWholeDayActivity ?? this.isWholeDayActivity,
      id: id ?? this.id,
      length: length ?? this.length,
      time: time ?? this.time,
      timeMinutes: timeMinutes ?? this.timeMinutes,
      type: type ?? this.type,
    );
  }

  factory Dutie.fromJson(Map<String, dynamic> json) {
    return Dutie(
      customAttributes: json["customAttributes"] == null
          ? []
          : List<dynamic>.from(json["customAttributes"]!.map((x) => x)),
      annotations: json["annotations"] == null ? [] : List<dynamic>.from(json["annotations"]!.map((x) => x)),
      startStation: json["startStation"],
      endStation: json["endStation"],
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      startTimeOffset: json["startTimeOffset"],
      endTimeOffset: json["endTimeOffset"],
      duration: json["duration"],
      durationMinutes: json["durationMinutes"],
      isWholeDayActivity: json["isWholeDayActivity"],
      id: json["id"],
      length: json["length"],
      time: json["time"],
      timeMinutes: json["timeMinutes"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() => {
    "customAttributes": customAttributes.map((x) => x).toList(),
    "annotations": annotations.map((x) => x).toList(),
    "startStation": startStation,
    "endStation": endStation,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "startTimeOffset": startTimeOffset,
    "endTimeOffset": endTimeOffset,
    "duration": duration,
    "durationMinutes": durationMinutes,
    "isWholeDayActivity": isWholeDayActivity,
    "id": id,
    "length": length,
    "time": time,
    "timeMinutes": timeMinutes,
    "type": type,
  };

  @override
  String toString() {
    return "$customAttributes, $annotations, $startStation, $endStation, $startTime, $endTime, $startTimeOffset, $endTimeOffset, $duration, $durationMinutes, $isWholeDayActivity, $id, $length, $time, $timeMinutes, $type, ";
  }
}
