abstract class OrderHistoryEvent {}

class LoadOrderHistory extends OrderHistoryEvent {
  final String userId;
  LoadOrderHistory(this.userId);
}

class RefreshOrderStatus extends OrderHistoryEvent {
  final String userId;
  RefreshOrderStatus(this.userId);
}

class ViewOrderDetails extends OrderHistoryEvent {
  final String orderId;
  ViewOrderDetails(this.orderId);
}