import 'package:flutter/material.dart';
import 'package:rolo/view/splash_screen_view.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}