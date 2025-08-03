// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/app/service_locator/service_locator.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/core/widgets/animated_button.dart';
// import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
// import 'package:rolo/features/order/presentation/view/order_history_view.dart';
// import 'package:rolo/features/profile/domain/entity/profile_entity.dart';
// import 'package:rolo/features/profile/presentation/view/change_password_view.dart';
// import 'package:rolo/features/profile/presentation/view/edit_profile_view.dart';
// import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_viewmodel.dart';
// import 'package:rolo/features/profile/presentation/view_model/profile_event.dart';
// import 'package:rolo/features/profile/presentation/view_model/profile_state.dart';
// import 'package:rolo/features/profile/presentation/view_model/profile_viewmodel.dart';

// class ProfileView extends StatefulWidget {
//   const ProfileView({super.key});

//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileViewModel>().add(LoadProfile());
//   }

//   Future<void> _showLogoutConfirmationDialog(BuildContext context, ProfileState state) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           backgroundColor: AppTheme.cardColor,
//           title: const Text('Confirm Logout'),
//           content: const SingleChildScrollView(
//             child: Text('Are you sure you want to log out?'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Log Out', style: TextStyle(color: AppTheme.errorColor)),
//               onPressed: () {
//                 if (state.status != ProfileStatus.loading) {
//                   context.read<ProfileViewModel>().add(const Logout());
//                   Navigator.of(dialogContext).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text('My Profile'),
//         actions: const [],
//       ),
//       body: BlocConsumer<ProfileViewModel, ProfileState>(
//         listener: (context, state) {
//           if (state.didLogOut) {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                 builder: (context) => const LoginScreen(
//                   showLogoutSuccessSnackbar: true,
//                 ),
//               ),
//               (route) => false,
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state.status == ProfileStatus.loading && state.profile == null) {
//             return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
//           }
//           if (state.status == ProfileStatus.success && state.profile != null) {
//             return _buildProfileContent(context, state.profile!, state);
//           }
//           if (state.status == ProfileStatus.failure) {
//             return Center(child: Text(state.errorMessage ?? 'An unknown error occurred.', style: AppTheme.bodyStyle));
//           }
//           return const Center(child: Text('An unknown error occurred.'));
//         },
//       ),
//     );
//   }

//   Widget _buildProfileContent(BuildContext context, ProfileEntity profile, ProfileState state) {
//     final double totalSpent = profile.orders.fold(0.0, (sum, order) => sum + order.totalAmount);
//     final bool canChangePassword = profile.user.authProvider?.trim().toLowerCase() == 'credentials';

//     void navigateToEditProfile() {
//       final editProfileViewModel = serviceLocator<EditProfileViewModel>(param1: profile.user);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => EditProfileView(
//             viewModel: editProfileViewModel,
//             initialFName: profile.user.fName,
//             initialLName: profile.user.lName,
//             email: profile.user.email,
//           ),
//         ),
//       ).then((_) {
//         context.read<ProfileViewModel>().add(LoadProfile());
//       });
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildProfileHeader(context, profile, onEdit: navigateToEditProfile),
//           const SizedBox(height: 24),
//           _buildStatsRow(context, profile, totalSpent),
//           const SizedBox(height: 24),
//           _buildMenuSection(context, 'Account', [
//             _MenuItem(
//               icon: Icons.person_outline,
//               title: 'Personal Information',
//               onTap: navigateToEditProfile,
//             ),
//             if (canChangePassword)
//               _MenuItem(
//                 icon: Icons.lock_outline,
//                 title: 'Change Password',
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordView())),
//               ),
//           ]),
//           const SizedBox(height: 16),
//           _buildMenuSection(context, 'Orders', [
//             _MenuItem(
//               icon: Icons.shopping_bag_outlined,
//               title: 'Order History',
//               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryView(orders: profile.orders))),
//             ),
//           ]),
//           const SizedBox(height: 24),
//           AnimatedButton(
//             text: 'Log Out',
//             icon: Icons.logout,
//             isLoading: state.status == ProfileStatus.loading && !state.didLogOut,
//             onPressed: () => _showLogoutConfirmationDialog(context, state),
//             backgroundColor: AppTheme.errorColor,
//             textColor: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader(BuildContext context, ProfileEntity profile, {required VoidCallback onEdit}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//       decoration: BoxDecoration(
//         color: AppTheme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 45,
//             backgroundColor: AppTheme.primaryColor,
//             child: Text(
//               profile.user.fName.isNotEmpty ? profile.user.fName[0].toUpperCase() : 'U',
//               style: AppTheme.headingStyle.copyWith(color: Colors.black, fontSize: 40),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             '${profile.user.fName} ${profile.user.lName}',
//             style: AppTheme.subheadingStyle.copyWith(fontSize: 20),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             profile.user.email,
//             style: AppTheme.captionStyle,
//           ),
//           const SizedBox(height: 20),
//           AnimatedButton(
//             text: 'Edit Profile',
//             onPressed: onEdit,
//             height: 48,
//             width: 200,
//             backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
//             textColor: AppTheme.primaryColor,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsRow(BuildContext context, ProfileEntity profile, double totalSpent) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatsCard(
//             context,
//             Icons.shopping_bag_outlined,
//             profile.orders.length.toString(),
//             'Orders',
//             () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryView(orders: profile.orders))),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: _buildStatsCard(
//             context,
//             Icons.account_balance_wallet_outlined,
//             'NPR. ${totalSpent.toStringAsFixed(0)}',
//             'Total Spent',
//             () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryView(orders: profile.orders))),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatsCard(BuildContext context, IconData icon, String value, String label, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           children: [
//             Icon(icon, color: AppTheme.primaryColor, size: 28),
//             const SizedBox(height: 8),
//             Text(value, style: AppTheme.subheadingStyle),
//             const SizedBox(height: 4),
//             Text(label, style: AppTheme.captionStyle),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuSection(BuildContext context, String title, List<_MenuItem> items) {
//     if (items.isEmpty) {
//       return const SizedBox.shrink();
//     }
//     return Container(
//       decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//             child: Text(title, style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
//           ),
//           const Divider(height: 1, color: Color(0xFF2C2C2C)),
//           ...items.map((item) {
//             return Column(
//               children: [
//                 ListTile(
//                   leading: Icon(item.icon, color: AppTheme.accentColor.withOpacity(0.8)),
//                   title: Text(item.title, style: AppTheme.bodyStyle),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 14),
//                   onTap: item.onTap,
//                 ),
//                 if (item != items.last) const Divider(height: 1, indent: 56, color: Color(0xFF2C2C2C)),
//               ],
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }

// class _MenuItem {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   _MenuItem({required this.icon, required this.title, required this.onTap});
// }














































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/animated_button.dart';
import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
import 'package:rolo/features/order/presentation/view/order_history_view.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';
import 'package:rolo/features/profile/presentation/view/change_password_view.dart';
import 'package:rolo/features/profile/presentation/view/edit_profile_view.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_viewmodel.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_event.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_state.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    // Dispatch event to load profile data when the screen is first built
    context.read<ProfileViewModel>().add(LoadProfile());
  }

  // Dialog to confirm if the user wants to log out
  Future<void> _showLogoutConfirmationDialog(BuildContext context, ProfileState state) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: const Text('Confirm Logout'),
          content: const SingleChildScrollView(child: Text('Are you sure you want to log out?')),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Log Out', style: TextStyle(color: AppTheme.errorColor)),
              onPressed: () {
                if (state.status != ProfileStatus.loading) {
                  context.read<ProfileViewModel>().add(const Logout());
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          // If the didLogOut flag is true, navigate to the login screen
          if (state.didLogOut) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen(showLogoutSuccessSnackbar: true)),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          // Show Lottie loading animation on initial load
          if (state.status == ProfileStatus.loading && state.profile == null) {
            return Center(child: Lottie.asset('assets/animations/loading.json', width: 150));
          }
          // If profile data (fresh or cached) is available, build the main content
          if (state.profile != null) {
            return _buildProfileContent(context, state.profile!, state);
          }
          // If loading fails, show a user-friendly error message
          if (state.status == ProfileStatus.failure) {
            return _buildErrorState(context, state.errorMessage ?? 'An unknown error occurred.');
          }
          // Fallback loader for any other transient states
          return Center(child: Lottie.asset('assets/animations/loading.json', width: 150));
        },
      ),
    );
  }

  /// Builds the main scrollable content of the profile page.
  Widget _buildProfileContent(BuildContext context, ProfileEntity profile, ProfileState state) {
    // These calculations work even when offline.
    // The cached ProfileEntity has an empty orders list, so totalSpent will be 0.
    final double totalSpent = profile.orders.fold(0.0, (sum, order) => sum + order.totalAmount);
    final bool canChangePassword = profile.user.authProvider?.trim().toLowerCase() == 'credentials';

    void navigateToEditProfile() {
      final editProfileViewModel = serviceLocator<EditProfileViewModel>(param1: profile.user);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditProfileView(
            viewModel: editProfileViewModel,
            initialFName: profile.user.fName,
            initialLName: profile.user.lName,
            email: profile.user.email,
          ),
        ),
      ).then((didUpdate) {
        // After returning from the edit screen, if a change was made, refresh the profile.
        if (didUpdate == true) {
          context.read<ProfileViewModel>().add(LoadProfile(isRefresh: true));
        }
      });
    }

    return RefreshIndicator(
      onRefresh: () async => context.read<ProfileViewModel>().add(LoadProfile(isRefresh: true)),
      color: AppTheme.primaryColor,
      backgroundColor: AppTheme.cardColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(context, profile, onEdit: navigateToEditProfile),
            const SizedBox(height: 24),
            _buildStatsRow(context, profile, totalSpent),
            const SizedBox(height: 24),
            _buildMenuSection(context, 'Account', [
              _MenuItem(icon: Icons.person_outline, title: 'Personal Information', onTap: navigateToEditProfile),
              if (canChangePassword)
                _MenuItem(icon: Icons.lock_outline, title: 'Change Password', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordView()))),
            ]),
            const SizedBox(height: 16),
            _buildMenuSection(context, 'Orders', [
              _MenuItem(icon: Icons.shopping_bag_outlined, title: 'Order History', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryView(orders: profile.orders)))),
            ]),
            const SizedBox(height: 24),
            AnimatedButton(
              text: 'Log Out',
              icon: Icons.logout,
              isLoading: state.status == ProfileStatus.loading && !state.didLogOut,
              onPressed: () => _showLogoutConfirmationDialog(context, state),
              backgroundColor: AppTheme.errorColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the top card with the user's avatar and name.
  Widget _buildProfileHeader(BuildContext context, ProfileEntity profile, {required VoidCallback onEdit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              profile.user.fName.isNotEmpty ? profile.user.fName[0].toUpperCase() : 'U',
              style: AppTheme.headingStyle.copyWith(color: Colors.black, fontSize: 40),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${profile.user.fName} ${profile.user.lName}',
            style: AppTheme.subheadingStyle.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(profile.user.email, style: AppTheme.captionStyle),
          const SizedBox(height: 20),
          AnimatedButton(
            text: 'Edit Profile',
            onPressed: onEdit,
            height: 48,
            width: 200,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
            textColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  /// Builds the row of statistics (Total Orders, Total Spent).
  Widget _buildStatsRow(BuildContext context, ProfileEntity profile, double totalSpent) {
    return Row(
      children: [
        Expanded(
          child: _buildStatsCard(
            context,
            Icons.shopping_bag_outlined,
            profile.orders.length.toString(),
            'Total Orders',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryView(orders: profile.orders))),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatsCard(
            context,
            Icons.account_balance_wallet_outlined,
            'NPR ${totalSpent.toStringAsFixed(0)}',
            'Total Spent',
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryView(orders: profile.orders))),
          ),
        ),
      ],
    );
  }

  /// Builds a single reusable card for a statistic.
  Widget _buildStatsCard(BuildContext context, IconData icon, String value, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(value, style: AppTheme.subheadingStyle),
            const SizedBox(height: 4),
            Text(label, style: AppTheme.captionStyle),
          ],
        ),
      ),
    );
  }

  /// Builds a section of menu items with a title.
  Widget _buildMenuSection(BuildContext context, String title, List<_MenuItem> items) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1, color: Color(0xFF2C2C2C)),
          ...items.map((item) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(item.icon, color: AppTheme.accentColor.withOpacity(0.8)),
                  title: Text(item.title, style: AppTheme.bodyStyle),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: item.onTap,
                ),
                if (item != items.last) const Divider(height: 1, indent: 56, color: Color(0xFF2C2C2C)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Builds the error state widget with a retry button.
  Widget _buildErrorState(BuildContext context, String message) {
     return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, color: Colors.grey, size: 80),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(message, style: AppTheme.bodyStyle, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<ProfileViewModel>().add(LoadProfile()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItem({required this.icon, required this.title, required this.onTap});
}