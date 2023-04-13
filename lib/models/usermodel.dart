class Karateka {
  final String id;
  final String username;
  final String fullname;
  final String email;
  late String club;
  late String rank;

  Karateka({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.club,
    required this.rank,
  });

  factory Karateka.fromJson(Map<String, dynamic> json) {
    return Karateka(
      id: json['ID'],
      username: json['Username'],
      fullname: json['Full_name'],
      email: json['Email'],
      club: json['Club'],
      rank: json['Rank'],
    );
  }
}
