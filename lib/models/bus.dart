class BusInfo {
  String busNumber;
  int totalCapacity;
  int currentCapacity;
  String destination;

  BusInfo({
    required this.busNumber,
    required this.totalCapacity,
    required this.currentCapacity,
    required this.destination,
  });

  Map<String, dynamic> toJson() {
    return {
      'busNumber': busNumber,
      'totalCapacity': totalCapacity,
      'currentCapacity': currentCapacity,
      'destination': destination,
    };
  }

  factory BusInfo.fromJson(Map<String, dynamic> json) {
    return BusInfo(
      busNumber: json['busNumber'] ?? '',
      totalCapacity: json['totalCapacity'] ?? 0,
      currentCapacity: json['currentCapacity'] ?? 0,
      destination: json['destination'] ?? '',
    );
  }
}
