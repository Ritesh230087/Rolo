import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class SearchHomeProducts extends HomeEvent {
  final String query;
  const SearchHomeProducts(this.query);

  @override
  List<Object> get props => [query];
}