import 'package:rolo/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource{
   Future<void> registerUser(UserEntity user);

  Future<String> loginUser(String email,String password);

  Future<void> registerFCMToken(String token);
}


