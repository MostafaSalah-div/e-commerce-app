import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {
  final bool refresh;
  const LoadProducts({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class LoadProductsByCategory extends ProductsEvent {
  final String category;
  final bool refresh;
  const LoadProductsByCategory(this.category, {this.refresh = false});

  @override
  List<Object?> get props => [category, refresh];
}

class LoadMoreProducts extends ProductsEvent {}

class SearchProductsEvent extends ProductsEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
