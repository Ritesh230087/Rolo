// import 'package:equatable/equatable.dart';

// abstract class ProfileEvent extends Equatable {
//   const ProfileEvent();
//   @override
//   List<Object> get props => [];
// }
// class LoadProfile extends ProfileEvent {}
// class Logout extends ProfileEvent {
//   const Logout();
// }




import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

/// Event to fetch the user's profile data.
/// [isRefresh] is true when triggered by pull-to-refresh or auto-reconnect.
class LoadProfile extends ProfileEvent {
  final bool isRefresh;
  const LoadProfile({this.isRefresh = false});
}

/// Event to log the user out.
class Logout extends ProfileEvent {
  const Logout();
}