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
    emit(state.copyWith(status: ProfileStatus.loading));
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
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message));
      },
      (success) {
        emit(state.copyWith(
          status: ProfileStatus.success, 
          setProfileToNull: true, 
          didLogOut: true,        
        ));
      },
    );
  }
}