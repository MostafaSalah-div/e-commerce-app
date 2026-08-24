import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/wishlist_repository.dart';
import '../../../products/data/models/product_model.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository wishlistRepository;

  WishlistCubit(this.wishlistRepository) : super(WishlistInitial());

  Future<void> getWishlist() async {
    emit(WishlistLoading());
    final result = await wishlistRepository.getWishlistItems();
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (items) => emit(WishlistLoaded(items)),
    );
  }

  Future<void> toggleWishlist(ProductModel product) async {
    final result = await wishlistRepository.toggleWishlist(product);
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (_) => getWishlist(),
    );
  }

  Future<bool> isInWishlist(int productId) async {
    final result = await wishlistRepository.isInWishlist(productId);
    return result.getOrElse(() => false);
  }
}
