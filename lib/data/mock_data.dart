import '../models/product.dart';

// Proxy CORS pour Flutter Web sur localhost


class MockData {
  static final List<Category> _categories = [
    const Category(id: 'all',         name: 'Tout',        icon: '🏠', productCount: 0),
    const Category(id: 'electronics', name: 'Électronique',icon: '📱', productCount: 0),
    const Category(id: 'fashion',     name: 'Mode',        icon: '👗', productCount: 0),
    const Category(id: 'home',        name: 'Maison',      icon: '🛋️', productCount: 0),
    const Category(id: 'sports',      name: 'Sport',       icon: '⚽', productCount: 0),
    const Category(id: 'food',        name: 'Alimentaire', icon: '🍎', productCount: 0),
    const Category(id: 'beauty',      name: 'Beauté',      icon: '💄', productCount: 0),
    const Category(id: 'books',       name: 'Livres',      icon: '📚', productCount: 0),
    const Category(id: 'gaming',      name: 'Gaming',      icon: '🎮', productCount: 0),
  ];

  static final List<Product> _products = [
    // ── Vedettes ─────────────────────────────────────────────────
    const Product(
      id: 'p1', name: 'iPhone 15 Pro',
      description: 'Le smartphone le plus avancé d\'Apple avec puce A17 Pro, système de caméra pro et design en titane.',
      price: 1199.99, originalPrice: 1399.99,
      imageUrl: 'assets/images/iphone15.jpg',
      category: 'electronics', tags: ['Apple', 'Smartphone', '5G'],
      rating: 4.8, reviewCount: 342, isFeatured: true,
    ),
    const Product(
      id: 'p2', name: 'MacBook Air M3',
      description: 'Ultra-fin et puissant. La puce M3 offre des performances exceptionnelles avec 18h d\'autonomie.',
      price: 1299.00,
      imageUrl: 'assets/images/macbook.jpg',
      category: 'electronics', tags: ['Apple', 'Laptop', 'M3'],
      rating: 4.9, reviewCount: 218, isFeatured: true,
    ),
    const Product(
      id: 'p3', name: 'Sony WH-1000XM5',
      description: 'Casque premium à réduction de bruit active. 30h d\'autonomie, audio Hi-Res certifié.',
      price: 279.00, originalPrice: 379.00,
      imageUrl: 'assets/images/sony_casque.jpg',
      category: 'electronics', tags: ['Sony', 'Audio', 'ANC'],
      rating: 4.7, reviewCount: 891, isFeatured: true,
    ),

    // ── Électronique ─────────────────────────────────────────────
    const Product(
      id: 'p4', name: 'Samsung Galaxy S24',
      description: 'Écran Dynamic AMOLED 6.2", photo 50MP avec IA intégrée.',
      price: 899.00, originalPrice: 999.00,
      imageUrl: 'assets/images/samsung_s24.jpg',
      category: 'electronics', tags: ['Samsung', 'Android', '5G'],
      rating: 4.5, reviewCount: 456, isNew: true,
    ),
    const Product(
      id: 'p5', name: 'iPad Pro 12.9"',
      description: 'Puce M2, écran Liquid Retina XDR, compatible Apple Pencil 2.',
      price: 1099.00,
      imageUrl: 'assets/images/ipad.jpg',
      category: 'electronics', tags: ['Apple', 'Tablette', 'M2'],
      rating: 4.8, reviewCount: 203,
    ),
    const Product(
      id: 'p6', name: 'Samsung OLED 55"',
      description: 'Couleurs parfaites et noirs absolus. Smart TV Tizen, HDR10+, son Dolby Atmos.',
      price: 899.00, originalPrice: 1099.00,
      imageUrl: 'assets/images/samsung_tv.jpg',
      category: 'electronics', tags: ['Samsung', '4K', 'OLED'],
      rating: 4.6, reviewCount: 178,
    ),
    const Product(
      id: 'p7', name: 'Apple Watch Series 9',
      description: 'Suivi santé avancé, écran Retina Always-On. Résistant à l\'eau 50m.',
      price: 429.00, originalPrice: 499.00,
      imageUrl: 'assets/images/apple_watch.jpg',
      category: 'electronics', tags: ['Apple', 'Montre', 'Santé'],
      rating: 4.7, reviewCount: 312, isNew: true,
    ),

    // ── Mode ──────────────────────────────────────────────────────
    const Product(
      id: 'p8', name: 'Nike Air Max 270',
      description: 'Amorti maximum et style iconique. Grande unité Air au talon.',
      price: 149.99, originalPrice: 179.99,
      imageUrl: 'assets/images/nike_airmax.jpg',
      category: 'fashion', tags: ['Nike', 'Running', 'Air Max'],
      rating: 4.5, reviewCount: 567, isNew: true,
    ),
    const Product(
      id: 'p9', name: 'Veste en Cuir',
      description: 'Cuir véritable pleine fleur, doublure en soie, coupe slim moderne.',
      price: 299.00, originalPrice: 399.00,
      imageUrl: 'assets/images/veste_cuir.jpg',
      category: 'fashion', tags: ['Cuir', 'Slim', 'Premium'],
      rating: 4.4, reviewCount: 89,
    ),
    const Product(
      id: 'p10', name: 'Sneakers Adidas',
      description: 'Ultra Boost 23, semelle Boost pour une énergie maximale.',
      price: 179.99,
      imageUrl: 'assets/images/adidas.jpg',
      category: 'fashion', tags: ['Adidas', 'Boost', 'Running'],
      rating: 4.6, reviewCount: 234,
    ),

    // ── Maison ────────────────────────────────────────────────────
    const Product(
      id: 'p11', name: 'Canapé Velours Bleu',
      description: 'Design contemporain velours côtelé, pieds en chêne massif.',
      price: 549.00,
      imageUrl: 'assets/images/canape.jpg',
      category: 'home', tags: ['Déco', 'Velours', 'Scandinave'],
      rating: 4.4, reviewCount: 89, isNew: true,
    ),
    const Product(
      id: 'p12', name: 'Lampe Arco Design',
      description: 'Lampe arc en acier brossé, abat-jour en marbre blanc.',
      price: 189.00, originalPrice: 249.00,
      imageUrl: 'assets/images/lampe.jpg',
      category: 'home', tags: ['Lampe', 'Design', 'Marbre'],
      rating: 4.3, reviewCount: 67,
    ),

    // ── Sport ─────────────────────────────────────────────────────
    const Product(
      id: 'p13', name: 'Vélo Carbon Route',
      description: 'Cadre carbone ultra-léger, groupe Shimano 105, roues tubeless.',
      price: 1899.00,
      imageUrl: 'assets/images/velo.jpg',
      category: 'sports', tags: ['Vélo', 'Carbon', 'Shimano'],
      rating: 4.8, reviewCount: 45,
    ),
    const Product(
      id: 'p14', name: 'Garmin Fenix 7',
      description: 'GPS multi-sport, 18 jours autonomie, suivi santé 24h/24.',
      price: 649.00, originalPrice: 749.00,
      imageUrl: 'assets/images/garmin.jpg',
      category: 'sports', tags: ['Garmin', 'GPS', 'Triathlon'],
      rating: 4.9, reviewCount: 189, isNew: true,
    ),

    // ── Gaming ────────────────────────────────────────────────────
    const Product(
      id: 'p15', name: 'PlayStation 5',
      description: 'Console next-gen, SSD ultra-rapide, ray tracing, 4K 120fps.',
      price: 549.99,
      imageUrl: 'assets/images/ps5.jpg',
      category: 'gaming', tags: ['Sony', 'Console', '4K'],
      rating: 4.9, reviewCount: 1204,
    ),
    const Product(
      id: 'p16', name: 'Clavier Mécanique RGB',
      description: 'Switches Cherry MX Red, rétroéclairage RGB, aluminium brossé.',
      price: 129.99, originalPrice: 159.99,
      imageUrl: 'assets/images/clavier.jpg',
      category: 'gaming', tags: ['Gaming', 'Mécanique', 'RGB'],
      rating: 4.6, reviewCount: 334,
    ),

    // ── Beauté ────────────────────────────────────────────────────
    const Product(
      id: 'p17', name: 'Parfum Chanel N°5',
      description: 'Le parfum iconique, notes florales aldéhydées. 100ml.',
      price: 139.00,
      imageUrl: 'assets/images/chanel.jpg',
      category: 'beauty', tags: ['Chanel', 'Parfum', 'Luxe'],
      rating: 4.8, reviewCount: 892,
    ),

    // ── Livres ────────────────────────────────────────────────────
    const Product(
      id: 'p18', name: 'Clean Code',
      description: 'Robert C. Martin. Le livre de référence pour écrire du code propre.',
      price: 39.99,
      imageUrl: 'assets/images/clean_code.jpg',
      category: 'books', tags: ['Dev', 'Architecture', 'Best-seller'],
      rating: 4.9, reviewCount: 2341,
    ),
  ];

  // ── Getters ─────────────────────────────────────────────────────
  static List<Category> get categories {
    return _categories.map((cat) {
      if (cat.id == 'all') {
        return Category(id: 'all', name: cat.name, icon: cat.icon,
            productCount: _products.length);
      }
      final count = _products.where((p) => p.category == cat.id).length;
      return Category(id: cat.id, name: cat.name, icon: cat.icon,
          productCount: count);
    }).toList();
  }

  static List<Product> get products         => List.unmodifiable(_products);
  static List<Product> get featuredProducts => _products.where((p) => p.isFeatured).toList();
  static List<Product> get gridProducts     => _products.where((p) => !p.isFeatured).toList();

  static List<Product> byCategory(String categoryId) {
    if (categoryId == 'all') return _products;
    return _products.where((p) => p.category == categoryId).toList();
  }

  static void addProduct(Product product)    => _products.add(product);
  static void addCategory(Category category) => _categories.add(category);
  static bool categoryExists(String id)      => _categories.any((c) => c.id == id);
  static int  get nextProductId              => _products.length + 1;
}
