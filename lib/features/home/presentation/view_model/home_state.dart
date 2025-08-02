// import 'package:equatable/equatable.dart';
// import 'package:rolo/features/home/domain/entity/home_entity.dart';

// abstract class HomeState extends Equatable {
//   const HomeState();
//   @override
//   List<Object?> get props => [];
// }

// class HomeInitial extends HomeState {}
// class HomeLoading extends HomeState {}
// class HomeLoaded extends HomeState {
//   final HomeEntity homeData;
//   const HomeLoaded(this.homeData);
//   @override
//   List<Object?> get props => [homeData];
// }
// class HomeError extends HomeState {
//   final String message;
//   const HomeError(this.message);
//   @override
//   List<Object?> get props => [message];
// }


























import 'package:equatable/equatable.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart'; // Import ProductEntity

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final bool isFirstLoad;
  final HomeEntity? existingData;
  const HomeLoading({required this.isFirstLoad, this.existingData});
  @override
  List<Object?> get props => [isFirstLoad, existingData];
}

class HomeLoaded extends HomeState {
  final HomeEntity homeData;
  const HomeLoaded(this.homeData);
  @override
  List<Object?> get props => [homeData];
}

// NEW STATE for Search UI
class HomeSearchState extends HomeState {
  final String query;
  final List<ProductEntity> searchResults;
  final List<ProductEntity> recommendedProducts;

  const HomeSearchState({
    required this.query,
    required this.searchResults,
    required this.recommendedProducts,
  });

  @override
  List<Object?> get props => [query, searchResults, recommendedProducts];
}


class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}