import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/utils/page_transitions.dart';
import 'package:rolo/core/widgets/animated_button.dart'; 
import 'package:rolo/core/widgets/staggered_animation.dart';
import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _formController;
  late Animation<double> _formSlideAnimation;

  @override
  void initState() {
    super.initState();
    _formController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _formSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));

    _formController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RegisterViewModel, RegisterState>(
            listener: (context, state) {
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful! Welcome.'), backgroundColor: Colors.green));
                Navigator.pushAndRemoveUntil(context, PageTransitions.fadeIn(const LoginScreen()), (route) => false);
              }
            },
          ),
          BlocListener<LoginViewModel, LoginState>(
            listener: (context, state) {
              if (state.isSuccess) {
                Navigator.pushAndRemoveUntil(context, PageTransitions.fadeIn(const LoginScreen()), (route) => false);
              }
            },
          ),
        ],
        child: BlocBuilder<RegisterViewModel, RegisterState>(
          builder: (context, registerState) {
            return BlocBuilder<LoginViewModel, LoginState>(
              builder: (context, loginState) {
                final isOverallLoading = registerState.isLoading || loginState.isLoading;

                return SafeArea(
                  child: AnimatedBuilder(
                    animation: _formController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _formSlideAnimation.value),
                        child: Opacity(
                          opacity: _formController.value,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            child: Form(
                              key: _formKey,
                              child: StaggeredAnimation(
                                children: [
                                  const Text('Create Account', style: AppTheme.headingStyle),
                                  const SizedBox(height: 10),
                                  const Text('Sign up to begin your journey', textAlign: TextAlign.center, style: AppTheme.captionStyle),
                                  const SizedBox(height: 30),
                                  TextFormField(controller: _firstNameController, style: const TextStyle(color: Colors.white), decoration: _buildInputDecoration('First Name', Icons.person), validator: (value) => value!.isEmpty ? 'Enter first name' : null),
                                  const SizedBox(height: 16),
                                  TextFormField(controller: _lastNameController, style: const TextStyle(color: Colors.white), decoration: _buildInputDecoration('Last Name', Icons.person_outline), validator: (value) => value!.isEmpty ? 'Enter last name' : null),
                                  const SizedBox(height: 16),
                                  TextFormField(controller: _emailController, style: const TextStyle(color: Colors.white), decoration: _buildInputDecoration('Your email address', Icons.email), validator: (value) { if (value!.isEmpty) return 'Enter email'; if (!value.contains('@')) return 'Enter valid email'; return null; }),
                                  const SizedBox(height: 16),
                                  TextFormField(controller: _passwordController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: _buildInputDecoration('Create a password', Icons.lock), validator: (value) => value!.isEmpty ? 'Enter password' : null),
                                  const SizedBox(height: 24),
                                  AnimatedButton(
                                    text: 'Sign Up',
                                    isLoading: isOverallLoading, 
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<RegisterViewModel>().add(RegisterUserEvent(
                                              context: context,
                                              fName: _firstNameController.text.trim(),
                                              lName: _lastNameController.text.trim(),
                                              email: _emailController.text.trim(),
                                              password: _passwordController.text.trim(),
                                            ));
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  const Row(children: [Expanded(child: Divider(color: Colors.grey)), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('OR', style: TextStyle(color: Colors.white70))), Expanded(child: Divider(color: Colors.grey))]),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56, 
                                    child: OutlinedButton.icon(
                                      icon: Image.asset('assets/images/google_logo.png', height: 24.0, width: 24.0), 
                                      label: const Text('Sign up with Google', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), 
                                      onPressed: () => context.read<LoginViewModel>().add(LoginWithGoogleEvent(context: context)),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: BorderSide(color: Colors.grey.shade700),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Already registered? ',
                                        style: AppTheme.captionStyle,
                                        children: [
                                          TextSpan(
                                            text: 'Log In',
                                            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor)));
  }
}