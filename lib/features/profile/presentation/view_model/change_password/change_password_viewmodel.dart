import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/profile/domain/use_case/change_password_usecase.dart';
import 'package:rolo/features/profile/presentation/view_model/change_password/change_password_event.dart';
import 'package:rolo/features/profile/presentation/view_model/change_password/change_password_state.dart';

class ChangePasswordViewModel extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordViewModel(this.changePasswordUseCase) : super(ChangePasswordInitial()) {
    on<SubmitChangePasswordEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitChangePasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoading());

    final result = await changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(ChangePasswordFailure(failure.message)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
}
