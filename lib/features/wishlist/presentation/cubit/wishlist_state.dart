import 'package:equatable/equatable.dart';
import '../../../products/data/models/product_model.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<ProductModel> items;

  const WishlistLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class WishlistError extends WishlistState {
  final String message;
  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}
