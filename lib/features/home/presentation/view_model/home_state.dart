import 'package:equatable/equatable.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final HomeEntity homeData;
  const HomeLoaded(this.homeData);
  @override
  List<Object?> get props => [homeData];
}
class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}