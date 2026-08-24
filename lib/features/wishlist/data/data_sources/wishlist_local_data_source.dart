import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../products/data/models/product_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<ProductModel>> getWishlist();
  Future<void> saveWishlist(List<ProductModel> items);
}

const CACHED_WISHLIST = 'CACHED_WISHLIST';

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final SharedPreferences sharedPreferences;

  WishlistLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ProductModel>> getWishlist() async {
    final jsonString = sharedPreferences.getString(CACHED_WISHLIST);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) => ProductModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> saveWishlist(List<ProductModel> items) async {
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(CACHED_WISHLIST, jsonString);
  }
}
