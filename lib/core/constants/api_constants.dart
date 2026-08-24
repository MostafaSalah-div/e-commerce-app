class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String products = '/products';
  static const String categories = '/products/categories';
  static const String search = '/products/search';
  static const String login = '/auth/login';
  static const String register = '/users/add';
  
  static String productsByCategory(String category) => '/products/category/$category';
}
