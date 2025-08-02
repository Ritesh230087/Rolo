// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/features/notification/domain/entity/notification_entity.dart';
// import 'package:rolo/features/notification/presentation/view_model/notification_event.dart';
// import 'package:rolo/features/notification/presentation/view_model/notification_state.dart';
// import 'package:rolo/features/notification/presentation/view_model/notification_viewmodel.dart';

// class NotificationView extends StatelessWidget {
//   const NotificationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: context.read<NotificationViewModel>()..add(LoadNotifications()),
//       child: Scaffold(
//         backgroundColor: AppTheme.backgroundColor,
//         appBar: AppBar(
//           title: const Text('Notifications'),
//           backgroundColor: AppTheme.cardColor,
//           elevation: 1,
//           actions: [
//             BlocBuilder<NotificationViewModel, NotificationState>(
//               builder: (context, state) {
//                 if (state.status == NotificationStatus.success && state.unreadCount > 0) {
//                   return TextButton(
//                     onPressed: () {
//                       context.read<NotificationViewModel>().add(MarkAllNotificationsAsRead());
//                     },
//                     child: const Text('Mark all as read'),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ],
//         ),
//         body: BlocBuilder<NotificationViewModel, NotificationState>(
//           builder: (context, state) {
//             if (state.status == NotificationStatus.loading && state.notifications.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state.status == NotificationStatus.error) {
//               return Center(child: Text(state.error ?? 'Failed to load notifications'));
//             }
//             if (state.notifications.isEmpty) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
//                     SizedBox(height: 16),
//                     Text('No Notifications Yet', style: AppTheme.subheadingStyle),
//                     Text('We\'ll let you know when something new comes up.', style: AppTheme.captionStyle),
//                   ],
//                 ),
//               );
//             }
//             return ListView.separated(
//               itemCount: state.notifications.length,
//               separatorBuilder: (context, index) => const Divider(height: 1),
//               itemBuilder: (context, index) {
//                 final notification = state.notifications[index];
//                 return _NotificationCard(notification: notification);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _NotificationCard extends StatelessWidget {
//   final NotificationEntity notification;
//   const _NotificationCard({required this.notification});

//   @override
//   Widget build(BuildContext context) {
//     final timeAgo = DateFormat.yMMMd().add_jm().format(notification.createdAt.toLocal());

//     return InkWell(
//       onTap: () {
//         if (!notification.isRead) {
//           context.read<NotificationViewModel>().add(MarkNotificationAsRead(notification.id));
//         }
//         if (notification.link != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Navigate to: ${notification.link}')),
//           );
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         color: notification.isRead ? AppTheme.backgroundColor : AppTheme.cardColor.withOpacity(0.5),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
//               child: Icon(_getIconForCategory(notification.category), color: AppTheme.primaryColor),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(notification.message, style: AppTheme.bodyStyle),
//                   const SizedBox(height: 4),
//                   Text(timeAgo, style: AppTheme.captionStyle),
//                 ],
//               ),
//             ),
//             if (!notification.isRead) ...[
//               const SizedBox(width: 16),
//               const CircleAvatar(
//                 radius: 5,
//                 backgroundColor: AppTheme.primaryColor,
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getIconForCategory(String category) {
//     switch (category) {
//       case 'order':
//         return Icons.shopping_bag_outlined;
//       case 'promotion':
//         return Icons.campaign_outlined;
//       case 'account':
//         return Icons.person_outline;
//       default:
//         return Icons.notifications_outlined;
//     }
//   }
// }

























































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/notification/domain/entity/notification_entity.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_event.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_state.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_viewmodel.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<NotificationViewModel>()..add(LoadNotifications()),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: AppTheme.cardColor,
          elevation: 1,
          actions: [
            BlocBuilder<NotificationViewModel, NotificationState>(
              builder: (context, state) {
                if (state.status == NotificationStatus.success && state.unreadCount > 0) {
                  return TextButton(
                    onPressed: () {
                      context.read<NotificationViewModel>().add(MarkAllNotificationsAsRead());
                    },
                    child: const Text('Mark all as read'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocListener<NotificationViewModel, NotificationState>(
          listener: (context, state) {
            // Show snackbar for action messages
            if (state.actionMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionMessage!),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          child: BlocBuilder<NotificationViewModel, NotificationState>(
            builder: (context, state) {
              if (state.status == NotificationStatus.loading && state.notifications.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Show offline state with Lottie animation
              if (state.status == NotificationStatus.noNetwork) {
                return _buildOfflineView(context);
              }
              
              if (state.status == NotificationStatus.error) {
                return Center(child: Text(state.error ?? 'Failed to load notifications'));
              }
              
              if (state.notifications.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No Notifications Yet', style: AppTheme.subheadingStyle),
                      Text('We\'ll let you know when something new comes up.', style: AppTheme.captionStyle),
                    ],
                  ),
                );
              }
              
              return ListView.separated(
                itemCount: state.notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _NotificationCard(notification: notification);
                },
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<NotificationViewModel, NotificationState>(
          builder: (context, state) {
            // Show retry button when offline
            if (state.status == NotificationStatus.noNetwork) {
              return FloatingActionButton(
                onPressed: () {
                  context.read<NotificationViewModel>().add(LoadNotifications());
                },
                backgroundColor: AppTheme.primaryColor,
                child: const Icon(Icons.refresh),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOfflineView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation for no internet connection
          Lottie.asset(
            'assets/animations/no_internet_connection.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
            repeat: true,
          ),
          const SizedBox(height: 24),
          Text(
            'No Internet Connection',
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Please check your internet connection and try again.',
              style: AppTheme.captionStyle.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.read<NotificationViewModel>().add(LoadNotifications());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final timeAgo = DateFormat.yMMMd().add_jm().format(notification.createdAt.toLocal());

    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationViewModel>().add(MarkNotificationAsRead(notification.id));
        }
        if (notification.link != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigate to: ${notification.link}')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: notification.isRead ? AppTheme.backgroundColor : AppTheme.cardColor.withOpacity(0.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              child: Icon(_getIconForCategory(notification.category), color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.message, style: AppTheme.bodyStyle),
                  const SizedBox(height: 4),
                  Text(timeAgo, style: AppTheme.captionStyle),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: 16),
              const CircleAvatar(
                radius: 5,
                backgroundColor: AppTheme.primaryColor,
              ),
            ]
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'promotion':
        return Icons.campaign_outlined;
      case 'account':
        return Icons.person_outline;
      default:
        return Icons.notifications_outlined;
    }
  }
}