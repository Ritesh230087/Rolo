import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/profile/domain/use_case/update_profile_usecase.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart' as state;

class EditProfileViewModel extends Bloc<EditProfileEvent, state.EditProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final UserEntity currentUser;

  EditProfileViewModel({
    required this.updateProfileUseCase,
    required this.currentUser,
  }) : super(state.EditProfileInitial(
          fName: currentUser.fName,
          lName: currentUser.lName,
          email: currentUser.email,
        )) {
    on<EditProfileNameChanged>((event, emit) {
      emit(state.EditProfileInitial(
        fName: event.fName,
        lName: event.lName,
        email: currentUser.email,
      ));
    });

    on<LoadInitialData>((event, emit) {
      emit(state.EditProfileInitial(
        fName: event.fName,
        lName: event.lName,
        email: event.email,
      ));
    });

    on<EditProfileSubmitted>((event, emit) async {
      emit(state.EditProfileLoading());
      final result = await updateProfileUseCase(
        UpdateProfileParams(firstName: event.fName, lastName: event.lName),
      );
      result.fold(
        (failure) => emit(state.EditProfileFailure(message: failure.message)),
        (_) => emit(state.EditProfileSuccess()),
      );
    });
  }

  void loadInitialData({
    required String fName,
    required String lName,
    required String email,
  }) {
    add(LoadInitialData(fName: fName, lName: lName, email: email));
  }
}
