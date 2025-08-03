import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';

class LoginWithGoogleUseCase implements UsecaseWithParams<String, String> {
  final IUserRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String googleIdToken) async {
    return await _repository.loginWithGoogle(googleIdToken);
  }
}