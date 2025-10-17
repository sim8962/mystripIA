class Transport {
    Transport({
        required this.id,
        required this.name,
        required this.email,
    });

    final String? id;
    final String? name;
    final String? email;

    Transport copyWith({
        String? id,
        String? name,
        String? email,
    }) {
        return Transport(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
        );
    }

    factory Transport.fromJson(Map<String, dynamic> json){ 
        return Transport(
            id: json["id"],
            name: json["name"],
            email: json["email"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
    };

    @override
    String toString(){
        return "$id, $name, $email, ";
    }
}
