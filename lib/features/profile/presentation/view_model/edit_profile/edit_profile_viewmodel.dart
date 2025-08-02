// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/features/auth/domain/entity/user_entity.dart';
// import 'package:rolo/features/profile/domain/use_case/update_profile_usecase.dart';
// import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart';
// import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart' as state;

// class EditProfileViewModel extends Bloc<EditProfileEvent, state.EditProfileState> {
//   final UpdateProfileUseCase updateProfileUseCase;
//   final UserEntity currentUser;

//   EditProfileViewModel({
//     required this.updateProfileUseCase,
//     required this.currentUser,
//   }) : super(state.EditProfileInitial(
//           fName: currentUser.fName,
//           lName: currentUser.lName,
//           email: currentUser.email,
//         )) {
//     on<EditProfileNameChanged>((event, emit) {
//       emit(state.EditProfileInitial(
//         fName: event.fName,
//         lName: event.lName,
//         email: currentUser.email,
//       ));
//     });

//     on<LoadInitialData>((event, emit) {
//       emit(state.EditProfileInitial(
//         fName: event.fName,
//         lName: event.lName,
//         email: event.email,
//       ));
//     });

//     on<EditProfileSubmitted>((event, emit) async {
//       emit(state.EditProfileLoading());
//       final result = await updateProfileUseCase(
//         UpdateProfileParams(firstName: event.fName, lastName: event.lName),
//       );
//       result.fold(
//         (failure) => emit(state.EditProfileFailure(message: failure.message)),
//         (_) => emit(state.EditProfileSuccess()),
//       );
//     });
//   }

//   void loadInitialData({
//     required String fName,
//     required String lName,
//     required String email,
//   }) {
//     add(LoadInitialData(fName: fName, lName: lName, email: email));
//   }
// }

























import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/profile/domain/use_case/update_profile_usecase.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_state.dart';

class EditProfileViewModel extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final UserEntity currentUser;

  EditProfileViewModel({
    required this.updateProfileUseCase,
    required this.currentUser,
  }) : super(EditProfileInitial(
          // Uses the correct field names from your UserEntity
          fName: currentUser.fName,
          lName: currentUser.lName,
          email: currentUser.email,
        )) {
    on<LoadInitialData>(_onLoadInitialData);
    on<EditProfileSubmitted>(_onEditProfileSubmitted);
  }

  void _onLoadInitialData(LoadInitialData event, Emitter<EditProfileState> emit) {
    emit(EditProfileInitial(
      fName: event.fName,
      lName: event.lName,
      email: event.email,
    ));
  }

  Future<void> _onEditProfileSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    
    // The UpdateProfileParams expects `firstName` and `lastName`.
    // Here we correctly map from our event's `fName` and `lName`.
    final result = await updateProfileUseCase(
      UpdateProfileParams(firstName: event.fName, lastName: event.lName),
    );
    
    result.fold(
      (failure) => emit(EditProfileFailure(message: failure.message)),
      (_) => emit(EditProfileSuccess()),
    );
  }

  // Helper method to be called from the View's initState to load initial data.
  void loadInitialData() {
    add(LoadInitialData(
      fName: currentUser.fName,
      lName: currentUser.lName,
      email: currentUser.email,
    ));
  }
}