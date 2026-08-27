import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/presentation/bloc/products_bloc.dart';
import '../../../products/presentation/bloc/products_event.dart';
import '../../../products/presentation/bloc/products_state.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/category_helper.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_banner.dart';
import '../../../../shared/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = -1;
  final ScrollController _scrollController = ScrollController();

  final List<String> _staticCategories = [
    'beauty',
    'fragrances',
    'furniture',
    'groceries',
    'home-decoration',
    'laptops',
    'mens-shoes',
    'mens-watches',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(const LoadProducts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) context.read<ProductsBloc>().add(LoadMoreProducts());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductsBloc>().add(const LoadProducts(refresh: true));
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: HomeHeader()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    onChanged: (value) {
                      if (value.length > 2) {
                        context.read<ProductsBloc>().add(SearchProductsEvent(value));
                      } else if (value.isEmpty) {
                        context.read<ProductsBloc>().add(const LoadProducts());
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: PromoBanner()),
              SliverToBoxAdapter(
                child: _buildSectionTitle('Categories', () {
                  // Navigation handled by MainPage
                }),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _staticCategories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryItem(index, _staticCategories[index], colorScheme, textTheme);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildSectionTitle('Popular Products', null)),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state.status == ProductsStatus.loading && state.products.isEmpty) {
                    return const SliverFillRemaining(child: LoadingWidget());
                  }
                  if (state.status == ProductsStatus.failure) {
                    return SliverFillRemaining(child: Center(child: Text(state.errorMessage ?? 'Error')));
                  }
                  
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.products.length) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ProductCard(product: state.products[index]);
                        },
                        childCount: state.hasReachedMax ? state.products.length : state.products.length + 1,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (onTap != null)
            TextButton(onPressed: onTap, child: const Text('See All')),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(int index, String category, ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
        context.read<ProductsBloc>().add(LoadProductsByCategory(category));
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedCategoryIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  CategoryHelper.getCategoryIcon(category),
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: _selectedCategoryIndex == index ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
