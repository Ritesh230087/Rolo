import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_event.dart';
import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_state.dart';

class BottomNavigationViewModel
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationViewModel() : super(const BottomNavigationState()) {
    on<TabChanged>((event, emit) {
      emit(state.copyWith(index: event.index));
    });
  }
}