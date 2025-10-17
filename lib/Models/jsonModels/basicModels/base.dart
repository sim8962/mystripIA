class Base {
  Base({required this.stations, required this.id});

  final List<String> stations;
  final String? id;

  Base copyWith({List<String>? stations, String? id}) {
    return Base(stations: stations ?? this.stations, id: id ?? this.id);
  }

  factory Base.fromJson(Map<String, dynamic> json) {
    return Base(
      stations: json["stations"] == null ? [] : List<String>.from(json["stations"]!.map((x) => x)),
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {"stations": stations.map((x) => x).toList(), "id": id};

  @override
  String toString() {
    return "$stations, $id, ";
  }
}
