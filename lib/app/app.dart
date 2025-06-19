// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/app/service_locator/service_locator.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/features/splash/presentation/view/splash_screen_view.dart';
// import 'package:rolo/features/splash/presentation/view_model/splash_view_model.dart';


// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: getApplicationTheme(),
//       home: BlocProvider.value(
//         value: serviceLocator<SplashViewModel>(),
//         child: SplashScreen(),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:rolo/features/splash/presentation/view/splash_screen_view.dart';
import 'package:rolo/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<SplashViewModel>()),
        BlocProvider(create: (_) => serviceLocator<RegisterViewModel>()),
        BlocProvider(create:(_) => serviceLocator<LoginViewModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
