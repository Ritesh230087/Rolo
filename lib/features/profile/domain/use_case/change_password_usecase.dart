import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/profile/domain/repository/profile_repository.dart';

class ChangePasswordUseCase {
  final IProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ChangePasswordParams params) {
    return repository.changePassword(
      oldPassword: params.currentPassword, 
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
