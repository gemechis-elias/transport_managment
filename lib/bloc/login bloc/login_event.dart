import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoginUserEvent extends UserEvent {
  final String phone;
  final String password;

  const LoginUserEvent({
    required this.phone,
    required this.password,
  });
}
