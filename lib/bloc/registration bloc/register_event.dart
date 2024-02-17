import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegisterEvent {
  final String name;
  final String phone;
  final String password;
  final String confirmPassword;

  const RegisterUserEvent({
    required this.name,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}
