import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
}

const CACHED_CART = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final jsonString = sharedPreferences.getString(CACHED_CART);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) => CartItemModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(CACHED_CART, jsonString);
  }
}
