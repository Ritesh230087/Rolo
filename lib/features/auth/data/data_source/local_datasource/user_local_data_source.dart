import 'package:rolo/core/network/hive_service.dart';
import 'package:rolo/features/auth/data/data_source/user_data_source.dart';
import 'package:rolo/features/auth/data/model/user_hive_model.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final userData = await _hiveService.login(email, password);
      if (userData != null && userData.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<void> registerFCMToken(String token) async {
    return;
  }

  @override
  Future<String> loginWithGoogle(String idToken) {
    throw Exception("Google Sign-In is not supported in offline mode.");
  }

  @override
  Future<void> sendPasswordResetLink(String email) {
    throw Exception("Forgot Password is not supported in offline mode.");
  }

  @override
  Future<void> resetPassword(String token, String password) {
    throw Exception("Password Reset is not supported in offline mode.");
  }
}