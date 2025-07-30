import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_event.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_viewmodel.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("--- Handling a background message: ${message.messageId}");
}

class FirebaseNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseNotificationService({required this.navigatorKey});

  void _handleMessageNavigation(RemoteMessage message) {
    final link = message.data['link'];
    if (link != null && link.isNotEmpty) {
      print("Notification tapped, navigating to: $link");
      navigatorKey.currentState?.pushNamed(link);
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('notification_icon');
        
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(settings);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessageNavigation(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageNavigation);

    FirebaseMessaging.onMessage.listen((message) {
      print("--- FOREGROUND message received: ${message.notification?.title}");

      final notification = message.notification;
      if (notification != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription: 'This channel is used for important notifications.',
              importance: Importance.max,
              priority: Priority.high,
              icon: 'notification_icon',
              largeIcon: DrawableResourceAndroidBitmap('rolo_logo'),
            ),
          ),
        );
      }

      final context = navigatorKey.currentContext;
      if (context != null) {
        context.read<NotificationViewModel>().add(LoadNotifications());
      }
    });
  }
}