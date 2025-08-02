// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:rolo/features/profile/domain/use_case/get_user_profile_usecase.dart';
// // import 'package:rolo/features/profile/domain/use_case/logout_usecase.dart';
// // import 'package:rolo/features/profile/presentation/view_model/profile_event.dart';
// // import 'package:rolo/features/profile/presentation/view_model/profile_state.dart';

// // class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
// //   final GetProfileUsecase _getProfileUsecase;
// //   final LogoutUsecase _logoutUsecase;

// //   ProfileViewModel({
// //     required GetProfileUsecase getProfileUsecase,
// //     required LogoutUsecase logoutUsecase,
// //   })  : _getProfileUsecase = getProfileUsecase,
// //         _logoutUsecase = logoutUsecase,
// //         super(const ProfileState()) {
// //     on<LoadProfile>(_onLoadProfile);
// //     on<Logout>(_onLogout);
// //   }

// //   Future<void> _onLoadProfile(
// //     LoadProfile event,
// //     Emitter<ProfileState> emit,
// //   ) async {
// //     emit(state.copyWith(status: ProfileStatus.loading));
// //     final result = await _getProfileUsecase();
// //     result.fold(
// //       (failure) => emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message)),
// //       (profile) => emit(state.copyWith(status: ProfileStatus.success, profile: profile)),
// //     );
// //   }
// //   Future<void> _onLogout(
// //     Logout event,
// //     Emitter<ProfileState> emit,
// //   ) async {
// //     emit(state.copyWith(status: ProfileStatus.loading));
// //     final result = await _logoutUsecase();
// //     result.fold(
// //       (failure) {
// //         emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message));
// //       },
// //       (success) {
// //         emit(state.copyWith(
// //           status: ProfileStatus.success, 
// //           setProfileToNull: true, 
// //           didLogOut: true,        
// //         ));
// //       },
// //     );
// //   }
// // }
















































// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/features/profile/domain/use_case/get_user_profile_usecase.dart';
// import 'package:rolo/features/profile/domain/use_case/logout_usecase.dart';
// import 'package:rolo/features/profile/presentation/view_model/profile_event.dart';
// import 'package:rolo/features/profile/presentation/view_model/profile_state.dart';

// class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
//   final GetProfileUsecase _getProfileUsecase;
//   final LogoutUsecase _logoutUsecase;

//   ProfileViewModel({
//     required GetProfileUsecase getProfileUsecase,
//     required LogoutUsecase logoutUsecase,
//   })  : _getProfileUsecase = getProfileUsecase,
//         _logoutUsecase = logoutUsecase,
//         super(const ProfileState()) {
//     on<LoadProfile>(_onLoadProfile);
//     on<Logout>(_onLogout);
//   }

//   Future<void> _onLoadProfile(
//     LoadProfile event,
//     Emitter<ProfileState> emit,
//   ) async {
//     // If it's a refresh and we have old data, keep it while loading
//     if (event.isRefresh && state.profile != null) {
//        emit(state.copyWith(status: ProfileStatus.loading));
//     } else {
//        emit(state.copyWith(status: ProfileStatus.loading, setProfileToNull: true));
//     }

//     final result = await _getProfileUsecase();
//     result.fold(
//       (failure) => emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message)),
//       (profile) => emit(state.copyWith(status: ProfileStatus.success, profile: profile)),
//     );
//   }
  
//   Future<void> _onLogout(
//     Logout event,
//     Emitter<ProfileState> emit,
//   ) async {
//     emit(state.copyWith(status: ProfileStatus.loading));
//     final result = await _logoutUsecase();
//     result.fold(
//       (failure) {
//         emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message));
//       },
//       (success) {
//         emit(state.copyWith(
//           status: ProfileStatus.success, 
//           setProfileToNull: true, 
//           didLogOut: true,        
//         ));
//       },
//     );
//   }
// }





















































import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:rolo/features/profile/domain/use_case/logout_usecase.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_event.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase _getProfileUsecase;
  final LogoutUsecase _logoutUsecase;

  ProfileViewModel({
    required GetProfileUsecase getProfileUsecase,
    required LogoutUsecase logoutUsecase,
  })  : _getProfileUsecase = getProfileUsecase,
        _logoutUsecase = logoutUsecase,
        super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<Logout>(_onLogout);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // If it's a background refresh and we already have data,
    // we don't need to show a full-screen loader, just keep the content.
    if (event.isRefresh && state.profile != null) {
       emit(state.copyWith(status: ProfileStatus.loading));
    } else {
       // For the initial load, clear any old data and show the loading state.
       emit(state.copyWith(status: ProfileStatus.loading, setProfileToNull: true));
    }

    final result = await _getProfileUsecase();

    result.fold(
      (failure) => emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message)),
      (profile) => emit(state.copyWith(status: ProfileStatus.success, profile: profile)),
    );
  }

  Future<void> _onLogout(
    Logout event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _logoutUsecase();
    result.fold(
      (failure) {
        // If logout fails, go back to the success state with an error message
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message));
      },
      (success) {
        // On successful logout, clear all profile data and set the logout flag
        emit(state.copyWith(
          status: ProfileStatus.success, 
          setProfileToNull: true, 
          didLogOut: true,        
        ));
      },
    );
  }
}