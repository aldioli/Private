import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../screens/offers_screen.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final _controller = PageController();
  int _current = 0;
  Timer? _timer;

  static const _items = [
    _BannerItem(
      title: 'تحويل مجاني — رمضان كريم!',
      subtitle: 'لا عمولة على التحويلات طوال الشهر',
      icon: Icons.send_rounded,
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    _BannerItem(
      title: 'كاشباك 2% على الفواتير',
      subtitle: 'استرد جزءاً من كل دفعة فاتورة',
      icon: Icons.receipt_long_rounded,
      colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    ),
    _BannerItem(
      title: 'ادعُ صديقاً — اربح 500 ريال',
      subtitle: 'لكل صديق يفعّل حسابه عبر رابطك',
      icon: Icons.people_rounded,
      colors: [Color(0xFFFA709A), Color(0xFFFF9A9E)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) => _BannerCard(
              item: _items[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OffersScreen()),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _items.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _current == i ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _current == i
                    ? AppColors.primaryBlue
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerItem item;
  final VoidCallback onTap;

  const _BannerCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: item.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: item.colors.first.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: -16,
              bottom: -16,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'اعرف أكثر',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                size: 10, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(item.icon, size: 52, color: Colors.white.withValues(alpha: 0.25)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
