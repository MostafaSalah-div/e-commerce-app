import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../products/data/models/product_model.dart';
import '../data/models/cart_item_model.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemModel>>> getCartItems();
  Future<Either<Failure, void>> addToCart(ProductModel product);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> updateQuantity(int productId, int quantity);
  Future<Either<Failure, void>> clearCart();
}
