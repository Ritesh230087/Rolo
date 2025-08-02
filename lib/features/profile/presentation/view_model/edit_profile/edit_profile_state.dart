// abstract class EditProfileState {}

// class EditProfileInitial extends EditProfileState {
//   final String fName;
//   final String lName;
//   final String email;

//   EditProfileInitial({required this.fName, required this.lName, required this.email});
// }

// class EditProfileLoading extends EditProfileState {}

// class EditProfileSuccess extends EditProfileState {}

// class EditProfileFailure extends EditProfileState {
//   final String message;

//   EditProfileFailure({required this.message});
// }

















import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();
  @override
  List<Object> get props => [];
}

/// Initial state holding the user's data to be displayed in the form.
class EditProfileInitial extends EditProfileState {
  final String fName;
  final String lName;
  final String email;

  const EditProfileInitial({required this.fName, required this.lName, required this.email});

  @override
  List<Object> get props => [fName, lName, email];
}

/// State to show a loading indicator while the profile is being updated.
class EditProfileLoading extends EditProfileState {}

/// State to signify that the profile was updated successfully.
class EditProfileSuccess extends EditProfileState {}

/// State to show an error message if the update fails.
class EditProfileFailure extends EditProfileState {
  final String message;

  const EditProfileFailure({required this.message});

  @override
  List<Object> get props => [message];
}