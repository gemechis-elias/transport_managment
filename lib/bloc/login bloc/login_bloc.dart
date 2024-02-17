import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_app/bloc/login%20bloc/login_event.dart';
import 'package:transport_app/bloc/login%20bloc/login_state.dart';
import 'package:transport_app/services/loginService.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserState initialState) : super(UserInitial()) {
    final userService = UserLogin();

    on<LoginUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        print('========> inside try bloc');
        final response = await userService.login(event.phone, event.password);
        print('response: $response');
        
        if (response) {
          emit(LoadedUserState(event.phone, event.password));
        } else {
          emit(const UserError('Error when registering user'));
        }
      } catch (e) {
        emit(const UserError('Error LOGGING in'));
      }
    });
  }
}
