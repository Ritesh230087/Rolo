import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';

class ResetPasswordParams extends Equatable {
  final String token;
  final String password;
  const ResetPasswordParams({required this.token, required this.password});

  @override
  List<Object?> get props => [token, password];
}

class ResetPasswordUseCase implements UsecaseWithParams<void, ResetPasswordParams> {
  final IUserRepository _repository;
  ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await _repository.resetPassword(params.token, params.password);
  }
}