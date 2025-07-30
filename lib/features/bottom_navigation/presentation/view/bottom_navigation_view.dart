import 'package:flutter/material.dart';
import 'package:rolo/app/themes/themes_data.dart'; 

class BottomNavigationView extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationView({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - _animation.value)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.backgroundColor.withOpacity(0.9),
                  AppTheme.backgroundColor,
                ],
              ),
              border: const Border(
                top: BorderSide(color: Color(0xFF2C2C2C), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: widget.currentIndex, 
              onTap: widget.onTap, 
              backgroundColor: Colors.transparent,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0,
              items: [
                _buildBottomNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
                _buildBottomNavItem(Icons.search_outlined, Icons.search, 'Explore', 1),
                _buildBottomNavItem(Icons.shopping_cart_outlined, Icons.shopping_cart, 'Cart', 2),
                _buildBottomNavItem(Icons.person_outline, Icons.person, 'Profile', 3),
              ],
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    IconData inactiveIcon,
    IconData activeIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: widget.currentIndex == index 
            ? Container(
                key: ValueKey('active_$index'),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(activeIcon, color: AppTheme.primaryColor),
              )
            : Icon(inactiveIcon, key: ValueKey('inactive_$index')),
      ),
      label: label,
    );
  }
}