import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/theme/app_theme.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const LoadingWidget();
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Your cart is empty', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.thumbnail,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '\$${item.product.price}',
                                      style: const TextStyle(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () {
                                      context.read<CartCubit>().updateQuantity(
                                          item.product.id, item.quantity - 1);
                                    },
                                  ),
                                  Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: () {
                                      context.read<CartCubit>().updateQuantity(
                                          item.product.id, item.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal:'),
                            Text('\$${state.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount:'),
                            Text(
                              '-\$${state.discount.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              '\$${state.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => context.push('/checkout'),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ],
                    ),
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
