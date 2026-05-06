import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String productName;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.productName,
    this.height,
    this.fit = BoxFit.cover,
  });

  String get _icon {
    switch (category) {
      case 'electronics': return '📱';
      case 'fashion':     return '👗';
      case 'home':        return '🛋️';
      case 'sports':      return '⚽';
      case 'food':        return '🍎';
      case 'beauty':      return '💄';
      case 'books':       return '📚';
      case 'gaming':      return '🎮';
      default:            return '🛍️';
    }
  }

  List<Color> get _colors {
    switch (category) {
      case 'electronics': return [const Color(0xFF1A1A2E), const Color(0xFF0F3460)];
      case 'fashion':     return [const Color(0xFF6B2D5E), const Color(0xFFE94560)];
      case 'home':        return [const Color(0xFF2D5016), const Color(0xFF4A7C59)];
      case 'sports':      return [const Color(0xFF1A3A5C), const Color(0xFF2980B9)];
      case 'food':        return [const Color(0xFF7D3C00), const Color(0xFFE67E22)];
      case 'beauty':      return [const Color(0xFF5B0033), const Color(0xFFAD1457)];
      case 'books':       return [const Color(0xFF2C1A0E), const Color(0xFF6D4C41)];
      case 'gaming':      return [const Color(0xFF0D001A), const Color(0xFF4A0080)];
      default:            return [const Color(0xFF1A1A2E), const Color(0xFF16213E)];
    }
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_icon, style: const TextStyle(fontSize: 52)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    productName,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _placeholder();

    // Asset local
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: fit,
        errorBuilder: (context, error, stack) => _placeholder(),
      );
    }

    // Image réseau
    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: fit,
      errorBuilder: (context, error, stack) => _placeholder(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Stack(
          children: [
            _placeholder(),
            Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                  color: Colors.white.withValues(alpha: 0.6),
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
