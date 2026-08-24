import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../shared/widgets/product_card.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const LoadingWidget();
          } else if (state is WishlistError) {
            return Center(child: Text(state.message));
          } else if (state is WishlistLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Your wishlist is empty', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return ProductCard(product: state.items[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
