import 'package:flutter/material.dart';

class CategoryHelper {
  /// Returns a specific icon for each category from DummyJSON.
  /// Mapping based on user requirements.
  static IconData getCategoryIcon(String categoryName) {
    final normalized = categoryName.toLowerCase().trim().replaceAll(' ', '-').replaceAll('_', '-');
    
    switch (normalized) {
      case 'beauty':
        return Icons.face_retouching_natural;
      case 'fragrances':
        return Icons.spa;
      case 'furniture':
        return Icons.weekend;
      case 'groceries':
        return Icons.shopping_basket;
      case 'home-decoration':
        return Icons.home;
      case 'laptops':
        return Icons.laptop;
      case 'smartphones':
        return Icons.smartphone;
      case 'mens-shoes':
        return Icons.directions_walk;
      case 'womens-shoes':
        return Icons.shopping_bag;
      case 'mens-shirts':
        return Icons.checkroom;
      case 'womens-dresses':
        return Icons.checkroom;
      case 'automotive':
        return Icons.directions_car;
      case 'motorcycle':
        return Icons.motorcycle;
      case 'lighting':
        return Icons.lightbulb;
      case 'skin-care':
        return Icons.clean_hands;
      case 'sunglasses':
        return Icons.wb_sunny;
      case 'tops':
        return Icons.checkroom;
      default:
        // Keywords fallback for dynamic categories
        if (normalized.contains('shoe')) return Icons.directions_walk;
        if (normalized.contains('watch')) return Icons.watch;
        if (normalized.contains('shirt') || normalized.contains('dress') || normalized.contains('clothing')) return Icons.checkroom;
        if (normalized.contains('car') || normalized.contains('auto')) return Icons.directions_car;
        if (normalized.contains('phone') || normalized.contains('mobile')) return Icons.smartphone;
        if (normalized.contains('computer') || normalized.contains('laptop')) return Icons.laptop;
        
        return Icons.category;
    }
  }
}
