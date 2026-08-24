import 'package:equatable/equatable.dart';
import '../../../cart/data/models/cart_item_model.dart';

class OrderModel extends Equatable {
  final String id;
  final DateTime date;
  final List<CartItemModel> items;
  final double total;
  final String address;
  final String paymentMethod;
  final String status;

  const OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List).map((i) => CartItemModel.fromJson(i)).toList(),
      total: json['total'],
      address: json['address'],
      paymentMethod: json['paymentMethod'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'total': total,
      'address': address,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, date, items, total, address, paymentMethod, status];
}
