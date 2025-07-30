import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_event.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_state.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_viewmodel.dart';
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: BlocProvider(
        create: (context) => serviceLocator<ForgotPasswordViewModel>(),
        child: BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
          listener: (context, state) {
            if (state.status == ForgotPasswordStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state.status == ForgotPasswordStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('If an account exists, a reset link has been sent.'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state.status == ForgotPasswordStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter your email address and we will send you a link to reset your password.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email Address'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context
                              .read<ForgotPasswordViewModel>()
                              .add(SendResetLink(emailController.text.trim()));
                        }
                      },
                      child: const Text('Send Reset Link'),
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