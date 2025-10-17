class Checkin {
    Checkin({
        required this.startTime,
        required this.endTime,
        required this.startTimeOffset,
        required this.endTimeOffset,
    });

    final DateTime? startTime;
    final DateTime? endTime;
    final int? startTimeOffset;
    final int? endTimeOffset;

    Checkin copyWith({
        DateTime? startTime,
        DateTime? endTime,
        int? startTimeOffset,
        int? endTimeOffset,
    }) {
        return Checkin(
            startTime: startTime ?? this.startTime,
            endTime: endTime ?? this.endTime,
            startTimeOffset: startTimeOffset ?? this.startTimeOffset,
            endTimeOffset: endTimeOffset ?? this.endTimeOffset,
        );
    }

    factory Checkin.fromJson(Map<String, dynamic> json){ 
        return Checkin(
            startTime: DateTime.tryParse(json["startTime"] ?? ""),
            endTime: DateTime.tryParse(json["endTime"] ?? ""),
            startTimeOffset: json["startTimeOffset"],
            endTimeOffset: json["endTimeOffset"],
        );
    }

    Map<String, dynamic> toJson() => {
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "startTimeOffset": startTimeOffset,
        "endTimeOffset": endTimeOffset,
    };

    @override
    String toString(){
        return "$startTime, $endTime, $startTimeOffset, $endTimeOffset, ";
    }
}
