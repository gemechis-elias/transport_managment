class User {
  String firstName;
  String lastName;
  String phone;
  DateTime date;
  String destination;
  String busNumber;
  int uniqueId;

  User({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.date,
    required this.destination,
    required this.busNumber,
    required this.uniqueId,
  });
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'date': date.toIso8601String(),
      'destination': destination,
      'busNumber': busNumber,
      'uniqueId': uniqueId,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      destination: json['destination'] ?? '',
      busNumber: json['busNumber'] ?? '',
      uniqueId: json['uniqueId'] ?? 0,
    );
  }
}
