
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_app/bloc/registration%20bloc/register_event.dart';
import 'package:transport_app/bloc/registration%20bloc/register_state.dart';
import 'package:transport_app/models/user.dart';
import 'package:transport_app/services/registrationService.dart';

class UserRgistrationBloc extends Bloc<RegisterUserEvent, RegisterState> {
  UserRgistrationBloc(RegisterState initialState) : super(RegisterUserInitial()) {
    final userService = UserRegistration();

    on<RegisterUserEvent>((event, emit) async {
      emit(RegisterUserLoading());
      try {
        final response = await userService.register(
          UserModel(
                name: event.name,
                phone: event.phone,
                password: event.password,
                password_confirmation: event.confirmPassword,
              ),
          );
        if (response != null) {
          emit(LoadedRegisterUserState(event.name,event.phone, event.password, event.confirmPassword));
        } else {
          emit(const RegisterUserError('Error when registering user'));
        }
      } catch (e) {
        emit(const RegisterUserError('Error logging in'));
      }
    });
  }
}
