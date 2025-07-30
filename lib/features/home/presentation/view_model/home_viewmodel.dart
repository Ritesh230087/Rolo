import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/domain/use_case/get_home_data_usecase.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUsecase _getHomeDataUsecase;

  HomeEntity? _originalHomeData;

  HomeViewModel(this._getHomeDataUsecase) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SearchHomeProducts>(_onSearchHomeProducts);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
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
      emit(HomeLoaded(_originalHomeData!));
      return;
    }
    final filteredFeatured = _originalHomeData!.featuredProducts
        .where((product) => product.name.toLowerCase().contains(query))
        .toList();
    final filteredSections = _originalHomeData!.ribbonSections.map((section) {
      final filteredProducts = section.products
          .where((product) => product.name.toLowerCase().contains(query))
          .toList();
      return section.copyWith(products: filteredProducts);
    })
    .where((section) => section.products.isNotEmpty)
    .toList();

    final filteredHomeData = HomeEntity(
      categories: _originalHomeData!.categories, 
      featuredProducts: filteredFeatured,
      ribbonSections: filteredSections,
    );
    emit(HomeLoaded(filteredHomeData));
  }
}