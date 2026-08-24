import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double subtotal;
  final double discount;
  final double total;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  @override
  List<Object?> get props => [items, subtotal, discount, total];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
