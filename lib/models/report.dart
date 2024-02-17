class ReportModel {
  String name;
  int amount;
  String date;
  String plate;

  ReportModel({
    required this.name,
    required this.amount,
    required this.date,
    required this.plate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'date': date,
      'plate': plate,
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
      date: json['date'] ?? '',
      plate: json['plate'] ?? '',
    );
  }
}
