import '../basicModels/detail.dart';

class Labels {
  Labels({required this.overview, required this.details});

  final List<Detail> overview;
  final List<Detail> details;

  Labels copyWith({List<Detail>? overview, List<Detail>? details}) {
    return Labels(overview: overview ?? this.overview, details: details ?? this.details);
  }

  factory Labels.fromJson(Map<String, dynamic> json) {
    return Labels(
      overview: json["overview"] == null
          ? []
          : List<Detail>.from(json["overview"]!.map((x) => Detail.fromJson(x))),
      details: json["details"] == null
          ? []
          : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "overview": overview.map((x) => x.toJson()).toList(),
    "details": details.map((x) => x.toJson()).toList(),
  };

  @override
  String toString() {
    return "$overview, $details, ";
  }
}
