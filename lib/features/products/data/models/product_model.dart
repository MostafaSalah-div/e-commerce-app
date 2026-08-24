import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'],
      brand: json['brand'] ?? '',
      category: json['category'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        discountPercentage,
        rating,
        stock,
        brand,
        category,
        thumbnail,
        images,
      ];
}

class ProductResponseModel extends Equatable {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      products: (json['products'] as List)
          .map((i) => ProductModel.fromJson(i))
          .toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}
