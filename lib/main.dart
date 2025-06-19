import 'package:flutter/material.dart';
import 'package:rolo/app/app.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/core/network/hive_service.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveService().init();
  runApp(const App());
}
