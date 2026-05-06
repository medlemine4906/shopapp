import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_item.dart';
import '../widgets/featured_card.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _selectedCategoryId = 'all';
  final _cart = CartService();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  // Animation compteur
  late AnimationController _counterController;
  late Animation<int> _counterAnimation;
  int _displayedCount = 0;

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateCounter(MockData.byCategory(_selectedCategoryId).length);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  void _animateCounter(int newCount) {
    final oldCount = _displayedCount;
    _counterAnimation = IntTween(begin: oldCount, end: newCount).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    )..addListener(() => setState(() => _displayedCount = _counterAnimation.value));
    _counterController.forward(from: 0);
  }

  void _onCategoryChanged(String catId) {
    setState(() => _selectedCategoryId = catId);
    _animateCounter(MockData.byCategory(catId).length);
  }

  double get _collapseRatio {
    const expanded = 200.0;
    const collapsed = kToolbarHeight;
    return (_scrollOffset.clamp(0.0, expanded - collapsed)) / (expanded - collapsed);
  }

  List<Product> get _gridProducts =>
      MockData.byCategory(_selectedCategoryId).where((p) => !p.isFeatured).toList();

  void _navigateToProduct(Product product) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a, b) => ProductScreen(product: product),
        transitionsBuilder: (context, a, b, child) => FadeTransition(
          opacity: a,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05), end: Offset.zero,
            ).animate(CurvedAnimation(parent: a, curve: Curves.easeOut)),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }

  // ── Dialogue : Ajouter un produit ─────────────────────────────
  void _showAddProductDialog() {
    final nameCtrl    = TextEditingController();
    final priceCtrl   = TextEditingController();
    final descCtrl    = TextEditingController();
    final imageCtrl   = TextEditingController();
    String selectedCat = _categories.first.id == 'all'
        ? (_categories.length > 1 ? _categories[1].id : 'electronics')
        : _categories.first.id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text('➕ Nouveau Produit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),

                _field('Nom du produit', nameCtrl, Icons.inventory_2_outlined),
                const SizedBox(height: 12),
                _field('Prix (€)', priceCtrl, Icons.euro, isNumber: true),
                const SizedBox(height: 12),
                _field('Description', descCtrl, Icons.notes, maxLines: 3),
                const SizedBox(height: 12),
                _field('URL de l\'image', imageCtrl, Icons.image_outlined),
                const SizedBox(height: 12),

                // Sélecteur catégorie
                const Text('Catégorie',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCat,
                      isExpanded: true,
                      items: MockData.categories
                          .where((c) => c.id != 'all')
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text('${c.icon} ${c.name}'),
                              ))
                          .toList(),
                      onChanged: (v) => setModalState(() => selectedCat = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Bouton confirmer
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;
                      final product = Product(
                        id: 'p${MockData.nextProductId}',
                        name: nameCtrl.text,
                        description: descCtrl.text.isEmpty
                            ? 'Aucune description.'
                            : descCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        imageUrl: imageCtrl.text.isEmpty
                            ? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'
                            : imageCtrl.text,
                        category: selectedCat,
                        tags: [selectedCat],
                        rating: 5.0,
                        reviewCount: 0,
                      );
                      MockData.addProduct(product);
                      setState(() {});
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} ajouté !'),
                          backgroundColor: AppTheme.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    child: const Text('Ajouter le produit',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Dialogue : Ajouter une catégorie ─────────────────────────
  void _showAddCategoryDialog() {
    final nameCtrl = TextEditingController();
    final iconCtrl = TextEditingController(text: '🏷️');
    final idCtrl   = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('➕ Nouvelle Catégorie',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field('Nom (ex: Jouets)', nameCtrl, Icons.category_outlined),
            const SizedBox(height: 12),
            _field('Icône emoji (ex: 🧸)', iconCtrl, Icons.emoji_emotions_outlined),
            const SizedBox(height: 12),
            _field('ID unique (ex: toys)', idCtrl, Icons.key_outlined),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || idCtrl.text.isEmpty) return;
              if (MockData.categoryExists(idCtrl.text)) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID déjà existant !')),
                );
                return;
              }
              MockData.addCategory(Category(
                id: idCtrl.text.toLowerCase().replaceAll(' ', '_'),
                name: nameCtrl.text,
                icon: iconCtrl.text,
              ));
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Catégorie "${nameCtrl.text}" ajoutée !'),
                  backgroundColor: AppTheme.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  // ── Menu choix ajouter ────────────────────────────────────────
  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    color: AppTheme.primary),
              ),
              title: const Text('Ajouter un produit',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Nom, prix, image, catégorie'),
              onTap: () {
                Navigator.pop(context);
                _showAddProductDialog();
              },
            ),
            const Divider(height: 1, indent: 70),
            ListTile(
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.category_outlined, color: AppTheme.accent),
              ),
              title: const Text('Ajouter une catégorie',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Nom, emoji, identifiant'),
              onTap: () {
                Navigator.pop(context);
                _showAddCategoryDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Category> get _categories => MockData.categories;

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppTheme.textSecondary),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratio = _collapseRatio;
    final selectedCategory =
        _categories.firstWhere((c) => c.id == _selectedCategoryId);

    return Scaffold(
      backgroundColor: AppTheme.surface,

      // ── FAB : bouton + ──────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenu,
        backgroundColor: AppTheme.accent,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          // ── SliverAppBar toujours présente ─────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: false,
            stretch: true,
            backgroundColor: AppTheme.primary,

            // Titre replié
            title: AnimatedOpacity(
              opacity: ratio,
              duration: const Duration(milliseconds: 150),
              child: Row(
                children: [
                  Text(selectedCategory.icon,
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '$_displayedCount produits',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            actions: [
              // Panier avec badge
              ListenableBuilder(
                listenable: _cart,
                builder: (context, _) => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                    if (_cart.itemCount > 0)
                      Positioned(
                        right: 6, top: 6,
                        child: Container(
                          width: 18, height: 18,
                          decoration: const BoxDecoration(
                              color: AppTheme.accent, shape: BoxShape.circle),
                          child: Center(
                            child: Text('${_cart.itemCount}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A2E),
                          Color(0xFF16213E),
                          Color(0xFF0F3460),
                        ],
                      ),
                    ),
                  ),

                  // Cercles décoratifs
                  Positioned(
                    top: -30, right: -30,
                    child: Container(
                      width: 150, height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accent.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20, left: -20,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  // Contenu : Bienvenu + compteur animé
                  Positioned(
                    bottom: 20, left: 16, right: 16,
                    child: AnimatedOpacity(
                      opacity: (1 - ratio * 2).clamp(0.0, 1.0),
                      duration: const Duration(milliseconds: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bienvenu
                          Row(
                            children: [
                              const Text('👋 ',
                                  style: TextStyle(fontSize: 18)),
                              Text(
                                'Bienvenu !',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Compteur animé
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.8, end: 1.0),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.elasticOut,
                                key: ValueKey(_selectedCategoryId),
                                builder: (_, scale, child) => Transform.scale(
                                  scale: scale,
                                  alignment: Alignment.bottomLeft,
                                  child: child,
                                ),
                                child: Text(
                                  '$_displayedCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                    letterSpacing: -2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('produits',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: Text(
                                        key: ValueKey(_selectedCategoryId),
                                        '${selectedCategory.icon} ${selectedCategory.name}',
                                        style: TextStyle(
                                          color: AppTheme.accent.withValues(alpha: 0.9),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Barre de recherche
                          Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 12),
                                Icon(Icons.search,
                                    color: Colors.white54, size: 18),
                                SizedBox(width: 8),
                                Text('Rechercher un produit...',
                                    style: TextStyle(
                                        color: Colors.white38, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Barre de progression
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accent.withValues(alpha: ratio),
                            AppTheme.accentLight.withValues(alpha: ratio),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Catégories ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Text('Catégories',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.5)),
                ),
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return CategoryItem(
                        category: cat,
                        isSelected: _selectedCategoryId == cat.id,
                        onTap: () => _onCategoryChanged(cat.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Section Header 1 ────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: SectionHeader(
                title: '⭐ Produits Vedettes',
                subtitle: 'Nos meilleures sélections',
                actionLabel: 'Voir tout',
                onActionTap: () {},
              ),
            ),
          ),

          // ── FeaturedCards ────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 340,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: MockData.featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = MockData.featuredProducts[index];
                  return FeaturedCard(
                    product: product,
                    onTap: () => _navigateToProduct(product),
                  );
                },
              ),
            ),
          ),

          // ── Section Header 2 ────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: SectionHeader(
                title: '🛍️ Tous les Produits',
                subtitle: '${_gridProducts.length} articles',
                actionLabel: 'Filtrer',
                onActionTap: () {},
              ),
            ),
          ),

          // ── Grille produits ──────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = _gridProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _navigateToProduct(product),
                  );
                },
                childCount: _gridProducts.length,
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('🚚 Livraison gratuite',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    'Pour toute commande supérieure à 50 €',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('En savoir plus'),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  static const double _height = 76;
  const _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;
  @override double get maxExtent => _height;
  @override double get minExtent => _height;
  @override bool shouldRebuild(_StickyHeaderDelegate old) => old.child != child;
}
