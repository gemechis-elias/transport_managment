class DataModel {
  String id;
  String vehicle_list;
  String departure;
  String destination;
  String tariff;
  String user_id;
  String created_at;
  String updated_at;

  DataModel({
    required this.id,
    required this.vehicle_list,
    required this.departure,
    required this.destination,
    required this.tariff,
    required this.user_id,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_list': vehicle_list,
      'departure': departure,
      'destination': destination,
      'tariff': tariff,
      'user_id': user_id,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'] ?? '',
      vehicle_list: json['vehicle_list'] ?? 0,
      departure: json['departure'] ?? 0,
      destination: json['destination'] ?? '',
      tariff: json['tariff'] ?? '',
      user_id: json['user_id'] ?? 0,
      created_at: json['created_at'] ?? 0,
      updated_at: json['updated_at'] ?? '',
    );
  }
}
