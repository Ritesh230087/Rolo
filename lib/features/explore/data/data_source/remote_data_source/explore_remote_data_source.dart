import 'package:dio/dio.dart';
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/product/data/model/product_api_model.dart';

abstract class IExploreRemoteDataSource {
  Future<List<ProductApiModel>> getAllProducts();
}

class ExploreRemoteDataSource implements IExploreRemoteDataSource {
  final ApiService _apiService;
  ExploreRemoteDataSource(this._apiService);

  @override
  Future<List<ProductApiModel>> getAllProducts() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.allProducts);
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> productJsonList = response.data['data'];
        final List<ProductApiModel> products = productJsonList
            .map((json) => ProductApiModel.fromJson(json))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products from server.');
      }
    } on DioException catch (e) {
      throw Exception('Network error fetching products: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching products: $e');
    }
  }
}