import 'package:flutter/material.dart';
import '../models/news_model.dart';

/// Basit, paket bağımsız bir Shimmer widget'ı.
/// child üzerine kayan bir gradient shader uyguluyor.
class SimpleShimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final Color baseColor;
  final Color highlightColor;

  const SimpleShimmer({
    Key? key,
    required this.child,
    this.period = const Duration(milliseconds: 1400),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  }) : super(key: key);

  @override
  _SimpleShimmerState createState() => _SimpleShimmerState();
}

class _SimpleShimmerState extends State<SimpleShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// shaderCallback içinde gradient'i soldan sağa kaydırıyoruz.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            final width = rect.width;
            // kaydırma hesaplaması: value 0.0..1.0, gradient center moves across rect
            final dx = (2 * _controller.value - 1) * width;

            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.25, 0.5, 0.75],
              // createShader kullanırken rect ile translate yapmak yerine
              // gradient'i genişçe alıp kaydırılmış bir Rect kullanıyoruz:
            ).createShader(Rect.fromLTWH(-width + dx, 0, width * 3, rect.height));
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// NewsCard: news == null ise skeleton (shimmer) gösterir.
/// news doluysa gerçek içerik gösterir.
class NewsCard extends StatelessWidget {
  final News? news;
  final VoidCallback? onTap;

  const NewsCard({
    Key? key,
    this.news,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = news == null;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: SizedBox(
          height: 220, // kesin bir yükseklik vererek layout sıçramalarını engelle
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resim alanı (yaklaşık 60% yükseklik)
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: isLoading
                          ? SimpleShimmer(
                        child: Container(
                          color: const Color(0xFFE0E0E0),
                        ),
                      )
                          : Image.network(
                        news!.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SimpleShimmer(
                            child: Container(color: const Color(0xFFE0E0E0)),
                          );
                        },
                        errorBuilder: (context, err, st) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isLoading)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F57EF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'YENİ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Metin alanı
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: isLoading ? _buildSkeletonText() : _buildContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // başlık
        SimpleShimmer(
          child: Container(
            height: 18,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // açıklama satırı 1
        SimpleShimmer(
          child: Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // açıklama satırı 2 (kısa)
        SimpleShimmer(
          child: Container(
            height: 14,
            width: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const Spacer(),
        // alt satır (button benzeri)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SimpleShimmer(
              child: Container(
                height: 14,
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.transparent),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          news!.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, height: 1.3),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          news!.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13, height: 1.3),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Haberi Görüntüle',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
