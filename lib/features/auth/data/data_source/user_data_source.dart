import 'package:rolo/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource{
   Future<void> registerUser(UserEntity user);

  Future<String> loginUser(String email,String password);

  Future<void> registerFCMToken(String token);
  Future<String> loginWithGoogle(String idToken);
  Future<void> sendPasswordResetLink(String email);
  Future<void> resetPassword(String token, String password);
}