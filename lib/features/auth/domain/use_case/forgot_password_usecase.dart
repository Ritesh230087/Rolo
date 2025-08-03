import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';

class ForgotPasswordUseCase implements UsecaseWithParams<void, String> {
  final IUserRepository _repository;
  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    return await _repository.sendPasswordResetLink(email);
  }
}