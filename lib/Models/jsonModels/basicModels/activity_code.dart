class ActivityCode {
    ActivityCode({
        required this.id,
        required this.group,
        required this.description,
    });

    final String? id;
    final String? group;
    final String? description;

    ActivityCode copyWith({
        String? id,
        String? group,
        String? description,
    }) {
        return ActivityCode(
            id: id ?? this.id,
            group: group ?? this.group,
            description: description ?? this.description,
        );
    }

    factory ActivityCode.fromJson(Map<String, dynamic> json){ 
        return ActivityCode(
            id: json["id"],
            group: json["group"],
            description: json["description"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "group": group,
        "description": description,
    };

    @override
    String toString(){
        return "$id, $group, $description, ";
    }
}
