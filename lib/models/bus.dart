class BusInfo {
  String plateNumber;
  int totalCapacity;
  int currentCapacity;
  String destination;

  BusInfo({
    required this.plateNumber,
    required this.totalCapacity,
    required this.currentCapacity,
    required this.destination,
  });

  Map<String, dynamic> toJson() {
    return {
      'busNumber': plateNumber,
      'totalCapacity': totalCapacity,
      'currentCapacity': currentCapacity,
      'destination': destination,
    };
  }

  factory BusInfo.fromJson(Map<String, dynamic> json) {
    return BusInfo(
      plateNumber: json['plateNumber'] ?? '',
      totalCapacity: json['totalCapacity'] ?? 0,
      currentCapacity: json['currentCapacity'] ?? 0,
      destination: json['destination'] ?? '',
    );
  }
}
