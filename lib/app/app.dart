import 'package:flutter/material.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/splash/presentation/view/splash_screen_view.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreen());
  }
}
