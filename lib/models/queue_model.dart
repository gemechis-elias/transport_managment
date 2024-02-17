class QueueModel {
  String plateNumber;
  String date;
  String time;

  QueueModel({
    required this.plateNumber,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'plateNumber': plateNumber,
      'date': date,
      'time': time,
    };
  }

  factory QueueModel.fromJson(Map<String, dynamic> json) {
    return QueueModel(
      plateNumber: json['plateNumber'] ?? '',
      date: json['date'].toString(),
      time: json['time'] ?? '',
    );
  }
}
