class AssignedCrew {
    AssignedCrew({
        required this.crewId,
        required this.surname,
        required this.givenNames,
        required this.position,
        required this.seniority,
        required this.base,
        required this.isOnIdenticalTrip,
    });

    final String? crewId;
    final String? surname;
    final String? givenNames;
    final String? position;
    final String? seniority;
    final String? base;
    final bool? isOnIdenticalTrip;

    AssignedCrew copyWith({
        String? crewId,
        String? surname,
        String? givenNames,
        String? position,
        String? seniority,
        String? base,
        bool? isOnIdenticalTrip,
    }) {
        return AssignedCrew(
            crewId: crewId ?? this.crewId,
            surname: surname ?? this.surname,
            givenNames: givenNames ?? this.givenNames,
            position: position ?? this.position,
            seniority: seniority ?? this.seniority,
            base: base ?? this.base,
            isOnIdenticalTrip: isOnIdenticalTrip ?? this.isOnIdenticalTrip,
        );
    }

    factory AssignedCrew.fromJson(Map<String, dynamic> json){ 
        return AssignedCrew(
            crewId: json["crewId"],
            surname: json["surname"],
            givenNames: json["givenNames"],
            position: json["position"],
            seniority: json["seniority"],
            base: json["base"],
            isOnIdenticalTrip: json["isOnIdenticalTrip"],
        );
    }

    Map<String, dynamic> toJson() => {
        "crewId": crewId,
        "surname": surname,
        "givenNames": givenNames,
        "position": position,
        "seniority": seniority,
        "base": base,
        "isOnIdenticalTrip": isOnIdenticalTrip,
    };

    @override
    String toString(){
        return "$crewId, $surname, $givenNames, $position, $seniority, $base, $isOnIdenticalTrip, ";
    }
}
