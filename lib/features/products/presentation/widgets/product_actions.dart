import 'package:ecommerceapp/features/products/presentation/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';

class ProductActions extends StatelessWidget {
  final ProductModel product;
  const ProductActions({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          context.read<CartCubit>().addToCart(product);
          CustomSnackBar.show(context);
        },
        child: const Text('Add to Cart'),
      ),
    );
  }
}
