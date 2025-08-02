// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/features/home/domain/entity/home_entity.dart';
// import 'package:rolo/features/home/domain/use_case/get_home_data_usecase.dart';
// import 'package:rolo/features/home/presentation/view_model/home_event.dart';
// import 'package:rolo/features/home/presentation/view_model/home_state.dart';

// class HomeViewModel extends Bloc<HomeEvent, HomeState> {
//   final GetHomeDataUsecase _getHomeDataUsecase;

//   HomeEntity? _originalHomeData;

//   HomeViewModel(this._getHomeDataUsecase) : super(HomeInitial()) {
//     on<LoadHomeData>(_onLoadHomeData);
//     on<SearchHomeProducts>(_onSearchHomeProducts);
//   }

//   Future<void> _onLoadHomeData(
//     LoadHomeData event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(HomeLoading());
//     final result = await _getHomeDataUsecase();

//     result.fold(
//       (failure) => emit(HomeError(failure.message)),
//       (homeData) {
//         _originalHomeData = homeData;
//         emit(HomeLoaded(homeData));
//       },
//     );
//   }

//   void _onSearchHomeProducts(
//     SearchHomeProducts event,
//     Emitter<HomeState> emit,
//   ) {
//     if (_originalHomeData == null) return;

//     final query = event.query.toLowerCase().trim();
//     if (query.isEmpty) {
//       emit(HomeLoaded(_originalHomeData!));
//       return;
//     }
//     final filteredFeatured = _originalHomeData!.featuredProducts
//         .where((product) => product.name.toLowerCase().contains(query))
//         .toList();
//     final filteredSections = _originalHomeData!.ribbonSections.map((section) {
//       final filteredProducts = section.products
//           .where((product) => product.name.toLowerCase().contains(query))
//           .toList();
//       return section.copyWith(products: filteredProducts);
//     })
//     .where((section) => section.products.isNotEmpty)
//     .toList();

//     final filteredHomeData = HomeEntity(
//       categories: _originalHomeData!.categories, 
//       featuredProducts: filteredFeatured,
//       ribbonSections: filteredSections,
//     );
//     emit(HomeLoaded(filteredHomeData));
//   }
// }




































import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/domain/use_case/get_home_data_usecase.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_state.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUsecase _getHomeDataUsecase;

  // This remains private
  HomeEntity? _originalHomeData;

  // **THE FIX**: This public getter allows other files to safely access the data.
  HomeEntity? get originalHomeData => _originalHomeData;


  HomeViewModel(this._getHomeDataUsecase) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SearchHomeProducts>(_onSearchHomeProducts);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    if (event.isRefresh && _originalHomeData != null) {
      emit(HomeLoading(isFirstLoad: false, existingData: _originalHomeData));
    } else {
      emit(const HomeLoading(isFirstLoad: true));
    }

    final result = await _getHomeDataUsecase();

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (homeData) {
        _originalHomeData = homeData;
        emit(HomeLoaded(homeData));
      },
    );
  }

  void _onSearchHomeProducts(
    SearchHomeProducts event,
    Emitter<HomeState> emit,
  ) {
    if (_originalHomeData == null) return;

    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
       // When search is cleared, emit the search state with empty lists
      emit(const HomeSearchState(
        query: '',
        searchResults: [],
        recommendedProducts: [],
      ));
      return;
    }
    
    final allProducts = [
      ..._originalHomeData!.featuredProducts,
      ..._originalHomeData!.ribbonSections.expand((s) => s.products)
    ].toSet().toList(); // Use Set to remove duplicates

    final searchResults = allProducts
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();

    List<ProductEntity> recommendedProducts = [];
    if (searchResults.isNotEmpty) {
      final firstResult = searchResults.first;
      final parentSection = _originalHomeData!.ribbonSections.firstWhere(
        (s) => s.products.any((p) => p.id == firstResult.id),
        orElse: () => _originalHomeData!.ribbonSections.first,
      );
      
      recommendedProducts = parentSection.products
          .where((p) => p.id != firstResult.id && !p.name.toLowerCase().contains(query))
          .take(4)
          .toList();
    } else {
        // If no results, recommend some featured products
        recommendedProducts = _originalHomeData!.featuredProducts.take(4).toList();
    }

    emit(HomeSearchState(
      query: query,
      searchResults: searchResults,
      recommendedProducts: recommendedProducts,
    ));
  }
}