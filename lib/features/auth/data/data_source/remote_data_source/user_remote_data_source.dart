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

  // --- ADD THIS FULL FUNCTION ---
  // This is the implementation that makes the API call to your backend.
  @override
  Future<void> registerFCMToken(String token) async {
    try {
      // This calls the backend endpoint: POST /api/auth/register-fcm-token
      await _apiService.dio.post(
        ApiEndpoints.registerFCMToken,
        data: {'fcmToken': token}, // The backend expects this exact key: "fcmToken"
      );
      print("✅ FCM Token successfully sent to the backend.");
    } on DioException catch (e) {
      // It's okay if this fails. The app will try again on the next login.
      // We don't want to block the user's login flow if this fails.
      print("⚠️ Could not send FCM token to backend: ${e.message}");
      // We rethrow the exception so the repository can catch it, but we could also just return silently.
      throw Exception('Failed to register FCM token: ${e.message}');
    }
  }
  // ---------------------------
}