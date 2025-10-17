class Period {
  Period({
    required this.customAttributes,
    required this.index,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.currentBlockTime,
    required this.currentDutyCreditTime,
    required this.totalBlockTime,
    required this.totalDutyCreditTime,
    required this.originalBlockTime,
    required this.originalDutyCreditTime,
    required this.isCabin,
  });

  final List<dynamic> customAttributes;
  final int? index;
  final String? name;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? currentBlockTime;
  final int? currentDutyCreditTime;
  final int? totalBlockTime;
  final int? totalDutyCreditTime;
  final int? originalBlockTime;
  final int? originalDutyCreditTime;
  final bool? isCabin;

  Period copyWith({
    List<dynamic>? customAttributes,
    int? index,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    int? currentBlockTime,
    int? currentDutyCreditTime,
    int? totalBlockTime,
    int? totalDutyCreditTime,
    int? originalBlockTime,
    int? originalDutyCreditTime,
    bool? isCabin,
  }) {
    return Period(
      customAttributes: customAttributes ?? this.customAttributes,
      index: index ?? this.index,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      currentBlockTime: currentBlockTime ?? this.currentBlockTime,
      currentDutyCreditTime: currentDutyCreditTime ?? this.currentDutyCreditTime,
      totalBlockTime: totalBlockTime ?? this.totalBlockTime,
      totalDutyCreditTime: totalDutyCreditTime ?? this.totalDutyCreditTime,
      originalBlockTime: originalBlockTime ?? this.originalBlockTime,
      originalDutyCreditTime: originalDutyCreditTime ?? this.originalDutyCreditTime,
      isCabin: isCabin ?? this.isCabin,
    );
  }

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      customAttributes: json["customAttributes"] == null
          ? []
          : List<dynamic>.from(json["customAttributes"]!.map((x) => x)),
      index: json["index"],
      name: json["name"],
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      currentBlockTime: json["currentBlockTime"],
      currentDutyCreditTime: json["currentDutyCreditTime"],
      totalBlockTime: json["totalBlockTime"],
      totalDutyCreditTime: json["totalDutyCreditTime"],
      originalBlockTime: json["originalBlockTime"],
      originalDutyCreditTime: json["originalDutyCreditTime"],
      isCabin: json["isCabin"],
    );
  }

  Map<String, dynamic> toJson() => {
    "customAttributes": customAttributes.map((x) => x).toList(),
    "index": index,
    "name": name,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "currentBlockTime": currentBlockTime,
    "currentDutyCreditTime": currentDutyCreditTime,
    "totalBlockTime": totalBlockTime,
    "totalDutyCreditTime": totalDutyCreditTime,
    "originalBlockTime": originalBlockTime,
    "originalDutyCreditTime": originalDutyCreditTime,
    "isCabin": isCabin,
  };

  @override
  String toString() {
    return "$customAttributes, $index, $name, $startTime, $endTime, $currentBlockTime, $currentDutyCreditTime, $totalBlockTime, $totalDutyCreditTime, $originalBlockTime, $originalDutyCreditTime, $isCabin, ";
  }
}
