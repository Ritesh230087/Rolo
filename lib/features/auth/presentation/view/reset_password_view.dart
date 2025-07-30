import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/reset_password/reset_password_event.dart';
import 'package:rolo/features/auth/presentation/view_model/reset_password/reset_password_state.dart';
import 'package:rolo/features/auth/presentation/view_model/reset_password/reset_password_viewmodel.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Your Password')),
      body: BlocProvider(
        create: (context) => serviceLocator<ResetPasswordViewModel>(),
        child: BlocConsumer<ResetPasswordViewModel, ResetPasswordState>(
          listener: (context, state) {
            if (state.status == ResetPasswordStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'An error occurred'), backgroundColor: Colors.red),
              );
            }
            if (state.status == ResetPasswordStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset successfully! Please log in.'), backgroundColor: Colors.green),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state.status == ResetPasswordStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Enter your new password below. Make sure it is secure.', textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'New Password'),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirm New Password'),
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<ResetPasswordViewModel>().add(
                                ResetPasswordSubmitted(
                                  token: token,
                                  password: passwordController.text,
                                ),
                              );
                        }
                      },
                      child: const Text('Reset Password'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}