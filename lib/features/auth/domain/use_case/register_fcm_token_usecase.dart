import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart'; 
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart'; 

class RegisterFCMTokenUseCase implements UsecaseWithParams<void, String> {
  final IUserRepository _repository;

  RegisterFCMTokenUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await _repository.registerFCMToken(params);
  }
}