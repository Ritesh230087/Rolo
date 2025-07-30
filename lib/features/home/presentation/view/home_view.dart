import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/product_card.dart';
import 'package:rolo/core/widgets/staggered_animation.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/presentation/view/featured_product_page.dart';
import 'package:rolo/features/home/presentation/view/ribbon_product_page.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_state.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _bannerController;
  late Animation<double> _bannerSlideAnimation;
  late Animation<double> _bannerFadeAnimation;

  @override
  void initState() {
    super.initState();
    _bannerController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _bannerSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(parent: _bannerController, curve: Curves.easeOutCubic));
    _bannerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _bannerController, curve: Curves.easeIn));

    context.read<HomeViewModel>().add(LoadHomeData());
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _bannerController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocConsumer<HomeViewModel, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            _startAnimations();
          }
        },
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor));
          } else if (state is HomeLoaded) {
            return _buildAnimatedHomeContent(context, state.homeData);
          } else if (state is HomeError) {
            return Center(child: Text(state.message, style: AppTheme.bodyStyle));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAnimatedHomeContent(BuildContext context, HomeEntity homeData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(opacity: value, child: _buildSearchBar()),
              );
            },
          ),

          const SizedBox(height: 24),
          _buildAnimatedBanner(),
          const SizedBox(height: 32),

          if (homeData.featuredProducts.isNotEmpty)
            StaggeredAnimation(
              delay: const Duration(milliseconds: 150),
              children: [
                _buildSectionHeader(
                  context,
                  'Featured Products',
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeaturedProductsPage(products: homeData.featuredProducts),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildProductCarousel(
                  context,
                  homeData.featuredProducts.take(7).toList(),
                ),
              ],
            ),

          const SizedBox(height: 32),

          ...homeData.ribbonSections.map((section) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: StaggeredAnimation(
                delay: const Duration(milliseconds: 200),
                children: [
                  _buildSectionHeader(
                    context,
                    section.ribbon.label,
                    onSeeAll: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RibbonProductsPage(
                            ribbonId: section.ribbon.id,
                            ribbonLabel: section.ribbon.label,
                            products: section.products,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildProductCarousel(
                    context,
                    section.products.take(7).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
          
          if (homeData.featuredProducts.isEmpty && homeData.ribbonSections.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Center(
                child: Text(
                  "No products found.",
                  style: AppTheme.subheadingStyle.copyWith(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5)),
        ],
      ),
      child: TextField(
        onChanged: (query) {
          context.read<HomeViewModel>().add(SearchHomeProducts(query));
        },
        decoration: InputDecoration(
          hintText: 'Search for authentic crafts...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  Widget _buildAnimatedBanner() {
    return AnimatedBuilder(
      animation: _bannerController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bannerSlideAnimation.value),
          child: Opacity(
            opacity: _bannerFadeAnimation.value,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.cardColor, AppTheme.backgroundColor],
                ),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10))
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.1),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.accentColor],
                          ).createShader(bounds),
                          child: const Text(
                            'Discover Authentic\nNepalese Crafts',
                            style: TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.8)
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5))
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Text('Shop Now',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.subheadingStyle),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See All', style: TextStyle(color: AppTheme.primaryColor)),
          ),
      ],
    );
  }

  Widget _buildProductCarousel(BuildContext context, List<ProductEntity> products) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 800 + (index * 200)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(50 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ProductCard(product: products[index]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}