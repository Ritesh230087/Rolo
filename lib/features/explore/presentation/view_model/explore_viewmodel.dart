import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/category/domain/use_case/get_all_categories_usecase.dart';
import 'package:rolo/features/explore/domain/use_case/get_all_products_usecase.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_event.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_state.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class ExploreViewModel extends Bloc<ExploreEvent, ExploreState> {
  final GetAllProductsUsecase _getAllProductsUsecase;
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;

  ExploreViewModel({
    required GetAllProductsUsecase getAllProductsUsecase,
    required GetAllCategoriesUsecase getAllCategoriesUsecase,
  })  : _getAllProductsUsecase = getAllProductsUsecase,
        _getAllCategoriesUsecase = getAllCategoriesUsecase,
        super(const ExploreState()) {
    on<LoadExploreData>(_onLoadExploreData);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<CategoryFilterChanged>(_onCategoryFilterChanged);
    on<SortOrderChanged>(_onSortOrderChanged);
  }

  Future<void> _onLoadExploreData(
    LoadExploreData event,
    Emitter<ExploreState> emit,
  ) async {
    emit(state.copyWith(status: ExploreStatus.loading));

    final productsResult = await _getAllProductsUsecase();
    final categoriesResult = await _getAllCategoriesUsecase();

    productsResult.fold(
      (failure) => emit(state.copyWith(status: ExploreStatus.failure, errorMessage: failure.message)),
      (products) {
        categoriesResult.fold(
          (failure) => emit(state.copyWith(status: ExploreStatus.failure, errorMessage: failure.message)),
          (categories) {
            emit(state.copyWith(
              status: ExploreStatus.success,
              allProducts: products,
              filteredProducts: products,
              categories: categories,
            ));
          }
        );
      },
    );
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<ExploreState> emit) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFilters(emit);
  }

  void _onCategoryFilterChanged(CategoryFilterChanged event, Emitter<ExploreState> emit) {
    emit(state.copyWith(selectedCategoryId: event.categoryId, clearCategoryId: event.categoryId == null));
    _applyFilters(emit);
  }
  
  void _onSortOrderChanged(SortOrderChanged event, Emitter<ExploreState> emit) {
    emit(state.copyWith(sortOption: event.sortOption));
    _applyFilters(emit);
  }

  void _applyFilters(Emitter<ExploreState> emit) {
    List<ProductEntity> filteredList = List.from(state.allProducts);

    if (state.searchQuery.isNotEmpty) {
      filteredList = filteredList.where((product) {
        return product.name.toLowerCase().contains(state.searchQuery.toLowerCase());
      }).toList();
    }

    if (state.selectedCategoryId != null) {
      filteredList = filteredList.where((product) {
        return product.categoryId == state.selectedCategoryId;
      }).toList();
    }
    
    switch (state.sortOption) {
      case SortOption.priceLowToHigh:
        filteredList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        filteredList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.byDiscount:
        filteredList.sort((a, b) => (b.discountPercent ?? 0).compareTo(a.discountPercent ?? 0));
        break;
      case SortOption.none:
        break;
    }

    emit(state.copyWith(filteredProducts: filteredList));
  }
}