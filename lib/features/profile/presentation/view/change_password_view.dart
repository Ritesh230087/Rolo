import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/animated_button.dart';
import 'package:rolo/features/profile/presentation/view_model/change_password/change_password_event.dart';
import 'package:rolo/features/profile/presentation/view_model/change_password/change_password_state.dart';
import 'package:rolo/features/profile/presentation/view_model/change_password/change_password_viewmodel.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordViewModel>(
      create: (_) => serviceLocator<ChangePasswordViewModel>(),
      child: const _ChangePasswordViewBody(),
    );
  }
}

class _ChangePasswordViewBody extends StatefulWidget {
  const _ChangePasswordViewBody({Key? key}) : super(key: key);

  @override
  State<_ChangePasswordViewBody> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordViewBody> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _headerController;
  late AnimationController _formController;
  late AnimationController _securityController;

  late Animation<double> _headerAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _securityAnimation;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _formController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _securityController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _headerAnimation = CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic);
    _formAnimation = CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic);
    _securityAnimation = CurvedAnimation(parent: _securityController, curve: Curves.easeOutCubic);

    _startAnimations();
  }

  void _startAnimations() async {
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _formController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _securityController.forward();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _headerController.dispose();
    _formController.dispose();
    _securityController.dispose();
    super.dispose();
  }

  void _onChangePasswordPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordViewModel>().add(
            SubmitChangePasswordEvent(
              currentPassword: _currentPasswordController.text.trim(),
              newPassword: _newPasswordController.text.trim(),
              confirmPassword: _confirmPasswordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _headerAnimation,
          builder: (_, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * _headerAnimation.value),
              child: Opacity(
                opacity: _headerAnimation.value,
                child: const Text(
                  'Change Password',
                  style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<ChangePasswordViewModel, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Password changed successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAnimatedWidget(_headerAnimation, _buildSecurityHeader()),
                  const SizedBox(height: 32),
                  _buildAnimatedWidget(_formAnimation, _buildPasswordForm()),
                  const SizedBox(height: 32),
                  _buildAnimatedWidget(_securityAnimation, _buildSecurityTips()),
                  const SizedBox(height: 40),
                  _buildAnimatedWidget(
                    _securityAnimation,
                    AnimatedButton(
                      text: 'Change Password',
                      onPressed: isLoading ? null : _onChangePasswordPressed,
                      isLoading: isLoading,
                      width: double.infinity,
                      icon: Icons.security,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedWidget(Animation<double> animation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - animation.value)),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }

  Widget _buildSecurityHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.cardColor, AppTheme.primaryColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, size: 52, color: Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              'Keep your account safe by changing your password regularly.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      children: [
        _buildPasswordField(
          controller: _currentPasswordController,
          label: 'Current Password',
          obscure: _obscureCurrentPassword,
          toggle: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _newPasswordController,
          label: 'New Password',
          obscure: _obscureNewPassword,
          toggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter new password';
            if (value.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _confirmPasswordController,
          label: 'Confirm New Password',
          obscure: _obscureConfirmPassword,
          toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please confirm new password';
            if (value != _newPasswordController.text) return 'Passwords do not match';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
    );
  }

  Widget _buildSecurityTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Security Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('• Use a strong password combining letters, numbers, and symbols.'),
        Text('• Avoid using the same password across multiple accounts.'),
        Text('• Change your password regularly to reduce risk.'),
      ],
    );
  }
}
