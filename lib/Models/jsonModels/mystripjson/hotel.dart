import '../basicModels/transport.dart';

class Hotel {
  Hotel({
    required this.id,
    required this.name,
    required this.email,
    required this.country,
    required this.transport,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? country;
  final Transport? transport;

  Hotel copyWith({String? id, String? name, String? email, String? country, Transport? transport}) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      country: country ?? this.country,
      transport: transport ?? this.transport,
    );
  }

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      country: json["country"],
      transport: json["transport"] == null ? null : Transport.fromJson(json["transport"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "country": country,
    "transport": transport?.toJson(),
  };

  @override
  String toString() {
    return "$id, $name, $email, $country, $transport, ";
  }
}
