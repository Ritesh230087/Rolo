import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fName;
  final String lName;
  final String email;
  final String password;

  const UserEntity({
    this.userId,
    required this.fName,
    required this.lName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    userId,
    fName,
    lName,
    email,
    password,
  ];
}
