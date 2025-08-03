// import 'package:equatable/equatable.dart';

// abstract class HomeEvent extends Equatable {
//   const HomeEvent();
//   @override
//   List<Object> get props => [];
// }

// class LoadHomeData extends HomeEvent {}

// class SearchHomeProducts extends HomeEvent {
//   final String query;
//   const SearchHomeProducts(this.query);

//   @override
//   List<Object> get props => [query];
// }
































import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {
  final bool isRefresh;
  // Set a default value to avoid breaking existing calls
  const LoadHomeData({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class SearchHomeProducts extends HomeEvent {
  final String query;
  const SearchHomeProducts(this.query);

  @override
  List<Object> get props => [query];
}