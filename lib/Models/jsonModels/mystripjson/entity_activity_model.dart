import 'activity_activity_model.dart';
import '../basicModels/activity_code.dart';
import '../basicModels/base.dart';
import '../basicModels/key.dart';
import 'duty.dart';
import 'labels.dart';
import '../basicModels/role.dart';

class Activities {
  Activities({
    this.customAttributes,
    this.annotations,
    this.startStation,
    this.endStation,
    this.startTime,
    this.endTime,
    this.startTimeOffset,
    this.endTimeOffset,
    this.duration,
    this.durationMinutes,
    this.isWholeDayActivity,
    this.fingerprint,
    this.mykey,
    this.base,
    this.duties,
    this.activities,
    this.openPositions,
    this.labels,
    this.area,
    this.blockTimeMinutes,
    this.dutyTime,
    this.dutyTimeMinutes,
    this.endOfLegalRest,
    this.endOfLegalRestOffset,
    this.isTraining,
    this.isPickupOnly,
    this.isCharter,
    this.isSplit,
    this.fleetType,
    this.advertisements,
    this.isReserveAssigned,
    this.patchStartTime,
    this.patchEndTime,
    this.type,
    required this.trainingTags,
    this.dutyId,
    this.activityCode,
    this.role,
    this.isStandby,
    this.isOffDuty,
    this.isOther,
  });

  final List<Dutie>? duties;
  final List<Activity>? activities;
  final List<dynamic>? openPositions;
  final List<dynamic>? advertisements;

  final List<dynamic>? customAttributes;
  final List<dynamic>? annotations;

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
  final MyKey? mykey;
  final Base? base;

  final Labels? labels;
  final String? area;
  final int? blockTimeMinutes;
  final int? dutyTime;
  final int? dutyTimeMinutes;
  final DateTime? endOfLegalRest;
  final int? endOfLegalRestOffset;
  final bool? isTraining;
  final bool? isPickupOnly;
  final bool? isCharter;
  final bool? isSplit;
  final String? fleetType;

  final bool? isReserveAssigned;
  final DateTime? patchStartTime;
  final DateTime? patchEndTime;
  final String? type;
  final List<dynamic> trainingTags;
  final int? dutyId;
  final ActivityCode? activityCode;
  final Role? role;
  final bool? isStandby;
  final bool? isOffDuty;
  final bool? isOther;

  Activities copyWith({
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
    MyKey? mykey,
    Base? base,
    List<Dutie>? duties,
    List<Activity>? activities,
    List<dynamic>? openPositions,
    Labels? labels,
    String? area,
    int? blockTimeMinutes,
    int? dutyTime,
    int? dutyTimeMinutes,
    DateTime? endOfLegalRest,
    int? endOfLegalRestOffset,
    bool? isTraining,
    bool? isPickupOnly,
    bool? isCharter,
    bool? isSplit,
    String? fleetType,
    List<dynamic>? advertisements,
    bool? isReserveAssigned,
    DateTime? patchStartTime,
    DateTime? patchEndTime,
    String? type,
    List<dynamic>? trainingTags,
    int? dutyId,
    ActivityCode? activityCode,
    Role? role,
    bool? isStandby,
    bool? isOffDuty,
    bool? isOther,
  }) {
    return Activities(
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
      mykey: mykey ?? this.mykey,
      base: base ?? this.base,
      duties: duties ?? this.duties,
      activities: activities ?? this.activities,
      openPositions: openPositions ?? this.openPositions,
      labels: labels ?? this.labels,
      area: area ?? this.area,
      blockTimeMinutes: blockTimeMinutes ?? this.blockTimeMinutes,
      dutyTime: dutyTime ?? this.dutyTime,
      dutyTimeMinutes: dutyTimeMinutes ?? this.dutyTimeMinutes,
      endOfLegalRest: endOfLegalRest ?? this.endOfLegalRest,
      endOfLegalRestOffset: endOfLegalRestOffset ?? this.endOfLegalRestOffset,
      isTraining: isTraining ?? this.isTraining,
      isPickupOnly: isPickupOnly ?? this.isPickupOnly,
      isCharter: isCharter ?? this.isCharter,
      isSplit: isSplit ?? this.isSplit,
      fleetType: fleetType ?? this.fleetType,
      advertisements: advertisements ?? this.advertisements,
      isReserveAssigned: isReserveAssigned ?? this.isReserveAssigned,
      patchStartTime: patchStartTime ?? this.patchStartTime,
      patchEndTime: patchEndTime ?? this.patchEndTime,
      type: type ?? this.type,
      trainingTags: trainingTags ?? this.trainingTags,
      dutyId: dutyId ?? this.dutyId,
      activityCode: activityCode ?? this.activityCode,
      role: role ?? this.role,
      isStandby: isStandby ?? this.isStandby,
      isOffDuty: isOffDuty ?? this.isOffDuty,
      isOther: isOther ?? this.isOther,
    );
  }

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
      customAttributes: json["customAttributes"] == null
          ? null
          : List<dynamic>.from(json["customAttributes"]!.map((x) => x)),
      annotations: json["annotations"] == null ? null : List<dynamic>.from(json["annotations"]!.map((x) => x)),
      startStation: json["startStation"],
      endStation: json["endStation"],
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      startTimeOffset: json["startTimeOffset"],
      endTimeOffset: json["endTimeOffset"],
      duration: json["duration"],
      durationMinutes: json["durationMinutes"],
      isWholeDayActivity: json["isWholeDayActivity"],
      fingerprint: json["fingerprint"],
      mykey: json["mykey"] == null ? null : MyKey.fromJson(json["mykey"]),
      base: json["base"] == null ? null : Base.fromJson(json["base"]),
      duties: json["duties"] == null ? null : List<Dutie>.from(json["duties"]!.map((x) => Dutie.fromJson(x))),
      activities: json["activities"] == null
          ? null
          : List<Activity>.from(json["activities"]!.map((x) => Activity.fromJson(x))),
      openPositions:
          json["openPositions"] == null ? null : List<dynamic>.from(json["openPositions"]!.map((x) => x)),
      labels: json["labels"] == null ? null : Labels.fromJson(json["labels"]),
      area: json["area"],
      blockTimeMinutes: json["blockTimeMinutes"],
      dutyTime: json["dutyTime"],
      dutyTimeMinutes: json["dutyTimeMinutes"],
      endOfLegalRest: DateTime.tryParse(json["endOfLegalRest"] ?? ""),
      endOfLegalRestOffset: json["endOfLegalRestOffset"],
      isTraining: json["isTraining"],
      isPickupOnly: json["isPickupOnly"],
      isCharter: json["isCharter"],
      isSplit: json["isSplit"],
      fleetType: json["fleetType"],
      advertisements:
          json["advertisements"] == null ? null : List<dynamic>.from(json["advertisements"]!.map((x) => x)),
      isReserveAssigned: json["isReserveAssigned"],
      patchStartTime: DateTime.tryParse(json["patchStartTime"] ?? ""),
      patchEndTime: DateTime.tryParse(json["patchEndTime"] ?? ""),
      type: json["type"],
      trainingTags: json["trainingTags"] == null ? [] : List<dynamic>.from(json["trainingTags"]!.map((x) => x)),
      dutyId: json["dutyId"],
      activityCode: json["activityCode"] == null ? null : ActivityCode.fromJson(json["activityCode"]),
      role: json["role"] == null ? null : Role.fromJson(json["role"]),
      isStandby: json["isStandby"],
      isOffDuty: json["isOffDuty"],
      isOther: json["isOther"],
    );
  }

  Map<String, dynamic> toJson() => {
        "customAttributes": customAttributes == null ? null : List<dynamic>.from(customAttributes!.map((x) => x)),
        "annotations": annotations == null ? null : List<dynamic>.from(annotations!.map((x) => x)),
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
        "mykey": mykey?.toJson(),
        "base": base?.toJson(),
        "duties": duties == null ? null : List<dynamic>.from(duties!.map((x) => x.toJson())),
        "activities": activities == null ? null : List<dynamic>.from(activities!.map((x) => x.toJson())),
        "openPositions": openPositions == null ? null : List<dynamic>.from(openPositions!.map((x) => x)),
        "labels": labels?.toJson(),
        "area": area,
        "blockTimeMinutes": blockTimeMinutes,
        "dutyTime": dutyTime,
        "dutyTimeMinutes": dutyTimeMinutes,
        "endOfLegalRest": endOfLegalRest?.toIso8601String(),
        "endOfLegalRestOffset": endOfLegalRestOffset,
        "isTraining": isTraining,
        "isPickupOnly": isPickupOnly,
        "isCharter": isCharter,
        "isSplit": isSplit,
        "fleetType": fleetType,
        "advertisements": advertisements == null ? null : List<dynamic>.from(advertisements!.map((x) => x)),
        "isReserveAssigned": isReserveAssigned,
        "patchStartTime": patchStartTime?.toIso8601String(),
        "patchEndTime": patchEndTime?.toIso8601String(),
        "type": type,
        "trainingTags": List<dynamic>.from(trainingTags.map((x) => x)),
        "dutyId": dutyId,
        "activityCode": activityCode?.toJson(),
        "role": role?.toJson(),
        "isStandby": isStandby,
        "isOffDuty": isOffDuty,
        "isOther": isOther,
      };
}

