import 'package:equatable/equatable.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;
  
  final bool didLogOut;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.didLogOut = false, 
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    bool? didLogOut,
    bool setProfileToNull = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: setProfileToNull ? null : (profile ?? this.profile),
      errorMessage: errorMessage ?? this.errorMessage,
      didLogOut: didLogOut ?? this.didLogOut,
    );
  }
  
  @override
  List<Object?> get props => [status, profile, errorMessage, didLogOut];
}