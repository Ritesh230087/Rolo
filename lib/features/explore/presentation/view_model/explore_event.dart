// import 'package:equatable/equatable.dart';

// enum SortOption { none, priceLowToHigh, priceHighToLow, byDiscount }

// abstract class ExploreEvent extends Equatable {
//   const ExploreEvent();
//   @override
//   List<Object?> get props => [];
// }

// class LoadExploreData extends ExploreEvent {}

// class SearchQueryChanged extends ExploreEvent {
//   final String query;
//   const SearchQueryChanged(this.query);
//   @override
//   List<Object> get props => [query];
// }

// class CategoryFilterChanged extends ExploreEvent {
//   final String? categoryId; 
//   const CategoryFilterChanged(this.categoryId);
//   @override
//   List<Object?> get props => [categoryId];
// }

// class SortOrderChanged extends ExploreEvent {
//   final SortOption sortOption;
//   const SortOrderChanged(this.sortOption);
//   @override
//   List<Object> get props => [sortOption];
// }



























import 'package:equatable/equatable.dart';

// Enum to define the available sorting options
enum SortOption { none, priceLowToHigh, priceHighToLow, byDiscount }

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object?> get props => [];
}

/// Event to fetch all initial data for the Explore page.
/// [isRefresh] is true when triggered by pull-to-refresh.
class LoadExploreData extends ExploreEvent {
  final bool isRefresh;
  const LoadExploreData({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

/// Event triggered when the user types in the search bar.
class SearchQueryChanged extends ExploreEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}

/// Event triggered when the user selects a category chip.
class CategoryFilterChanged extends ExploreEvent {
  final String? categoryId; 
  const CategoryFilterChanged(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

/// Event triggered when the user changes the sort order from the menu.
class SortOrderChanged extends ExploreEvent {
  final SortOption sortOption;
  const SortOrderChanged(this.sortOption);
  @override
  List<Object> get props => [sortOption];
}