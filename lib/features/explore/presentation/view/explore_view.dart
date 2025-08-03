// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rolo/app/themes/themes_data.dart';
// import 'package:rolo/core/widgets/product_card.dart'; 
// import 'package:rolo/features/explore/presentation/view_model/explore_event.dart';
// import 'package:rolo/features/explore/presentation/view_model/explore_state.dart';
// import 'package:rolo/features/explore/presentation/view_model/explore_viewmodel.dart';

// class ExploreView extends StatefulWidget {
//   const ExploreView({super.key});

//   @override
//   State<ExploreView> createState() => _ExploreViewState();
// }

// class _ExploreViewState extends State<ExploreView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ExploreViewModel>().add(LoadExploreData());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text('Explore'),
//         elevation: 0,
//         backgroundColor: AppTheme.backgroundColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           _buildFilterControls(),
//           Expanded(
//             child: BlocBuilder<ExploreViewModel, ExploreState>(
//               builder: (context, state) {
//                 if (state.status == ExploreStatus.loading || state.status == ExploreStatus.initial) {
//                   return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
//                 }
//                 if (state.status == ExploreStatus.failure) {
//                   return Center(child: Text(state.errorMessage, style: AppTheme.bodyStyle));
//                 }
//                 if (state.filteredProducts.isEmpty) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Text('No products match your criteria.', style: AppTheme.captionStyle, textAlign: TextAlign.center),
//                     ),
//                   );
//                 }
//                 return _buildProductGrid(state);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterControls() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       child: Column(
//         children: [
//           _buildSearchBar(),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildCategoryChips()),
//               const SizedBox(width: 8),
//               _buildSortButton(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return TextField(
//       onChanged: (query) {
//         context.read<ExploreViewModel>().add(SearchQueryChanged(query));
//       },
//       decoration: InputDecoration(
//         hintText: 'Search products...',
//         prefixIcon: const Icon(Icons.search, color: Colors.grey),
//         isDense: true,
//         filled: true,
//         fillColor: AppTheme.cardColor,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryChips() {
//     return BlocBuilder<ExploreViewModel, ExploreState>(
//       buildWhen: (previous, current) =>
//           previous.categories != current.categories ||
//           previous.selectedCategoryId != current.selectedCategoryId,
//       builder: (context, state) {
//         return SizedBox(
//           height: 35,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: state.categories.length + 1, 
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 final isSelected = state.selectedCategoryId == null;
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: ChoiceChip(
//                     label: const Text('All'),
//                     selected: isSelected,
//                     onSelected: (selected) {
//                       context.read<ExploreViewModel>().add(const CategoryFilterChanged(null));
//                     },
//                     selectedColor: AppTheme.primaryColor,
//                     labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
//                     backgroundColor: AppTheme.cardColor,
//                   ),
//                 );
//               }
//               final category = state.categories[index - 1];
//               final isSelected = state.selectedCategoryId == category.id;
//               return Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: ChoiceChip(
//                   label: Text(category.name),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     final newCategoryId = isSelected ? null : category.id;
//                     context.read<ExploreViewModel>().add(CategoryFilterChanged(newCategoryId));
//                   },
//                   selectedColor: AppTheme.primaryColor,
//                   labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
//                   backgroundColor: AppTheme.cardColor,
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSortButton() {
//     return BlocBuilder<ExploreViewModel, ExploreState>(
//       builder: (context, state) {
//         return PopupMenuButton<SortOption>(
//           onSelected: (option) {
//             context.read<ExploreViewModel>().add(SortOrderChanged(option));
//           },
//           itemBuilder: (context) => [
//             const PopupMenuItem(value: SortOption.none, child: Text('Default')),
//             const PopupMenuItem(value: SortOption.priceLowToHigh, child: Text('Price: Low to High')),
//             const PopupMenuItem(value: SortOption.priceHighToLow, child: Text('Price: High to Low')),
//             const PopupMenuItem(value: SortOption.byDiscount, child: Text('By Discount')),
//           ],
//           icon: const Icon(Icons.sort, color: AppTheme.primaryColor),
//           color: AppTheme.cardColor,
//         );
//       },
//     );
//   }

//   Widget _buildProductGrid(ExploreState state) {
//     return GridView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       itemCount: state.filteredProducts.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.65, 
//       ),
//       itemBuilder: (context, index) {
//         final product = state.filteredProducts[index];
//         return ProductCard(product: product);
//       },
//     );
//   }
// }












































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:rolo/app/themes/themes_data.dart';
import 'package:rolo/core/widgets/product_card.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_event.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_state.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<ExploreViewModel>().add(const LoadExploreData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to update search status based on the text field's content
  void _onSearchChanged(String query) {
    // Dispatch event to the ViewModel to filter the products
    context.read<ExploreViewModel>().add(SearchQueryChanged(query));
    
    // Update the local UI state to switch between "browse" and "search" layouts
    if (query.isNotEmpty && !_isSearching) {
      setState(() {
        _isSearching = true;
      });
    } else if (query.isEmpty && _isSearching) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<ExploreViewModel, ExploreState>(
        builder: (context, state) {
          if (state.status == ExploreStatus.loading) {
            return Center(child: Lottie.asset('assets/animations/loading.json', width: 150));
          }
          if (state.status == ExploreStatus.failure) {
            return _buildErrorState(context, state.errorMessage);
          }
          
          return Column(
            children: [
              _buildSearchBar(),
              // ** DUAL UI LOGIC **
              // If the user is searching, show search results.
              // Otherwise, show the default browsing UI with filters.
              Expanded(
                child: _isSearching
                    ? _buildSearchResultsUI(state)
                    : _buildBrowseUI(state),
              ),
            ],
          );
        },
      ),
    );
  }

  // The main UI for browsing all products with filters
  Widget _buildBrowseUI(ExploreState state) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildFilterRow(),
        const SizedBox(height: 8),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => context.read<ExploreViewModel>().add(const LoadExploreData(isRefresh: true)),
            color: AppTheme.primaryColor,
            backgroundColor: AppTheme.cardColor,
            child: state.filteredProducts.isEmpty
                ? const Center(child: Text('No products match your criteria.', style: AppTheme.captionStyle))
                : _buildProductGrid(state.filteredProducts),
          ),
        ),
      ],
    );
  }

  // The main UI for showing search results (inspired by your SearchView)
  Widget _buildSearchResultsUI(ExploreState state) {
    if (state.filteredProducts.isEmpty) {
      // Automatically generate recommendations from the master list
      List<ProductEntity> recommendations = List.from(state.allProducts);
      recommendations.sort((a, b) => (b.discountPercent ?? 0).compareTo(a.discountPercent ?? 0));
      recommendations = recommendations.take(4).toList();
      
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: [
                Lottie.asset('assets/animations/search_not_found.json', width: 200),
                Text('No results for "${state.searchQuery}"', style: AppTheme.subheadingStyle),
                const SizedBox(height: 8),
                Text("Try searching for something else.", style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          ),
          _buildRecommendations(recommendations, 'You might also like'),
        ],
      );
    }
    // If there are results, show them in the same grid format
    return _buildProductGrid(state.filteredProducts);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: 48,
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          cursorColor: AppTheme.primaryColor,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
            filled: true,
            fillColor: AppTheme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.zero,
            // Show a clear button only when the user is searching
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: _buildCategoryChips()),
          const SizedBox(width: 8),
          _buildSortButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return BlocBuilder<ExploreViewModel, ExploreState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.selectedCategoryId != current.selectedCategoryId,
      builder: (context, state) {
        if (state.categories.isEmpty) {
          return const SizedBox(height: 38);
        }
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final isSelected = state.selectedCategoryId == null;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: isSelected,
                    onSelected: (_) => context.read<ExploreViewModel>().add(const CategoryFilterChanged(null)),
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                    backgroundColor: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }
              final category = state.categories[index - 1];
              final isSelected = state.selectedCategoryId == category.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (_) {
                    final newCategoryId = isSelected ? null : category.id;
                    context.read<ExploreViewModel>().add(CategoryFilterChanged(newCategoryId));
                  },
                  selectedColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                  backgroundColor: AppTheme.cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSortButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: BlocBuilder<ExploreViewModel, ExploreState>(
        builder: (context, state) {
          return PopupMenuButton<SortOption>(
            onSelected: (option) => context.read<ExploreViewModel>().add(SortOrderChanged(option)),
            itemBuilder: (context) => [
              const PopupMenuItem(value: SortOption.none, child: Text('Default')),
              const PopupMenuItem(value: SortOption.priceLowToHigh, child: Text('Price: Low to High')),
              const PopupMenuItem(value: SortOption.priceHighToLow, child: Text('Price: High to Low')),
              const PopupMenuItem(value: SortOption.byDiscount, child: Text('By Discount')),
            ],
            icon: const Icon(Icons.sort, color: AppTheme.primaryColor),
            color: AppTheme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<ProductEntity> products) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: (MediaQuery.of(context).size.width / 220).floor(),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: ProductCard(product: product),
              ),
            ),
          );
        },
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: AppTheme.subheadingStyle),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            onPressed: () => context.read<ExploreViewModel>().add(const LoadExploreData()),
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