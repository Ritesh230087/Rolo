// abstract class EditProfileEvent {}

// class EditProfileNameChanged extends EditProfileEvent {
//   final String fName;
//   final String lName;

//   EditProfileNameChanged({required this.fName, required this.lName});
// }

// class EditProfileSubmitted extends EditProfileEvent {
//   final String fName;
//   final String lName;

//   EditProfileSubmitted({required this.fName, required this.lName});
// }

// abstract class EditProfileState {}

// class EditProfileInitial extends EditProfileState {
//   final String fName;
//   final String lName;
//   final String email;

//   EditProfileInitial({required this.fName, required this.lName, required this.email});
// }

// class LoadInitialData extends EditProfileEvent {
//   final String fName;
//   final String lName;
//   final String email;

//   LoadInitialData({
//     required this.fName,
//     required this.lName,
//     required this.email,
//   });
// }


// class EditProfileLoading extends EditProfileState {}

// class EditProfileSuccess extends EditProfileState {}

// class EditProfileFailure extends EditProfileState {
//   final String message;

//   EditProfileFailure({required this.message});
// }





































import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
  @override
  List<Object> get props => [];
}

/// Event to load the initial user data into the view model's state.
class LoadInitialData extends EditProfileEvent {
  final String fName;
  final String lName;
  final String email;

  const LoadInitialData({
    required this.fName,
    required this.lName,
    required this.email,
  });

  @override
  List<Object> get props => [fName, lName, email];
}

/// Event triggered when the user submits the form to save changes.
class EditProfileSubmitted extends EditProfileEvent {
  final String fName;
  final String lName;

  const EditProfileSubmitted({required this.fName, required this.lName});

  @override
  List<Object> get props => [fName, lName];
}