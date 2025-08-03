// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:lottie/lottie.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/core/widgets/product_card.dart';
// import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_event.dart';
// import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_viewmodel.dart';
// import 'package:rolo/features/home/domain/entity/home_entity.dart';
// import 'package:rolo/features/home/presentation/view/featured_product_page.dart';
// import 'package:rolo/features/home/presentation/view/ribbon_product_page.dart';
// import 'package:rolo/features/home/presentation/view/search_view.dart';
// import 'package:rolo/features/home/presentation/view_model/home_event.dart';
// import 'package:rolo/features/home/presentation/view_model/home_state.dart';
// import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<HomeViewModel>().add(const LoadHomeData());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: BlocBuilder<HomeViewModel, HomeState>(
//         buildWhen: (prev, current) => current is! HomeSearchState,
//         builder: (context, state) {
//           if (state is HomeLoading && state.isFirstLoad) {
//             return Center(child: Lottie.asset('assets/animations/loading.json', width: 150));
//           }

//           if (state is HomeError) {
//             return _buildErrorState(context, state.message);
//           }

//           HomeEntity? homeData;
//           if (state is HomeLoaded) homeData = state.homeData;
//           if (state is HomeLoading) homeData = state.existingData;

//           if (homeData == null) {
//             return Center(child: Lottie.asset('assets/animations/loading.json', width: 150));
//           }

//           return RefreshIndicator(
//             onRefresh: () async => context.read<HomeViewModel>().add(const LoadHomeData(isRefresh: true)),
//             color: AppTheme.primaryColor,
//             backgroundColor: AppTheme.cardColor,
//             child: ListView(
//               padding: const EdgeInsets.only(top: 16),
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: _buildSearchBar(context),
//                 ),
//                 _buildBannerCarousel(context),
//                 if (homeData.featuredProducts.isNotEmpty)
//                   _buildSection(context, 'Featured Products', homeData.featuredProducts,
//                       () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeaturedProductsPage(products: homeData!.featuredProducts)))),
//                 ...homeData.ribbonSections.map((section) => _buildSection(context, section.ribbon.label, section.products,
//                       () => Navigator.push(context, MaterialPageRoute(builder: (_) => RibbonProductsPage(ribbonId: section.ribbon.id, ribbonLabel: section.ribbon.label, products: section.products))))),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSearchBar(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(value: BlocProvider.of<HomeViewModel>(context), child: const SearchView())));
//       },
//       child: Container(
//         height: 52,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           color: AppTheme.cardColor,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.search, color: AppTheme.primaryColor),
//             const SizedBox(width: 12),
//             Text('Search products...', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ** THIS IS THE NEW BANNER CAROUSEL **
//   /// It now uses the `_buildImageBanner` method.
//   Widget _buildBannerCarousel(BuildContext context) {
//     // Define your banner images here
//     final List<String> bannerImagePaths = [
//       'assets/images/Rolo_first_banner.jpeg', // Make sure you have these images
//       'assets/images/Rolo_second_banner.jpeg',
//       'assets/images/Rolo_third_banner.jpeg',
//       'assets/images/Rolo_fourth_banner.jpeg',
//     ];

//     final List<Widget> bannerItems = bannerImagePaths.map((path) {
//       return _buildImageBanner(
//         context: context,
//         imagePath: path,
//         onTap: () {
//           // All banners will navigate to the Explore tab for now.
//           // You can customize this later if needed.
//           context.read<BottomNavigationViewModel>().add(const TabChanged(index: 1));
//         },
//       );
//     }).toList();

//     return CarouselSlider(
//       items: bannerItems,
//       options: CarouselOptions(
//         height: 180,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         viewportFraction: 0.85,
//         autoPlayInterval: const Duration(seconds: 4),
//         enlargeFactor: 0.2,
//       ),
//     );
//   }

//   /// ** THIS IS THE NEW BANNER WIDGET **
//   /// It displays an image from your assets and has no overlay text or buttons.
//   Widget _buildImageBanner({
//     required BuildContext context,
//     required String imagePath,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.symmetric(vertical: 24),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Image.asset(
//             imagePath,
//             fit: BoxFit.cover,
//             // Add an error builder for robustness in case the image is missing
//             errorBuilder: (context, error, stackTrace) {
//               return Container(
//                 color: AppTheme.cardColor,
//                 child: const Center(
//                   child: Icon(Icons.image_not_supported, color: Colors.grey),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(
//     BuildContext context,
//     String title,
//     List<ProductEntity> products,
//     VoidCallback onSeeAll,
//   ) {
//     if (products.isEmpty) {
//       return const SizedBox.shrink();
//     }
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(title, style: AppTheme.subheadingStyle),
//               TextButton(
//                 onPressed: onSeeAll,
//                 child: const Text('See All', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 300,
//           child: ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             scrollDirection: Axis.horizontal,
//             itemCount: products.length > 7 ? 7 : products.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 200,
//                 margin: const EdgeInsets.only(right: 16),
//                 child: ProductCard(product: products[index]),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 24),
//       ],
//     );
//   }

//   Widget _buildErrorState(BuildContext context, String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.cloud_off, color: Colors.grey, size: 80),
//           const SizedBox(height: 20),
//           Text(message, style: AppTheme.bodyStyle, textAlign: TextAlign.center),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => context.read<HomeViewModel>().add(const LoadHomeData()),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppTheme.primaryColor,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
// }











































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/product_card.dart';
import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_event.dart';
import 'package:rolo/features/bottom_navigation/presentation/view_model/bottom_navigation_viewmodel.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/presentation/view/featured_product_page.dart';
import 'package:rolo/features/home/presentation/view/ribbon_product_page.dart';
import 'package:rolo/features/home/presentation/view/search_view.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_state.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

/// The screen width in pixels above which the tablet layout for the banner will be used.
const double kTabletBannerBreakpoint = 600.0;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeViewModel>().add(const LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocBuilder<HomeViewModel, HomeState>(
        buildWhen: (prev, current) => current is! HomeSearchState,
        builder: (context, state) {
          if (state is HomeLoading && state.isFirstLoad) {
            return Center(child: Lottie.asset('assets/animations/loading.json', width: 150));
          }

          if (state is HomeError) {
            return _buildErrorState(context, state.message);
          }

          HomeEntity? homeData;
          if (state is HomeLoaded) homeData = state.homeData;
          if (state is HomeLoading) homeData = state.existingData;

          if (homeData == null) {
            return Center(child: Lottie.asset('assets/animations/loading.json', width: 150));
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<HomeViewModel>().add(const LoadHomeData(isRefresh: true)),
            color: AppTheme.primaryColor,
            backgroundColor: AppTheme.cardColor,
            child: ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildSearchBar(context),
                ),
                // This widget is now responsive.
                _buildBannerCarousel(context),
                if (homeData.featuredProducts.isNotEmpty)
                  _buildSection(context, 'Featured Products', homeData.featuredProducts,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeaturedProductsPage(products: homeData!.featuredProducts)))),
                ...homeData.ribbonSections.map((section) => _buildSection(context, section.ribbon.label, section.products,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => RibbonProductsPage(ribbonId: section.ribbon.id, ribbonLabel: section.ribbon.label, products: section.products))))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(value: BlocProvider.of<HomeViewModel>(context), child: const SearchView())));
      },
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Text('Search products...', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  /// ** THIS IS THE MODIFIED, RESPONSIVE BANNER WIDGET **
  Widget _buildBannerCarousel(BuildContext context) {
    // Define your banner images here
    final List<String> bannerImagePaths = [
      'assets/images/Rolo_first_banner.jpeg',
      'assets/images/Rolo_second_banner.jpeg',
      'assets/images/Rolo_third_banner.jpeg',
      'assets/images/Rolo_fourth_banner.jpeg',
    ];

    final List<Widget> bannerItems = bannerImagePaths.map((path) {
      return _buildImageBanner(
        context: context,
        imagePath: path,
        onTap: () {
          context.read<BottomNavigationViewModel>().add(const TabChanged(index: 1));
        },
      );
    }).toList();

    // FIX: Make CarouselOptions responsive.
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > kTabletBannerBreakpoint;

    final carouselOptions = isTablet
        ? CarouselOptions(
            height: 320, // Taller banner for tablets
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.7, // Show more of the banner on wider screens
            autoPlayInterval: const Duration(seconds: 4),
            enlargeFactor: 0.15, // A more subtle zoom effect for tablets
          )
        : CarouselOptions(
            height: 180, // Original height for phones
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85, // Original fraction for phones
            autoPlayInterval: const Duration(seconds: 4),
            enlargeFactor: 0.2,
          );

    return CarouselSlider(
      items: bannerItems,
      options: carouselOptions,
    );
  }

  // This helper widget remains unchanged.
  Widget _buildImageBanner({
    required BuildContext context,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppTheme.cardColor,
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // This widget remains unchanged.
  Widget _buildSection(
    BuildContext context,
    String title,
    List<ProductEntity> products,
    VoidCallback onSeeAll,
  ) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTheme.subheadingStyle),
              TextButton(
                onPressed: onSeeAll,
                child: const Text('See All', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: products.length > 7 ? 7 : products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                child: ProductCard(product: products[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // This widget remains unchanged.
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, color: Colors.grey, size: 80),
          const SizedBox(height: 20),
          Text(message, style: AppTheme.bodyStyle, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<HomeViewModel>().add(const LoadHomeData()),
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