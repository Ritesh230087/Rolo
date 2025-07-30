import 'package:dartz/dartz.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;
  static const String _tokenKey = 'auth_token';

  TokenSharedPrefs({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  Future<Either<Failure, Unit>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString(_tokenKey, token);
      return const Right(unit);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: 'Failed to save token: $e'));
    }
  }

  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString(_tokenKey);
      return Right(token);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: 'Failed to retrieve token: $e'));
    }
  }

  Future<Either<Failure, Unit>> deleteToken() async {
    try {
      await _sharedPreferences.remove(_tokenKey);
      return const Right(unit);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: 'Failed to delete token: $e'));
    }
  }
}