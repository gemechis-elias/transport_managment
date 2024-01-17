class Vehicle {
  String plateNumber;
  int totalCapacity;

  Vehicle({
    required this.plateNumber,
    required this.totalCapacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'busNumber': plateNumber,
      'totalCapacity': totalCapacity,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      plateNumber: json['plateNumber'] ?? '',
      totalCapacity: json['totalCapacity'] ?? 0,
    );
  }
}
