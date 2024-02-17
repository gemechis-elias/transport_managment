import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

// class UserLoaded extends UserState {}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}


class LoadedUserState extends UserState {
  final String phoneNumber;
  final String password;

  const LoadedUserState(this.phoneNumber, this.password);

  @override
  List<Object> get props => [phoneNumber, password];
}
