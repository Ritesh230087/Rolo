import 'package:equatable/equatable.dart';

enum SortOption { none, priceLowToHigh, priceHighToLow, byDiscount }

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object?> get props => [];
}

class LoadExploreData extends ExploreEvent {}

class SearchQueryChanged extends ExploreEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}

class CategoryFilterChanged extends ExploreEvent {
  final String? categoryId; 
  const CategoryFilterChanged(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class SortOrderChanged extends ExploreEvent {
  final SortOption sortOption;
  const SortOrderChanged(this.sortOption);
  @override
  List<Object> get props => [sortOption];
}