import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:rolo/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:rolo/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_event.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;

  NotificationViewModel({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
    required MarkAllAsReadUseCase markAllAsReadUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markAsReadUseCase = markAsReadUseCase,
        _markAllAsReadUseCase = markAllAsReadUseCase,
        super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    final result = await _getNotificationsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: NotificationStatus.error, error: failure.message)),
      (notifications) {
        final unread = notifications.where((n) => !n.isRead).length;
        emit(state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          unreadCount: unread,
        ));
      },
    );
  }

  Future<void> _onMarkAsRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    final result = await _markAsReadUseCase(event.notificationId);
    result.fold(
      (failure) { /* Optionally handle error */ },
      (_) => add(LoadNotifications()), 
    );
  }

  Future<void> _onMarkAllAsRead(
      MarkAllNotificationsAsRead event, Emitter<NotificationState> emit) async {
    final result = await _markAllAsReadUseCase();
    result.fold(
      (failure) { /* Optionally handle error */ },
      (_) => add(LoadNotifications()), 
    );
  }
}