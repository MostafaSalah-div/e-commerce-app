import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/product_model.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../widgets/product_info.dart';
import '../widgets/product_actions.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              final isInWishlist = state is WishlistLoaded &&
                  state.items.any((item) => item.id == product.id);
              return IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<WishlistCubit>().toggleWishlist(product);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ProductInfo(product: product),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductActions(product: product),
    );
  }
}
