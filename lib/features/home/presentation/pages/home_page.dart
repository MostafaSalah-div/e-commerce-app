import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/presentation/bloc/products_bloc.dart';
import '../../../products/presentation/bloc/products_event.dart';
import '../../../products/presentation/bloc/products_state.dart';
import '../../../products/presentation/cubit/category_cubit.dart';
import '../../../products/presentation/cubit/category_state.dart';
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
  final ScrollController _scrollController = ScrollController();

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
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductsBloc>().add(const LoadProducts(refresh: true));
            context.read<CategoryCubit>().getCategories();
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
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryItem(state.categories[index]);
                          },
                        ),
                      );
                    }
                    return const SizedBox(height: 100);
                  },
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

  Widget _buildCategoryItem(String category) {
    return GestureDetector(
      onTap: () {
        context.read<ProductsBloc>().add(LoadProductsByCategory(category));
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                CategoryHelper.getCategoryIcon(category),
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
