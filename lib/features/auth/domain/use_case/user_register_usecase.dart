import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart'; 

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

  @override
  List<Object?> get props => [fname, lname, email, password];
}

class UserRegisterUsecase implements UsecaseWithParams<String, RegisterUserParams> {
  final IUserRepository _userRepository;
  final UserLoginUsecase _userLoginUsecase; 

  UserRegisterUsecase({
    required IUserRepository userRepository,
    required UserLoginUsecase userLoginUsecase,
  })  : _userRepository = userRepository,
        _userLoginUsecase = userLoginUsecase;

  @override
  Future<Either<Failure, String>> call(RegisterUserParams params) async {
    final userEntity = UserEntity(
      fName: params.fname,
      lName: params.lname,
      email: params.email,
      password: params.password,
    );
    final registrationResult = await _userRepository.registerUser(userEntity);
    return await registrationResult.fold(
      (failure) {
        return Left(failure);
      },
      (_) async {
        return await _userLoginUsecase(
          LoginParams(email: params.email, password: params.password),
        );
      },
    );
  }
}