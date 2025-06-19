import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String fname;
  final String lname;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
  });


  const RegisterUserParams.initial({
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    fname,
    lname,
    email,
    password,
  ];
}

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      fName: params.fname,
      lName: params.lname,
      email: params.email,
      password: params.password,
    );
    return _userRepository.registerUser(userEntity);
  }
}
