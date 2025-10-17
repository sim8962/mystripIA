class MyKey {
  MyKey({required this.dor, required this.name, required this.role, required this.fingerprint});

  final String? dor;
  final String? name;
  final String? role;
  final String? fingerprint;

  MyKey copyWith({String? dor, String? name, String? role, String? fingerprint}) {
    return MyKey(
      dor: dor ?? this.dor,
      name: name ?? this.name,
      role: role ?? this.role,
      fingerprint: fingerprint ?? this.fingerprint,
    );
  }

  factory MyKey.fromJson(Map<String, dynamic> json) {
    return MyKey(dor: json["dor"], name: json["name"], role: json["role"], fingerprint: json["fingerprint"]);
  }

  Map<String, dynamic> toJson() => {"dor": dor, "name": name, "role": role, "fingerprint": fingerprint};

  @override
  String toString() {
    return "$dor, $name, $role, $fingerprint, ";
  }
}
