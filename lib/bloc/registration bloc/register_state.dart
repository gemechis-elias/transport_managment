import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterUserInitial extends RegisterState {}

class RegisterUserLoading extends RegisterState {}

// class UserLoaded extends UserState {}

class RegisterUserError extends RegisterState {
  final String errorMessage;

  const RegisterUserError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}


class LoadedRegisterUserState extends RegisterState {
  final String name;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const LoadedRegisterUserState(this.name, this.phoneNumber, this.password, this.confirmPassword);

  @override
  List<Object> get props => [name , phoneNumber, password];
}
