import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/reset_password/reset_password_event.dart';
import 'package:rolo/features/auth/presentation/view_model/reset_password/reset_password_state.dart';

class ResetPasswordViewModel extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordViewModel(this._resetPasswordUseCase) : super(const ResetPasswordState()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    final params = ResetPasswordParams(token: event.token, password: event.password);
    final result = await _resetPasswordUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: ResetPasswordStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: ResetPasswordStatus.success)),
    );
  }
}