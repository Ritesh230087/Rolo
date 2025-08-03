import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_event.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_state.dart';

class ForgotPasswordViewModel extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase) : super(const ForgotPasswordState()) {
    on<SendResetLink>(_onSendResetLink);
  }

  Future<void> _onSendResetLink(SendResetLink event, Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    final result = await _forgotPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: ForgotPasswordStatus.success)),
    );
  }
}