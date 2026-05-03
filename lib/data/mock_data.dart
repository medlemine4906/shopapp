import '../models/product.dart';

class MockData {
  static const List<Category> categories = [
    Category(id: 'all',        name: 'Tout',       icon: '🏠', productCount: 24),
    Category(id: 'electronics',name: 'Électronique',icon: '📱', productCount: 8),
    Category(id: 'fashion',    name: 'Mode',        icon: '👗', productCount: 6),
    Category(id: 'home',       name: 'Maison',      icon: '🛋️', productCount: 5),
    Category(id: 'sports',     name: 'Sport',       icon: '⚽', productCount: 3),
    Category(id: 'food',       name: 'Alimentaire', icon: '🍎', productCount: 2),
  ];

  static const List<Product> products = [
    // Featured
    Product(
      id: 'p1',
      name: 'iPhone 15 Pro',
      description: 'Le smartphone le plus avancé d\'Apple avec puce A17 Pro, '
          'système de caméra pro et design en titane. Écran Super Retina XDR 6.1".',
      price: 1199.99,
      originalPrice: 1399.99,
      imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400',
      category: 'electronics',
      tags: ['Apple', 'Smartphone', '5G', 'Titane'],
      rating: 4.8,
      reviewCount: 342,
      isFeatured: true,
    ),
    Product(
      id: 'p2',
      name: 'MacBook Air M3',
      description: 'Ultra-fin et puissant. La puce M3 offre des performances '
          'exceptionnelles avec jusqu\'à 18h d\'autonomie. Écran Liquid Retina 13.6".',
      price: 1299.00,
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
      category: 'electronics',
      tags: ['Apple', 'Laptop', 'M3', 'Léger'],
      rating: 4.9,
      reviewCount: 218,
      isFeatured: true,
    ),
    Product(
      id: 'p3',
      name: 'AirPods Pro 2',
      description: 'Réduction active du bruit de qualité pro, audio spatial '
          'personnalisé et une autonomie de 30h avec l\'étui. Résistant à l\'eau.',
      price: 279.00,
      originalPrice: 329.00,
      imageUrl: 'https://images.unsplash.com/photo-1588423771073-b8903fead714?w=400',
      category: 'electronics',
      tags: ['Apple', 'Audio', 'ANC', 'Sans fil'],
      rating: 4.7,
      reviewCount: 891,
      isFeatured: true,
    ),

    // Regular grid
    Product(
      id: 'p4',
      name: 'Nike Air Max 270',
      description: 'Amorti maximum et style iconique. La grande unité Air au talon '
          'offre un confort incomparable pour une utilisation quotidienne.',
      price: 149.99,
      originalPrice: 179.99,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      category: 'fashion',
      tags: ['Nike', 'Running', 'Air Max'],
      rating: 4.5,
      reviewCount: 567,
      isNew: true,
    ),
    Product(
      id: 'p5',
      name: 'Samsung 4K OLED 55"',
      description: 'Couleurs parfaites et noirs absolus grâce à la technologie OLED. '
          'Smart TV avec Tizen OS, HDR10+ et son Dolby Atmos intégré.',
      price: 899.00,
      originalPrice: 1099.00,
      imageUrl: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829e1?w=400',
      category: 'electronics',
      tags: ['Samsung', '4K', 'OLED', 'Smart TV'],
      rating: 4.6,
      reviewCount: 203,
    ),
    Product(
      id: 'p6',
      name: 'Canapé Velours Bleu',
      description: 'Design contemporain en velours côtelé, pieds en chêne massif. '
          'Structure renforcée pour un confort durable. Coloris exclusif.',
      price: 549.00,
      imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
      category: 'home',
      tags: ['Déco', 'Velours', 'Scandinave'],
      rating: 4.4,
      reviewCount: 89,
      isNew: true,
    ),
    Product(
      id: 'p7',
      name: 'Vélo de Route Carbon',
      description: 'Cadre en fibre de carbone ultra-léger, groupe Shimano 105, '
          'roues tubeless. Parfait pour les sorties longue distance.',
      price: 1899.00,
      imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=400',
      category: 'sports',
      tags: ['Vélo', 'Carbon', 'Shimano', 'Route'],
      rating: 4.8,
      reviewCount: 45,
    ),
    Product(
      id: 'p8',
      name: 'Sony WH-1000XM5',
      description: 'Le meilleur casque à réduction de bruit du marché. '
          '30h d\'autonomie, charge rapide, appels cristallins.',
      price: 329.99,
      originalPrice: 399.99,
      imageUrl: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=400',
      category: 'electronics',
      tags: ['Sony', 'Audio', 'ANC', 'Premium'],
      rating: 4.9,
      reviewCount: 1204,
    ),
    Product(
      id: 'p9',
      name: 'Montre Connectée Garmin',
      description: 'GPS intégré, suivi santé avancé, 14 jours d\'autonomie. '
          'Résistante 10 ATM, idéale pour le triathlon et la randonnée.',
      price: 449.00,
      imageUrl: 'https://images.unsplash.com/photo-1544117519-31a4b719223d?w=400',
      category: 'sports',
      tags: ['Garmin', 'GPS', 'Fitness', 'Outdoor'],
      rating: 4.7,
      reviewCount: 312,
      isNew: true,
    ),
  ];

  static List<Product> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  static List<Product> get gridProducts =>
      products.where((p) => !p.isFeatured).toList();

  static List<Product> byCategory(String categoryId) {
    if (categoryId == 'all') return products;
    return products.where((p) => p.category == categoryId).toList();
  }
}
