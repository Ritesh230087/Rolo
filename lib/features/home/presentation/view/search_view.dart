import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/product_card.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_state.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:lottie/lottie.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.cardColor,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
        elevation: 1,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: AppTheme.primaryColor,
          onChanged: (query) => context.read<HomeViewModel>().add(SearchHomeProducts(query)),
          decoration: InputDecoration(
            hintText: 'Search authentic crafts...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      context.read<HomeViewModel>().add(const SearchHomeProducts(''));
                    },
                  )
                : null,
          ),
        ),
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state is HomeSearchState && state.query.isNotEmpty) {
            if (state.searchResults.isEmpty) {
              return _buildNoResultsState(context, state.query, state.recommendedProducts);
            }
            return _buildResults(context, state);
          }
          return _buildInitialState(context);
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final homeViewModel = context.read<HomeViewModel>();
    final suggestions = homeViewModel.originalHomeData?.featuredProducts ?? [];
    
    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Search for Products", style: AppTheme.subheadingStyle),
            Text("Find the perfect craft just for you.", style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Featured Suggestions", style: AppTheme.subheadingStyle),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestions.length > 4 ? 4 : suggestions.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) => ProductCard(product: suggestions[index]),
        ),
      ],
    );
  }

  Widget _buildNoResultsState(BuildContext context, String query, List<ProductEntity> recommendations) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Lottie.asset('assets/animations/search_not_found.json', width: 200),
              Text('No results for "$query"', style: AppTheme.subheadingStyle),
              const SizedBox(height: 8),
              Text("Try searching for something else.", style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
        _buildRecommendations(recommendations, 'You might also like'),
      ],
    );
  }

  Widget _buildResults(BuildContext context, HomeSearchState state) {
    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text('Results for "${state.query}"', style: AppTheme.subheadingStyle),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.searchResults.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: (MediaQuery.of(context).size.width / 220).floor(),
                child: ScaleAnimation(
                  child: FadeInAnimation(child: ProductCard(product: state.searchResults[index])),
                ),
              );
            },
          ),
          _buildRecommendations(state.recommendedProducts, 'Recommended for you'),
        ],
      ),
    );
  }

  Widget _buildRecommendations(List<ProductEntity> products, String title) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(title, style: AppTheme.subheadingStyle),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16.0),
                child: ProductCard(product: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}