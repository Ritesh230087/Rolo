abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {
  final String fName;
  final String lName;
  final String email;

  EditProfileInitial({required this.fName, required this.lName, required this.email});
}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileFailure extends EditProfileState {
  final String message;

  EditProfileFailure({required this.message});
}
