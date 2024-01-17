class UserModel {
  String name;
  String phone;
  String password;
  String password_confirmation;

  UserModel({
    required this.name,
    required this.phone,
    required this.password,
    required this.password_confirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': password_confirmation,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? 0,
      password: json['password'] ?? 0,
      password_confirmation: json['password_confirmation'] ?? '',
    );
  }
}
