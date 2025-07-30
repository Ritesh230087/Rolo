abstract class EditProfileEvent {}

class EditProfileNameChanged extends EditProfileEvent {
  final String fName;
  final String lName;

  EditProfileNameChanged({required this.fName, required this.lName});
}

class EditProfileSubmitted extends EditProfileEvent {
  final String fName;
  final String lName;

  EditProfileSubmitted({required this.fName, required this.lName});
}

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {
  final String fName;
  final String lName;
  final String email;

  EditProfileInitial({required this.fName, required this.lName, required this.email});
}

class LoadInitialData extends EditProfileEvent {
  final String fName;
  final String lName;
  final String email;

  LoadInitialData({
    required this.fName,
    required this.lName,
    required this.email,
  });
}


class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileFailure extends EditProfileState {
  final String message;

  EditProfileFailure({required this.message});
}