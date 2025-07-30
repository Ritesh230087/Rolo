import 'package:equatable/equatable.dart';
import 'package:rolo/features/category/domain/entity/category_entity.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_event.dart';

enum ExploreStatus { initial, loading, success, failure }

class ExploreState extends Equatable {
  final ExploreStatus status;
  final List<CategoryEntity> categories;
  final List<ProductEntity> allProducts; 
  final List<ProductEntity> filteredProducts; 
  final String errorMessage;

  final String searchQuery;
  final String? selectedCategoryId;
  final SortOption sortOption;

  const ExploreState({
    this.status = ExploreStatus.initial,
    this.categories = const [],
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.errorMessage = '',
    this.searchQuery = '',
    this.selectedCategoryId,
    this.sortOption = SortOption.none,
  });

  ExploreState copyWith({
    ExploreStatus? status,
    List<CategoryEntity>? categories,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategoryId,
    bool clearCategoryId = false,
    SortOption? sortOption,
  }) {
    return ExploreState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: clearCategoryId ? null : selectedCategoryId ?? this.selectedCategoryId,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        allProducts,
        filteredProducts,
        errorMessage,
        searchQuery,
        selectedCategoryId,
        sortOption,
      ];
}