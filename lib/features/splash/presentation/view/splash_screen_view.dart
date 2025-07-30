import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:lottie/lottie.dart';
import 'package:rolo/core/utils/page_transitions.dart';
import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
import 'package:rolo/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:rolo/features/splash/presentation/view_model/splash_view_model.dart'; 

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashViewModel()..decideNavigation(),
      child: BlocListener<SplashViewModel, SplashState>(
        listener: (context, state) {
          if (state == SplashState.navigateToHome) {
            Navigator.of(context).pushReplacement(
              PageTransitions.fadeIn(const DashboardView()), 
            );
          } else if (state == SplashState.navigateToLogin) {
            Navigator.of(context).pushReplacement(
              PageTransitions.fadeIn(const LoginScreen()),
            );
          }
        },
        child: const _SplashAnimationView(),
      ),
    );
  }
}

class _SplashAnimationView extends StatefulWidget {
  const _SplashAnimationView();

  @override
  State<_SplashAnimationView> createState() => __SplashAnimationViewState();
}

class __SplashAnimationViewState extends State<_SplashAnimationView> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(
          'assets/animations/rolo_splash_aniations.json',
          width: 888,
          height: 1920,
          fit: BoxFit.contain,
          controller: _controller,
          onLoaded: (composition) {
            setState(() {
              _isAnimationLoaded = true;
              _controller.duration = composition.duration;
              _controller.forward();
            });
          },
          frameBuilder: (context, child, composition) {
            if (_isAnimationLoaded) {
              return child;
            } else {
              return const Center(child: Text("ROLO", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)));
            }
          },
        ),
      ),
    );
  }
}