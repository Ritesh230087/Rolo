import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/profile/domain/repository/profile_repository.dart';

class LogoutUsecase implements UsecaseWithoutParams<Unit> {
  final IProfileRepository _repository;
  final GoogleSignIn _googleSignIn;

  LogoutUsecase(this._repository, this._googleSignIn);

  @override
  Future<Either<Failure, Unit>> call() async {
    try {
      await _googleSignIn.signOut();
      return await _repository.logout();
    } catch (e) {
      print("Error during Google SignOut: $e");
      return await _repository.logout();
    }
  }
}