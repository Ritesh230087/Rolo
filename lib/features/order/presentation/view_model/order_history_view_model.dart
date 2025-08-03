import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/order/domain/use_case/get_order_history_usecase.dart';
import 'package:rolo/features/order/presentation/view_model/order_history_event.dart';
import 'package:rolo/features/order/presentation/view_model/order_history_state.dart';

class OrderHistoryViewModel extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final GetOrderHistoryUseCase getOrderHistoryUsecase;
  
  OrderHistoryViewModel({required this.getOrderHistoryUsecase})
      : super(OrderHistoryInitial()) {
    
    on<LoadOrderHistory>((event, emit) async {
      emit(OrderHistoryLoading());
      final result = await getOrderHistoryUsecase(event.userId);
      result.fold(
        (failure) => emit(OrderHistoryError(failure.message)),
        (orders) => emit(OrderHistoryLoaded(orders)),
      );
    });
    
    on<RefreshOrderStatus>((event, emit) async {
      emit(OrderHistoryLoading());
      final result = await getOrderHistoryUsecase(event.userId);
      result.fold(
        (failure) => emit(OrderHistoryError(failure.message)),
        (orders) => emit(OrderHistoryLoaded(orders)),
      );
    });
  }
}