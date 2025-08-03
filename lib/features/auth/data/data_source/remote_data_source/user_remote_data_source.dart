import 'package:dio/dio.dart';
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/auth/data/data_source/user_data_source.dart';
import 'package:rolo/features/auth/data/model/user_api_model.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;
  UserRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception('Failed to login user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(
          'Failed to register user: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }
  @override
  Future<void> registerFCMToken(String token) async {
    try {
      await _apiService.dio.post(
        ApiEndpoints.registerFCMToken,
        data: {'fcmToken': token}, 
      );
      print("✅ FCM Token successfully sent to the backend.");
    } on DioException catch (e) {
      print("⚠️ Could not send FCM token to backend: ${e.message}");
      throw Exception('Failed to register FCM token: ${e.message}');
    }
  }


   @override
  Future<String> loginWithGoogle(String idToken) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.googleLogin,
        data: {'token': idToken},
      );
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception('Google login failed: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred during Google login.');
    }
  }
   @override
  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _apiService.dio.post(
        ApiEndpoints.sendResetLink,
        data: {'email': email},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    try {
      await _apiService.dio.post(
        ApiEndpoints.resetPassword(token),
        data: {'password': password},
      );
    } catch (e) {
      rethrow;
    }
  }
}