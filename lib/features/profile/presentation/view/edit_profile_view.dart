// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/core/widgets/animated_button.dart';
// import 'package:rolo/core/widgets/staggered_animation.dart';
// import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart';
// import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart' as state;
// import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_viewmodel.dart';

// class EditProfileView extends StatefulWidget {
//   final EditProfileViewModel viewModel;
//   final String initialFName;
//   final String initialLName;
//   final String email;

//   const EditProfileView({
//     Key? key,
//     required this.viewModel,
//     required this.initialFName,
//     required this.initialLName,
//     required this.email,
//   }) : super(key: key);

//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }

// class _EditProfileViewState extends State<EditProfileView>
//     with TickerProviderStateMixin {
//   late TextEditingController _fNameController;
//   late TextEditingController _lNameController;
//   late AnimationController _headerController;
//   late AnimationController _formController;
//   late AnimationController _avatarController;

//   late Animation<double> _headerAnimation;
//   late Animation<double> _formAnimation;
//   late Animation<double> _avatarAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _fNameController = TextEditingController(text: widget.initialFName);
//     _lNameController = TextEditingController(text: widget.initialLName);

//     _headerController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _formController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _avatarController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
//     );

//     _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
//     );

//     _avatarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _avatarController, curve: Curves.elasticOut),
//     );

//     widget.viewModel.loadInitialData(
//       fName: widget.initialFName,
//       lName: widget.initialLName,
//       email: widget.email,
//     );

//     _startAnimations();
//   }

//   void _startAnimations() async {
//     _headerController.forward();
//     await Future.delayed(const Duration(milliseconds: 300));
//     _formController.forward();
//     await Future.delayed(const Duration(milliseconds: 200));
//     _avatarController.forward();
//   }

//   @override
//   void dispose() {
//     _fNameController.dispose();
//     _lNameController.dispose();
//     _headerController.dispose();
//     _formController.dispose();
//     _avatarController.dispose();
//     super.dispose();
//   }

//   void _onSavePressed() {
//     widget.viewModel.add(EditProfileSubmitted(
//       fName: _fNameController.text,
//       lName: _lNameController.text,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: widget.viewModel,
//       child: BlocListener<EditProfileViewModel, state.EditProfileState>(
//         listener: (context, stateObj) {
//           if (stateObj is state.EditProfileSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text('Profile updated successfully'),
//                 backgroundColor: Colors.green,
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             );
//             Navigator.pop(context);
//           } else if (stateObj is state.EditProfileFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(stateObj.message),
//                 backgroundColor: Colors.red,
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             );
//           }
//         },
//         child: Scaffold(
//           backgroundColor: AppTheme.backgroundColor,
//           appBar: AppBar(
//             title: AnimatedBuilder(
//               animation: _headerAnimation,
//               builder: (context, child) => Transform.scale(
//                 scale: 0.8 + (0.2 * _headerAnimation.value),
//                 child: Opacity(
//                   opacity: _headerAnimation.value,
//                   child: const Text(
//                     'Edit Profile',
//                     style: TextStyle(
//                       fontFamily: 'Playfair Display',
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//           body: BlocBuilder<EditProfileViewModel, state.EditProfileState>(
//             builder: (context, stateObj) {
//               final isLoading = stateObj is state.EditProfileLoading;
//               final email = stateObj is state.EditProfileInitial
//                   ? stateObj.email
//                   : widget.email;

//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     _buildAvatar(email),
//                     const SizedBox(height: 40),
//                     _buildForm(email, isLoading),
//                     const SizedBox(height: 40),
//                     _buildStats(),
//                     const SizedBox(height: 40),
//                     _buildSaveButton(isLoading),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAvatar(String email) => AnimatedBuilder(
//         animation: _avatarAnimation,
//         builder: (context, child) => Transform.scale(
//           scale: _avatarAnimation.value,
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppTheme.cardColor, AppTheme.primaryColor.withOpacity(0.1)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppTheme.primaryColor.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppTheme.primaryColor.withOpacity(0.3),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${widget.initialFName[0]}${widget.initialLName[0]}',
//                       style: const TextStyle(
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Playfair Display',
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: CircleAvatar(
//                     radius: 18,
//                     backgroundColor: AppTheme.primaryColor,
//                     child: IconButton(
//                       icon: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
//                       onPressed: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: const Text('Profile picture update coming soon'),
//                             backgroundColor: AppTheme.primaryColor,
//                           ),
//                         );
//                       },
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//   Widget _buildForm(String email, bool isLoading) => AnimatedBuilder(
//         animation: _formAnimation,
//         builder: (context, child) => Transform.translate(
//           offset: Offset(0, 50 * (1 - _formAnimation.value)),
//           child: Opacity(
//             opacity: _formAnimation.value,
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: AppTheme.cardColor,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppTheme.primaryColor.withOpacity(0.1),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Personal Information',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Playfair Display',
//                       color: AppTheme.accentColor,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   StaggeredAnimation(
//                     delay: const Duration(milliseconds: 100),
//                     children: [
//                       _buildTextField(
//                         controller: _fNameController,
//                         label: 'First Name',
//                         icon: Icons.person_outline,
//                         enabled: !isLoading,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         controller: _lNameController,
//                         label: 'Last Name',
//                         icon: Icons.person_outline,
//                         enabled: !isLoading,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         initialValue: email,
//                         label: 'Email',
//                         icon: Icons.email_outlined,
//                         enabled: false,
//                         helperText: 'Email cannot be changed',
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );

//   Widget _buildStats() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: _statCard('Member Since', 'Jan 2024', Icons.calendar_today, Colors.blue)),
//               const SizedBox(width: 16),
//               Expanded(child: _statCard('Orders', '12', Icons.shopping_bag, Colors.green)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _statCard('Wishlist', '24', Icons.favorite_border, Colors.red)),
//               const SizedBox(width: 16),
//               Expanded(child: _statCard('Reviews', '8', Icons.star_border, Colors.orange)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statCard(String label, String value, IconData icon, Color color) {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 600),
//       tween: Tween(begin: 0.0, end: 1.0),
//       builder: (context, animValue, child) {
//         return Transform.scale(
//           scale: 0.8 + (0.2 * animValue),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppTheme.backgroundColor,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.2)),
//             ),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 18,
//                   backgroundColor: color.withOpacity(0.1),
//                   child: Icon(icon, color: color, size: 20),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
//                 const SizedBox(height: 4),
//                 Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSaveButton(bool isLoading) => AnimatedBuilder(
//         animation: _formAnimation,
//         builder: (context, child) => Transform.scale(
//           scale: 0.8 + (0.2 * _formAnimation.value),
//           child: Opacity(
//             opacity: _formAnimation.value,
//             child: isLoading
//                 ? const CircularProgressIndicator()
//                 : AnimatedButton(
//                     text: 'Save Changes',
//                     onPressed: _onSavePressed,
//                     width: double.infinity,
//                     icon: Icons.save,
//                   ),
//           ),
//         ),
//       );

//   Widget _buildTextField({
//     TextEditingController? controller,
//     String? initialValue,
//     required String label,
//     required IconData icon,
//     bool enabled = true,
//     String? helperText,
//   }) {
//     return TextFormField(
//       controller: controller,
//       initialValue: initialValue,
//       enabled: enabled,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: enabled ? AppTheme.primaryColor : Colors.grey),
//         helperText: helperText,
//         filled: true,
//         fillColor: AppTheme.backgroundColor,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: AppTheme.primaryColor),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       ),
//     );
//   }
// }
















































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/animated_button.dart';
import 'package:rolo/core/widgets/staggered_animation.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_event.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_state.dart' as state;
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  final EditProfileViewModel viewModel;
  final String initialFName;
  final String initialLName;
  final String email;

  const EditProfileView({
    Key? key,
    required this.viewModel,
    required this.initialFName,
    required this.initialLName,
    required this.email,
  }) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> with TickerProviderStateMixin {
  late TextEditingController _fNameController;
  late TextEditingController _lNameController;
  late AnimationController _headerController, _formController, _avatarController;
  late Animation<double> _headerAnimation, _formAnimation, _avatarAnimation;

  @override
  void initState() {
    super.initState();
    _fNameController = TextEditingController(text: widget.initialFName);
    _lNameController = TextEditingController(text: widget.initialLName);

    _headerController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _formController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _avatarController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    _headerAnimation = CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic);
    _formAnimation = CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic);
    _avatarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _avatarController, curve: Curves.elasticOut));

    widget.viewModel.loadInitialData();
    _startAnimations();
  }

  void _startAnimations() async {
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _avatarController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _formController.forward();
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _headerController.dispose();
    _formController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  /// ** THIS IS THE CORRECTED METHOD **
  /// Checks for internet connection before dispatching the save event.
  Future<void> _onSavePressed() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
       _showOfflineDialog();
       return;
    }
    // If online, proceed to submit the form
    widget.viewModel.add(EditProfileSubmitted(
      fName: _fNameController.text.trim(),
      lName: _lNameController.text.trim(),
    ));
  }
  
  /// ** THIS IS THE CORRECTED METHOD **
  /// Displays a dialog with a Lottie animation for no internet connection.
  void _showOfflineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/no internet connection.json', width: 150),
            const SizedBox(height: 16),
            const Text("No Internet Connection", style: AppTheme.subheadingStyle),
            const SizedBox(height: 8),
            const Text("Please check your connection to save changes.",
                style: AppTheme.captionStyle, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: AppTheme.primaryColor))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.viewModel,
      child: BlocListener<EditProfileViewModel, state.EditProfileState>(
        listener: (context, stateObj) {
          if (stateObj is state.EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile updated successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
            Navigator.pop(context, true); // Pop with a result to indicate success
          } else if (stateObj is state.EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(stateObj.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) => Transform.scale(
                scale: 0.8 + (0.2 * _headerAnimation.value),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: const Text('Edit Profile',
                      style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: BlocBuilder<EditProfileViewModel, state.EditProfileState>(
            builder: (context, stateObj) {
              final isLoading = stateObj is state.EditProfileLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 40),
                    _buildForm(isLoading),
                    const SizedBox(height: 40),
                    _buildSaveButton(isLoading),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() => AnimatedBuilder(
        animation: _avatarAnimation,
        builder: (context, child) => Transform.scale(
          scale: _avatarAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.cardColor, AppTheme.primaryColor.withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppTheme.primaryColor.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)]),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)
                ],
              ),
              child: Center(
                child: Text(
                  '${widget.initialFName.isNotEmpty ? widget.initialFName[0] : ''}${widget.initialLName.isNotEmpty ? widget.initialLName[0] : ''}'.toUpperCase(),
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display'),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildForm(bool isLoading) => AnimatedBuilder(
        animation: _formAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, 50 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Personal Information',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display', color: AppTheme.accentColor)),
                  const SizedBox(height: 24),
                  StaggeredAnimation(
                    delay: const Duration(milliseconds: 100),
                    children: [
                      _buildTextField(controller: _fNameController, label: 'First Name', icon: Icons.person_outline, enabled: !isLoading),
                      const SizedBox(height: 20),
                      _buildTextField(controller: _lNameController, label: 'Last Name', icon: Icons.person_outline, enabled: !isLoading),
                      const SizedBox(height: 20),
                      _buildTextField(initialValue: widget.email, label: 'Email', icon: Icons.email_outlined, enabled: false, helperText: 'Email cannot be changed'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildSaveButton(bool isLoading) => AnimatedBuilder(
        animation: _formAnimation,
        builder: (context, child) => Transform.scale(
          scale: 0.8 + (0.2 * _formAnimation.value),
          child: Opacity(
            opacity: _formAnimation.value,
            child: AnimatedButton(
              text: 'Save Changes',
              onPressed: isLoading ? null : _onSavePressed,
              isLoading: isLoading,
              width: double.infinity,
              icon: Icons.save,
            ),
          ),
        ),
      );

  Widget _buildTextField({
    TextEditingController? controller,
    String? initialValue,
    required String label,
    required IconData icon,
    bool enabled = true,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      style: TextStyle(color: enabled ? Colors.white : Colors.grey.shade500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: enabled ? AppTheme.primaryColor : Colors.grey),
        helperText: helperText,
        filled: true,
        fillColor: AppTheme.backgroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryColor)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }
}