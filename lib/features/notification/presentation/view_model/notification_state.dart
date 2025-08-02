// import 'package:equatable/equatable.dart';
// import 'package:rolo/features/notification/domain/entity/notification_entity.dart';

// enum NotificationStatus { initial, loading, success, error }

// class NotificationState extends Equatable {
//   final NotificationStatus status;
//   final List<NotificationEntity> notifications;
//   final int unreadCount;
//   final String? error;

//   const NotificationState({
//     this.status = NotificationStatus.initial,
//     this.notifications = const [],
//     this.unreadCount = 0,
//     this.error,
//   });

//   NotificationState copyWith({
//     NotificationStatus? status,
//     List<NotificationEntity>? notifications,
//     int? unreadCount,
//     String? error,
//   }) {
//     return NotificationState(
//       status: status ?? this.status,
//       notifications: notifications ?? this.notifications,
//       unreadCount: unreadCount ?? this.unreadCount,
//       error: error ?? this.error,
//     );
//   }

//   @override
//   List<Object?> get props => [status, notifications, unreadCount, error];
// }











































import 'package:equatable/equatable.dart';
import 'package:rolo/features/notification/domain/entity/notification_entity.dart';

enum NotificationStatus { initial, loading, success, error, noNetwork }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String? error;
  final String? actionMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.error,
    this.actionMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    String? error,
    String? actionMessage,
    bool clearActionMessage = false,
    bool clearError = false, // Add option to clear error
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      // Handle error clearing - if clearError is true or error is explicitly set to null
      error: clearError ? null : (error ?? this.error),
      // Handle action message clearing
      actionMessage: clearActionMessage ? null : (actionMessage ?? this.actionMessage),
    );
  }

  @override
  List<Object?> get props => [status, notifications, unreadCount, error, actionMessage];
}