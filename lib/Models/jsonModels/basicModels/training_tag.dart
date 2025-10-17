class TrainingTag {
  TrainingTag({required this.crewIds, required this.id, required this.descr});

  final List<String> crewIds;
  final String? id;
  final String? descr;

  TrainingTag copyWith({List<String>? crewIds, String? id, String? descr}) {
    return TrainingTag(crewIds: crewIds ?? this.crewIds, id: id ?? this.id, descr: descr ?? this.descr);
  }

  factory TrainingTag.fromJson(Map<String, dynamic> json) {
    return TrainingTag(
      crewIds: json["crewIds"] == null ? [] : List<String>.from(json["crewIds"]!.map((x) => x)),
      id: json["id"],
      descr: json["descr"],
    );
  }

  Map<String, dynamic> toJson() => {"crewIds": crewIds.map((x) => x).toList(), "id": id, "descr": descr};

  @override
  String toString() {
    return "$crewIds, $id, $descr, ";
  }
}
