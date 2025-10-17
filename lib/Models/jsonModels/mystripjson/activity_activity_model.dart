import '../basicModels/checkin.dart';
import '../basicModels/activity_code.dart';
import '../basicModels/assigned_crew.dart';
import '../basicModels/training_tag.dart';
import '../basicModels/role.dart';
import 'labels.dart';
import 'hotel.dart';

class Activity {
  Activity({
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
    required this.fingerprint,
    required this.trainingTags,
    required this.dutyId,
    required this.type,
    required this.checkin,
    required this.role,
    required this.assignedCrew,
    required this.labels,
    required this.dor,
    required this.flightNumber,
    required this.carrier,
    required this.opSuffix,
    required this.isCancelled,
    required this.isCharter,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    required this.blockTimeMinutes,
    required this.connectionTimeMinutes,
    required this.dutyTime,
    required this.aircraftType,
    required this.tail,
    required this.hasLayoverAfter,
    required this.statusLabel,
    required this.isPositioning,
    required this.isPassive,
    required this.isOffDuty,
    required this.isOther,
    required this.hotel,
    required this.activityCode,
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
  final String? fingerprint;
  final List<TrainingTag> trainingTags;
  final int? dutyId;
  final String? type;
  final Checkin? checkin;
  final Role? role;
  final List<AssignedCrew> assignedCrew;
  final Labels? labels;
  final int? dor;
  final String? flightNumber;
  final String? carrier;
  final String? opSuffix;
  final bool? isCancelled;
  final bool? isCharter;
  final DateTime? scheduledStartTime;
  final DateTime? scheduledEndTime;
  final int? blockTimeMinutes;
  final int? connectionTimeMinutes;
  final int? dutyTime;
  final String? aircraftType;
  final String? tail;
  final bool? hasLayoverAfter;
  final String? statusLabel;
  final bool? isPositioning;
  final bool? isPassive;
  final bool? isOffDuty;
  final bool? isOther;
  final Hotel? hotel;
  final ActivityCode? activityCode;

  Activity copyWith({
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
    String? fingerprint,
    List<TrainingTag>? trainingTags,
    int? dutyId,
    String? type,
    Checkin? checkin,
    Role? role,
    List<AssignedCrew>? assignedCrew,
    Labels? labels,
    int? dor,
    String? flightNumber,
    String? carrier,
    String? opSuffix,
    bool? isCancelled,
    bool? isCharter,
    DateTime? scheduledStartTime,
    DateTime? scheduledEndTime,
    int? blockTimeMinutes,
    int? connectionTimeMinutes,
    int? dutyTime,
    String? aircraftType,
    String? tail,
    bool? hasLayoverAfter,
    String? statusLabel,
    bool? isPositioning,
    bool? isPassive,
    bool? isOffDuty,
    bool? isOther,
    Hotel? hotel,
    ActivityCode? activityCode,
  }) {
    return Activity(
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
      fingerprint: fingerprint ?? this.fingerprint,
      trainingTags: trainingTags ?? this.trainingTags,
      dutyId: dutyId ?? this.dutyId,
      type: type ?? this.type,
      checkin: checkin ?? this.checkin,
      role: role ?? this.role,
      assignedCrew: assignedCrew ?? this.assignedCrew,
      labels: labels ?? this.labels,
      dor: dor ?? this.dor,
      flightNumber: flightNumber ?? this.flightNumber,
      carrier: carrier ?? this.carrier,
      opSuffix: opSuffix ?? this.opSuffix,
      isCancelled: isCancelled ?? this.isCancelled,
      isCharter: isCharter ?? this.isCharter,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      scheduledEndTime: scheduledEndTime ?? this.scheduledEndTime,
      blockTimeMinutes: blockTimeMinutes ?? this.blockTimeMinutes,
      connectionTimeMinutes: connectionTimeMinutes ?? this.connectionTimeMinutes,
      dutyTime: dutyTime ?? this.dutyTime,
      aircraftType: aircraftType ?? this.aircraftType,
      tail: tail ?? this.tail,
      hasLayoverAfter: hasLayoverAfter ?? this.hasLayoverAfter,
      statusLabel: statusLabel ?? this.statusLabel,
      isPositioning: isPositioning ?? this.isPositioning,
      isPassive: isPassive ?? this.isPassive,
      isOffDuty: isOffDuty ?? this.isOffDuty,
      isOther: isOther ?? this.isOther,
      hotel: hotel ?? this.hotel,
      activityCode: activityCode ?? this.activityCode,
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    int? parseToInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    String? parseToString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    return Activity(
      customAttributes: json["customAttributes"] == null
          ? []
          : List<dynamic>.from(json["customAttributes"]!.map((x) => x)),
      annotations: json["annotations"] == null ? [] : List<dynamic>.from(json["annotations"]!.map((x) => x)),
      startStation: json["startStation"],
      endStation: json["endStation"],
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      startTimeOffset: parseToInt(json["startTimeOffset"]),
      endTimeOffset: parseToInt(json["endTimeOffset"]),
      duration: parseToInt(json["duration"]),
      durationMinutes: parseToInt(json["durationMinutes"]),
      isWholeDayActivity: json["isWholeDayActivity"],
      fingerprint: json["fingerprint"],
      trainingTags: json["trainingTags"] == null
          ? []
          : List<TrainingTag>.from(json["trainingTags"]!.map((x) => TrainingTag.fromJson(x))),
      dutyId: parseToInt(json["dutyId"]),
      type: json["type"],
      checkin: json["checkin"] == null ? null : Checkin.fromJson(json["checkin"]),
      role: json["role"] == null ? null : Role.fromJson(json["role"]),
      assignedCrew: json["assignedCrew"] == null
          ? []
          : List<AssignedCrew>.from(json["assignedCrew"]!.map((x) => AssignedCrew.fromJson(x))),
      labels: json["labels"] == null ? null : Labels.fromJson(json["labels"]),
      dor: parseToInt(json["dor"]),
      flightNumber: parseToString(json["flightNumber"]),
      carrier: json["carrier"],
      opSuffix: json["opSuffix"],
      isCancelled: json["isCancelled"],
      isCharter: json["isCharter"],
      scheduledStartTime: DateTime.tryParse(json["scheduledStartTime"] ?? ""),
      scheduledEndTime: DateTime.tryParse(json["scheduledEndTime"] ?? ""),
      blockTimeMinutes: parseToInt(json["blockTimeMinutes"]),
      connectionTimeMinutes: parseToInt(json["connectionTimeMinutes"]),
      dutyTime: parseToInt(json["dutyTime"]),
      aircraftType: json["aircraftType"],
      tail: json["tail"],
      hasLayoverAfter: json["hasLayoverAfter"],
      statusLabel: json["statusLabel"],
      isPositioning: json["isPositioning"],
      isPassive: json["isPassive"],
      isOffDuty: json["isOffDuty"],
      isOther: json["isOther"],
      hotel: json["hotel"] == null ? null : Hotel.fromJson(json["hotel"]),
      activityCode: json["activityCode"] == null ? null : ActivityCode.fromJson(json["activityCode"]),
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
    "fingerprint": fingerprint,
    "trainingTags": trainingTags.map((x) => x.toJson()).toList(),
    "dutyId": dutyId,
    "type": type,
    "checkin": checkin?.toJson(),
    "role": role?.toJson(),
    "assignedCrew": assignedCrew.map((x) => x.toJson()).toList(),
    "labels": labels?.toJson(),
    "dor": dor,
    "flightNumber": flightNumber,
    "carrier": carrier,
    "opSuffix": opSuffix,
    "isCancelled": isCancelled,
    "isCharter": isCharter,
    "scheduledStartTime": scheduledStartTime?.toIso8601String(),
    "scheduledEndTime": scheduledEndTime?.toIso8601String(),
    "blockTimeMinutes": blockTimeMinutes,
    "connectionTimeMinutes": connectionTimeMinutes,
    "dutyTime": dutyTime,
    "aircraftType": aircraftType,
    "tail": tail,
    "hasLayoverAfter": hasLayoverAfter,
    "statusLabel": statusLabel,
    "isPositioning": isPositioning,
    "isPassive": isPassive,
    "isOffDuty": isOffDuty,
    "isOther": isOther,
    "hotel": hotel?.toJson(),
    "activityCode": activityCode?.toJson(),
  };

  @override
  String toString() {
    return "$customAttributes, $annotations, $startStation, $endStation, $startTime, $endTime, $startTimeOffset, $endTimeOffset, $duration, $durationMinutes, $isWholeDayActivity, $fingerprint, $trainingTags, $dutyId, $type, $checkin, $role, $assignedCrew, $labels, $dor, $flightNumber, $carrier, $opSuffix, $isCancelled, $isCharter, $scheduledStartTime, $scheduledEndTime, $blockTimeMinutes, $connectionTimeMinutes, $dutyTime, $aircraftType, $tail, $hasLayoverAfter, $statusLabel, $isPositioning, $isPassive, $isOffDuty, $isOther, $hotel, $activityCode, ";
  }
}
