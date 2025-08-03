import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/service_locator/service_locator.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
import 'package:rolo/features/bottom_navigation/presentation/view/bottom_navigation_view.dart';
import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_event.dart';
import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_state.dart';
import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_viewmodel.dart';
import 'package:rolo/features/cart/presentation/view/cart_view.dart';

import 'package:rolo/features/home/presentation/view/home_view.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/explore/presentation/view/explore_view.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_viewmodel.dart';
import 'package:rolo/features/profile/domain/use_case/logout_usecase.dart';
import 'package:rolo/features/profile/presentation/view/profile_view.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_state.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_viewmodel.dart';

import 'package:rolo/features/notification/presentation/view/notification_view.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_event.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_state.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_viewmodel.dart';
import 'package:rolo/services/shake_detection_service.dart';

class DashboardView extends StatefulWidget {
  final int? initialIndex;

  const DashboardView({
    super.key,
    this.initialIndex,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ShakeDetectionService _shakeService = ShakeDetectionService();

  final List<Widget> _screens = const [
    HomeView(),
    ExploreView(),
    CartView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    
    _shakeService.initialize(
      onShakeDetected: _handleShakeLogout,
    );
  }

  @override
  void dispose() {
    _shakeService.dispose();
    super.dispose();
  }

  void _handleShakeLogout() {
    _showLogoutConfirmation();
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Shake Detected',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          content: const Text(
            'Phone shake detected. Do you want to logout?',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );

      final logoutUsecase = serviceLocator<LogoutUsecase>();
      final result = await logoutUsecase.call();

      if (mounted) {
        Navigator.of(context).pop();
      }

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (success) {
          if (mounted) {
            print('Logout successful, navigating to login...');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false, 
            );
          }
        },
      );

    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      if (mounted) {
        print('Logout error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final startingIndex = widget.initialIndex ?? 0;
            return BottomNavigationViewModel()..add(TabChanged(index: startingIndex));
          },
        ),
        BlocProvider(create: (context) => serviceLocator<HomeViewModel>()),
        BlocProvider(create: (context) => serviceLocator<ExploreViewModel>()),
        BlocProvider(create: (context) => serviceLocator<ProfileViewModel>()),
        BlocProvider.value(
          value: serviceLocator<NotificationViewModel>()..add(LoadNotifications()),
        ),
      ],
      child: BlocBuilder<BottomNavigationViewModel, BottomNavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: state.index == 0 ? _buildHomeAppBar(context) : null,
            body: IndexedStack(
              index: state.index,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationView(
              currentIndex: state.index,
              onTap: (index) => context
                  .read<BottomNavigationViewModel>()
                  .add(TabChanged(index: index)),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildHomeAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/logo/rolo_logo.jpeg',
            height: 36,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported, color: Colors.red);
            },
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'ROLO',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
      actions: [
        BlocBuilder<NotificationViewModel, NotificationState>(
          builder: (context, notificationState) {
            return IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_outlined),
                  if (notificationState.unreadCount > 0)
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.backgroundColor, width: 1),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${notificationState.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<NotificationViewModel>(),
                      child: const NotificationView(),
                    ),
                  ),
                );
              },
              color: AppTheme.accentColor,
            );
          },
        ),
        BlocBuilder<ProfileViewModel, ProfileState>(
          builder: (context, profileState) {
            if (profileState.status == ProfileStatus.success &&
                profileState.profile != null) {
              final fName = profileState.profile!.user.fName;
              final initial = fName.isNotEmpty ? fName[0].toUpperCase() : '?';
              return Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 8.0),
                child: CircleAvatar(
                  backgroundColor: AppTheme.cardColor,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              );
            }
            return IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
              },
              color: AppTheme.accentColor,
            );
          },
        ),
      ],
    );
  }
}