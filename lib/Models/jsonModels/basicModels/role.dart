class Role {
  Role({required this.id, required this.isPassive});

  final String? id;
  final bool? isPassive;

  Role copyWith({String? id, bool? isPassive}) {
    return Role(id: id ?? this.id, isPassive: isPassive ?? this.isPassive);
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(id: json["id"], isPassive: json["isPassive"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "isPassive": isPassive};

  @override
  String toString() {
    return "$id, $isPassive, ";
  }
}
