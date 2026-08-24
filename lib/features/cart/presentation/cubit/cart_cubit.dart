import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/cart_repository.dart';
import '../../data/models/cart_item_model.dart';
import '../../../products/data/models/product_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;

  CartCubit(this.cartRepository) : super(CartInitial());

  Future<void> getCart() async {
    emit(CartLoading());
    final result = await cartRepository.getCartItems();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(_calculateTotals(items)),
    );
  }

  Future<void> addToCart(ProductModel product) async {
    final result = await cartRepository.addToCart(product);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => getCart(),
    );
  }

  Future<void> removeFromCart(int productId) async {
    final result = await cartRepository.removeFromCart(productId);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => getCart(),
    );
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final result = await cartRepository.updateQuantity(productId, quantity);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => getCart(),
    );
  }

  Future<void> clearCart() async {
    final result = await cartRepository.clearCart();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartLoaded(items: [], subtotal: 0, discount: 0, total: 0)),
    );
  }

  CartLoaded _calculateTotals(List<CartItemModel> items) {
    double subtotal = 0;
    double totalDiscount = 0;

    for (var item in items) {
      subtotal += item.product.price * item.quantity;
      totalDiscount += (item.product.price * (item.product.discountPercentage / 100)) * item.quantity;
    }

    return CartLoaded(
      items: items,
      subtotal: subtotal,
      discount: totalDiscount,
      total: subtotal - totalDiscount,
    );
  }
}
