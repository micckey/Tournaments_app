class Tournament {
  final String id;
  final String name;
  final String organizers;
  final String location;
  final DateTime date;
  final String kata;
  final String kumite;
  final String both;

  Tournament({
    required this.id,
    required this.name,
    required this.organizers,
    required this.location,
    required this.date,
    required this.kata,
    required this.kumite,
    required this.both,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['ID'],
      name: json['Name'],
      organizers: json['Organizers'],
      location: json['Location'],
      date: DateTime.parse(json['Date']),
      kata: json['Kata_price'],
      kumite: json['Kumite_price'],
      both: json['Both_price'],
    );
  }
}
