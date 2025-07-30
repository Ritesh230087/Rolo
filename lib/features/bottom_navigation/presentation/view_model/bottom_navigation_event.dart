import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class TabChanged extends BottomNavigationEvent {
  final int index;

  const TabChanged({required this.index});

  @override
  List<Object> get props => [index];
}