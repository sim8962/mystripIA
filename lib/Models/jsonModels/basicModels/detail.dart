class Detail {
    Detail({
        required this.name,
        required this.value,
    });

    final String? name;
    final String? value;

    Detail copyWith({
        String? name,
        String? value,
    }) {
        return Detail(
            name: name ?? this.name,
            value: value ?? this.value,
        );
    }

    factory Detail.fromJson(Map<String, dynamic> json){ 
        return Detail(
            name: json["name"],
            value: json["value"],
        );
    }

    Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
    };

    @override
    String toString(){
        return "$name, $value, ";
    }
}
