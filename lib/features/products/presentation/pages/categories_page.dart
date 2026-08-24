import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/category_helper.dart';
import '../../../../shared/widgets/product_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const LoadingWidget();
          } else if (state is CategoryError) {
            return Center(child: Text(state.message));
          } else if (state is CategoryLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.categories.length + 1,
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final category = isAll ? null : state.categories[index - 1];
                      final isSelected = state.selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          avatar: Icon(
                            isAll ? Icons.grid_view : CategoryHelper.getCategoryIcon(category!),
                            size: 18,
                            color: isSelected ? Colors.white : Colors.blue,
                          ),
                          label: Text(isAll ? 'All' : category!),
                          selected: isSelected,
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              context.read<CategoryCubit>().selectCategory(category);
                              if (isAll) {
                                context.read<ProductsBloc>().add(const LoadProducts());
                              } else {
                                context.read<ProductsBloc>().add(LoadProductsByCategory(category!));
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      if (state.status == ProductsStatus.loading) {
                        return const LoadingWidget();
                      } else if (state.status == ProductsStatus.failure) {
                        return Center(child: Text(state.errorMessage ?? 'Error'));
                      } else if (state.products.isEmpty) {
                        return const Center(child: Text('No products for this category'));
                      }
                      
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: state.products[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
