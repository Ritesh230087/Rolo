import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/app/shared_pref/token_shared_pref.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/profile/data/model/user_profile_api_model.dart';
import 'package:rolo/features/order/data/model/order_api_model.dart';
import 'package:rolo/features/order/data/model/shipping_address_api_model.dart';

class ProfileApiResponse {
  final UserProfileApiModel user;
  final List<OrderApiModel> orders;
  ProfileApiResponse({required this.user, required this.orders});
}

abstract class IProfileRemoteDataSource {
  Future<ProfileApiResponse> getUserProfile();
  Future<ShippingAddressApiModel?> getLastShippingAddress();
  Future<UserProfileApiModel> updateUserProfile({
    required String firstName,
    required String lastName,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;

  ProfileRemoteDataSource(this._apiService, this._tokenSharedPrefs);

  @override
  Future<ProfileApiResponse> getUserProfile() async {
    try {
      final token = (await _tokenSharedPrefs.getToken()).getOrElse(() => null);
      if (token == null) throw Exception('Auth Token not found.');

      final response = await _apiService.dio.get(
        ApiEndpoints.userProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final user = UserProfileApiModel.fromJson(response.data['user']);
      final orders = (response.data['orders'] as List)
          .map((orderJson) => OrderApiModel.fromJson(orderJson))
          .toList();

      return ProfileApiResponse(user: user, orders: orders);
    } catch (e) {
      throw Exception('Failed to fetch user profile data: $e');
    }
  }

  @override
  Future<ShippingAddressApiModel?> getLastShippingAddress() async {
    try {
      final tokenEither = await _tokenSharedPrefs.getToken();
      final token = tokenEither.getOrElse(() => null);
      if (token == null) throw Exception('Auth Token not found.');

      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final dynamic userIdValue = decodedToken['_id'];
      if (userIdValue == null || userIdValue is! String) {
        throw Exception("User ID ('_id') not found in JWT token.");
      }

      final String userId = userIdValue;
      final String url = ApiEndpoints.lastShippingAddress(userId);

      final response = await _apiService.dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ShippingAddressApiModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Network error fetching address: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching address: $e');
    }
  }

  @override
  Future<UserProfileApiModel> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final token = (await _tokenSharedPrefs.getToken()).getOrElse(() => null);
      if (token == null) throw Exception('Auth Token not found.');

      final response = await _apiService.dio.put(
        ApiEndpoints.userProfile,
        data: {'firstName': firstName, 'lastName': lastName},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return UserProfileApiModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = (await _tokenSharedPrefs.getToken()).getOrElse(() => null);
      if (token == null) throw Exception('Auth Token not found.');

      await _apiService.dio.put(
        ApiEndpoints.changePassword, 
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}

