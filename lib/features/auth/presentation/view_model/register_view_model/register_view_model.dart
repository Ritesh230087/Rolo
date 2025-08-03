import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rolo/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUsecase _usecase;

  RegisterViewModel(this._usecase) : super(const RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    if (emit.isDone) return;
    emit(state.copyWith(isLoading: true));

    final result = await _usecase(RegisterUserParams(
      fname: event.fName,
      lname: event.lName,
      email: event.email,
      password: event.password,
    ));

    if (emit.isDone) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
        emit(state.copyWith(isLoading: false, isSuccess: false));
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }
}