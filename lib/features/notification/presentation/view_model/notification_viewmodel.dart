// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/features/notification/domain/use_case/get_notifications_usecase.dart';
// import 'package:rolo/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
// import 'package:rolo/features/notification/domain/use_case/mark_as_read_usecase.dart';
// import 'package:rolo/features/notification/presentation/view_model/notification_event.dart';
// import 'package:rolo/features/notification/presentation/view_model/notification_state.dart';

// class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
//   final GetNotificationsUseCase _getNotificationsUseCase;
//   final MarkAsReadUseCase _markAsReadUseCase;
//   final MarkAllAsReadUseCase _markAllAsReadUseCase;

//   NotificationViewModel({
//     required GetNotificationsUseCase getNotificationsUseCase,
//     required MarkAsReadUseCase markAsReadUseCase,
//     required MarkAllAsReadUseCase markAllAsReadUseCase,
//   })  : _getNotificationsUseCase = getNotificationsUseCase,
//         _markAsReadUseCase = markAsReadUseCase,
//         _markAllAsReadUseCase = markAllAsReadUseCase,
//         super(const NotificationState()) {
//     on<LoadNotifications>(_onLoadNotifications);
//     on<MarkNotificationAsRead>(_onMarkAsRead);
//     on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
//   }

//   Future<void> _onLoadNotifications(
//       LoadNotifications event, Emitter<NotificationState> emit) async {
//     emit(state.copyWith(status: NotificationStatus.loading));
//     final result = await _getNotificationsUseCase();
//     result.fold(
//       (failure) => emit(state.copyWith(status: NotificationStatus.error, error: failure.message)),
//       (notifications) {
//         final unread = notifications.where((n) => !n.isRead).length;
//         emit(state.copyWith(
//           status: NotificationStatus.success,
//           notifications: notifications,
//           unreadCount: unread,
//         ));
//       },
//     );
//   }

//   Future<void> _onMarkAsRead(
//       MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
//     final result = await _markAsReadUseCase(event.notificationId);
//     result.fold(
//       (failure) { /* Optionally handle error */ },
//       (_) => add(LoadNotifications()), 
//     );
//   }

//   Future<void> _onMarkAllAsRead(
//       MarkAllNotificationsAsRead event, Emitter<NotificationState> emit) async {
//     final result = await _markAllAsReadUseCase();
//     result.fold(
//       (failure) { /* Optionally handle error */ },
//       (_) => add(LoadNotifications()), 
//     );
//   }
// }














































import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rolo/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:rolo/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:rolo/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_event.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;
  final Connectivity _connectivity;

  NotificationViewModel({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
    required MarkAllAsReadUseCase markAllAsReadUseCase,
    required Connectivity connectivity,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markAsReadUseCase = markAsReadUseCase,
        _markAllAsReadUseCase = markAllAsReadUseCase,
        _connectivity = connectivity,
        super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    // Clear any previous action messages and errors when loading
    emit(state.copyWith(
      status: NotificationStatus.loading, 
      clearActionMessage: true,
      error: null, // Clear previous errors
    ));

    try {
      // Check connectivity first
      final connectivityResult = await _connectivity.checkConnectivity();
      
      // Handle offline state - don't try to make API calls
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(state.copyWith(
          status: NotificationStatus.noNetwork,
          error: null, // Clear any previous errors
        ));
        return;
      }

      // Only make API call if we have connectivity
      final result = await _getNotificationsUseCase();
      result.fold(
        (failure) => emit(state.copyWith(
          status: NotificationStatus.error, 
          error: failure.message,
        )),
        (notifications) {
          final unread = notifications.where((n) => !n.isRead).length;
          emit(state.copyWith(
            status: NotificationStatus.success,
            notifications: notifications,
            unreadCount: unread,
            error: null, // Clear any previous errors
          ));
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      emit(state.copyWith(
        status: NotificationStatus.error,
        error: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMarkAsRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    try {
      // Check connectivity before making API call
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(state.copyWith(
          actionMessage: "You are offline. Cannot mark notification as read.",
        ));
        return;
      }

      final result = await _markAsReadUseCase(event.notificationId);
      result.fold(
        (failure) { 
          emit(state.copyWith(
            actionMessage: "Failed to mark notification as read. Please try again.",
          ));
        },
        (_) {
          // Successfully marked as read, reload notifications
          add(LoadNotifications());
        }, 
      );
    } catch (e) {
      emit(state.copyWith(
        actionMessage: "An error occurred while marking notification as read.",
      ));
    }
  }

  Future<void> _onMarkAllAsRead(
      MarkAllNotificationsAsRead event, Emitter<NotificationState> emit) async {
    try {
      // Check connectivity before making API call
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(state.copyWith(
          actionMessage: "You are offline. Cannot mark all notifications as read.",
        ));
        return;
      }

      final result = await _markAllAsReadUseCase();
      result.fold(
        (failure) { 
          emit(state.copyWith(
            actionMessage: "Failed to mark all notifications as read. Please try again.",
          ));
        },
        (_) {
          // Successfully marked all as read, reload notifications
          add(LoadNotifications());
        }, 
      );
    } catch (e) {
      emit(state.copyWith(
        actionMessage: "An error occurred while marking all notifications as read.",
      ));
    }
  }
}