import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

abstract class OrdersLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);
}

const CACHED_ORDERS = 'CACHED_ORDERS';

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  final SharedPreferences sharedPreferences;

  OrdersLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<OrderModel>> getOrders() async {
    final jsonString = sharedPreferences.getString(CACHED_ORDERS);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) => OrderModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    final orders = await getOrders();
    orders.insert(0, order);
    final jsonString = json.encode(orders.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(CACHED_ORDERS, jsonString);
  }
}
