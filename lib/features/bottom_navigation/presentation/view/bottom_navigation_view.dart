// import 'package:flutter/material.dart';
// import 'package:rolo/app/themes/themes_data.dart'; 

// class BottomNavigationView extends StatefulWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const BottomNavigationView({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   State<BottomNavigationView> createState() => _BottomNavigationViewState();
// }

// class _BottomNavigationViewState extends State<BottomNavigationView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, 100 * (1 - _animation.value)),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   AppTheme.backgroundColor.withOpacity(0.9),
//                   AppTheme.backgroundColor,
//                 ],
//               ),
//               border: const Border(
//                 top: BorderSide(color: Color(0xFF2C2C2C), width: 1),
//               ),
//             ),
//             child: BottomNavigationBar(
//               currentIndex: widget.currentIndex, 
//               onTap: widget.onTap, 
//               backgroundColor: Colors.transparent,
//               selectedItemColor: AppTheme.primaryColor,
//               unselectedItemColor: Colors.grey,
//               type: BottomNavigationBarType.fixed,
//               showSelectedLabels: true,
//               showUnselectedLabels: true,
//               elevation: 0,
//               items: [
//                 _buildBottomNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
//                 _buildBottomNavItem(Icons.search_outlined, Icons.search, 'Explore', 1),
//                 _buildBottomNavItem(Icons.shopping_cart_outlined, Icons.shopping_cart, 'Cart', 2),
//                 _buildBottomNavItem(Icons.person_outline, Icons.person, 'Profile', 3),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   BottomNavigationBarItem _buildBottomNavItem(
//     IconData inactiveIcon,
//     IconData activeIcon,
//     String label,
//     int index,
//   ) {
//     return BottomNavigationBarItem(
//       icon: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 200),
//         child: widget.currentIndex == index 
//             ? Container(
//                 key: ValueKey('active_$index'),
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(activeIcon, color: AppTheme.primaryColor),
//               )
//             : Icon(inactiveIcon, key: ValueKey('inactive_$index')),
//       ),
//       label: label,
//     );
//   }
// }















































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/services/cart_animation_service.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_state.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';

class BottomNavigationView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationView({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          _buildBottomNavItem(Icons.home_filled, 'Home', 0),
          _buildBottomNavItem(Icons.explore_outlined, 'Explore', 1),
          _buildCartNavItem(context), // Special builder for cart item
          _buildBottomNavItem(Icons.person_outline, 'Profile', 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    bool isSelected = currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey.shade600),
      ),
      label: label,
    );
  }

  // **THIS IS THE NEW, CORRECTED CART ICON WIDGET**
  BottomNavigationBarItem _buildCartNavItem(BuildContext context) {
    bool isSelected = currentIndex == 2;
    return BottomNavigationBarItem(
      label: 'Cart',
      icon: BlocBuilder<CartViewModel, CartState>(
        builder: (context, state) {
          final itemCount = state.cart.items.length;
          // The Stack allows us to place the badge over the icon
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // This is the main icon container
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                // **THE FIX**: The key is attached to the Icon itself, which always exists.
                child: Icon(
                  key: CartAnimationService.cartKey,
                  isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey.shade600,
                ),
              ),
              // This is the badge, which only appears if items are in the cart
              if (itemCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}