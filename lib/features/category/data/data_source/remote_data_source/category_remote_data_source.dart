import 'package:dio/dio.dart';
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/category/data/model/category_api_model.dart';

abstract class ICategoryRemoteDataSource {
  Future<List<CategoryApiModel>> getAllCategories();
}

class CategoryRemoteDataSource implements ICategoryRemoteDataSource {
  final ApiService _apiService;
  CategoryRemoteDataSource(this._apiService);

  @override
  Future<List<CategoryApiModel>> getAllCategories() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.allCategories);
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> categoryJsonList = response.data['data'];
        final List<CategoryApiModel> categories = categoryJsonList
            .map((json) => CategoryApiModel.fromJson(json))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories from server.');
      }
    } on DioException catch (e) {
      throw Exception('Network error fetching categories: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching categories: $e');
    }
  }
}