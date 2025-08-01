import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rolo/app/app.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/core/network/hive_service.dart';
import 'package:rolo/services/deep_link_service.dart';
import 'package:rolo/services/firebase_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveService().init();
  await Firebase.initializeApp();
  await FirebaseNotificationService(navigatorKey: App.navigatorKey).initNotifications();
  final deepLinkService = DeepLinkService(navigatorKey: App.navigatorKey);
  await deepLinkService.init();
  runApp(const App());
}
