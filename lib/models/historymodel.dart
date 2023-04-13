class History {
  final String id;
  final String karatekaID;
  final String tournamentID;
  final String category;
  final String championship;

  History({
    required this.id,
    required this.karatekaID,
    required this.tournamentID,
    required this.category,
    required this.championship,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['ID'],
      karatekaID: json['Karateka_ID'],
      tournamentID: json['Tournament_ID'],
      category: json['Category'],
      championship: json['Championship'],
    );
  }
}
