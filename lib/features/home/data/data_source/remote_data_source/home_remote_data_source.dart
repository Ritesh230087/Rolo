import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/category/data/model/category_api_model.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/domain/entity/home_section_entity.dart';
import 'package:rolo/features/product/data/model/product_api_model.dart';
import 'package:rolo/features/ribbon/data/model/ribbon_api_model.dart';

abstract class IHomeRemoteDataSource {
  Future<HomeEntity> getHomeData();
}

class HomeRemoteDataSource implements IHomeRemoteDataSource {
  final ApiService _apiService;
  HomeRemoteDataSource(this._apiService);

  @override
  Future<HomeEntity> getHomeData() async {
    try {
      final responses = await Future.wait([
        _apiService.dio.get(ApiEndpoints.featuredProducts),
        _apiService.dio.get(ApiEndpoints.allProducts),
        _apiService.dio.get(ApiEndpoints.allRibbons),
        _apiService.dio.get(ApiEndpoints.allCategories),
      ]);

      final List<ProductApiModel> featuredProductModels =
          (responses[0].data['data'] as List).map((json) => ProductApiModel.fromJson(json)).toList();
      final List<ProductApiModel> allProductModels =
          (responses[1].data['data'] as List).map((json) => ProductApiModel.fromJson(json)).toList();
      final List<RibbonApiModel> ribbonModels =
          (responses[2].data['data'] as List).map((json) => RibbonApiModel.fromJson(json)).toList();
      final List<CategoryApiModel> categoryModels =
          (responses[3].data['data'] as List).map((json) => CategoryApiModel.fromJson(json)).toList();

      final List<HomeSectionEntity> ribbonSections = [];
      for (var ribbon in ribbonModels) {
        final productsForRibbon = allProductModels
            .where((product) => product.ribbonId == ribbon.id)
            .map((model) => model.toEntity())
            .toList();
        
        if (productsForRibbon.isNotEmpty) {
          ribbonSections.add(
            HomeSectionEntity(
              ribbon: ribbon.toEntity(),
              products: productsForRibbon,
            ),
          );
        }
      }

      return HomeEntity(
        categories: categoryModels.map((model) => model.toEntity()).toList(),
        featuredProducts: featuredProductModels.map((model) => model.toEntity()).toList(),
        ribbonSections: ribbonSections,
      );
    } catch (e) {
      throw Exception('Failed to load home data: $e');
    }
  }
}