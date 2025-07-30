import 'package:dio/dio.dart';
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/product/data/model/product_api_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<ProductApiModel> getProductById(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;
  ProductRemoteDataSourceImpl(this.apiService);

  @override
  Future<ProductApiModel> getProductById(String productId) async {
    try {
      final endpoint = ApiEndpoints.getProductById(productId);
      final response = await apiService.get(endpoint);
      final responseBody = response.data as Map<String, dynamic>;
      if (responseBody['success'] == true && responseBody['data'] != null) {
        return ProductApiModel.fromJson(responseBody['data']);
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to get product data.');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'An unknown network error occurred');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}