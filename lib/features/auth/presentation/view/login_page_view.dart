import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/utils/page_transitions.dart';
import 'package:rolo/core/widgets/animated_button.dart';
import 'package:rolo/features/auth/presentation/view/forgot_password_view.dart';
import 'package:rolo/features/auth/presentation/view/signup_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:rolo/features/dashboard/presentation/view/dashboard_view.dart';

class LoginScreen extends StatefulWidget {
  final bool showLogoutSuccessSnackbar;

  const LoginScreen({
    super.key,
    this.showLogoutSuccessSnackbar = false, 
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  late AnimationController _formController;
  late Animation<double> _formSlideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<LoginViewModel>().add(LoginResetEvent());
    context.read<LoginViewModel>().add(CheckForSavedCredentialsEvent());
    _formController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _formSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));
    _formController.forward();

    if (widget.showLogoutSuccessSnackbar) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have been logged out successfully.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating, 
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              PageTransitions.scaleIn(const DashboardView()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: AnimatedBuilder(
              animation: _formController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _formSlideAnimation.value),
                  child: Opacity(
                    opacity: _formController.value,
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenHeight - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(flex: 3),
                                  const Text('Login', style: AppTheme.headingStyle),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Sign in to explore authentic Nepalese\ncraftsmanship',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.captionStyle,
                                  ),
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    controller: _emailController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _buildInputDecoration('Your email address', Icons.email),
                                    validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'Enter a valid email' : null,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _isPasswordObscured,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _buildInputDecoration('Enter your password', Icons.lock).copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                                        onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                                      ),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                                      child: const Text('Forgot Password?', style: TextStyle(color: AppTheme.primaryColor)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedButton(
                                    text: 'Login',
                                    isLoading: state.isLoading,
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        context.read<LoginViewModel>().add(LoginWithEmailAndPasswordEvent(
                                              context: context,
                                              email: _emailController.text.trim(),
                                              password: _passwordController.text.trim(),
                                            ));
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  if (true) 
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => context.read<LoginViewModel>().add(LoginWithBiometricsEvent(context: context)),
                                          child: SizedBox(
                                            width: 150,
                                            height: 150,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(75),
                                              child: Transform.scale(
                                                scale: 2.0,
                                                child: Lottie.asset(
                                                  'assets/animations/Fingerprint Scanning.json',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text('Login with Fingerprint', style: TextStyle(color: Colors.white70)),
                                      ],
                                    ),
                                  const Spacer(flex: 2),
                                  const Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.grey)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text('OR', style: TextStyle(color: Colors.white70)),
                                      ),
                                      Expanded(child: Divider(color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: state.isLoading
                                        ? const Center(child: CircularProgressIndicator())
                                        : OutlinedButton.icon(
                                            icon: Image.asset('assets/images/google_logo.png', height: 24.0, width: 24.0),
                                            label: const Text(
                                              'Sign in with Google',
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            onPressed: () => context.read<LoginViewModel>().add(LoginWithGoogleEvent(context: context)),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              side: BorderSide(color: Colors.grey.shade700),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 20),
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Don\'t have an account? ',
                                        style: AppTheme.captionStyle,
                                        children: [
                                          TextSpan(
                                            text: 'Sign Up',
                                            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, PageTransitions.slideFromRight(SignUpScreen())),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(flex: 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor)),
    );
  }
}