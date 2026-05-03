class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final String category;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isNew;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.category,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isNew = false,
  });

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  bool get hasDiscount => discountPercent > 0;
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.productCount = 0,
  });
}
