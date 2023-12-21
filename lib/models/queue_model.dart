class Queue {
  String plateNumber;
  String order;
  String date;
  String time;

  Queue({
    required this.plateNumber,
    required this.order,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'plateNumber': plateNumber,
      'order': order,
      'date': date,
      'time': time,
    };
  }

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      plateNumber: json['plateNumber'] ?? '',
      order: json['order'] ?? 0,
      date: json['date'] ?? 0,
      time: json['time'] ?? '',
    );
  }
}
