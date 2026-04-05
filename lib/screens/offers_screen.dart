import 'package:flutter/material.dart';
import '../utils/constants.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeBanner = 0;
  final PageController _bannerController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  static const _banners = [
    {
      'title': 'تحويل مجاني طوال رمضان!',
      'subtitle': 'لا عمولة على التحويلات حتى نهاية الشهر',
      'icon': Icons.local_offer_rounded,
      'colors': [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
    {
      'title': 'دفع فواتير — كاشباك 2%',
      'subtitle': 'استرد 2% من كل عملية دفع فواتير',
      'icon': Icons.receipt_long_rounded,
      'colors': [Color(0xFF43E97B), Color(0xFF38F9D7)],
    },
    {
      'title': 'أعلى من 50,000 ريال — مكافأة!',
      'subtitle': 'احصل على 500 ريال عند إيداع 50,000 أو أكثر',
      'icon': Icons.savings_rounded,
      'colors': [Color(0xFFFA709A), Color(0xFFFEE140)],
    },
  ];

  static const _offers = [
    {
      'cat': 'تحويل',
      'title': 'تحويل مجاني',
      'desc': 'تحويل بلا عمولة لأول 10 معاملات شهرياً',
      'badge': 'حصري',
      'badgeColor': Color(0xFF6C63FF),
      'expiry': '31/03/2026',
      'icon': Icons.send_rounded,
      'color': AppColors.primaryBlue,
      'saved': '1,000',
    },
    {
      'cat': 'كاشباك',
      'title': 'كاشباك دفع الفواتير',
      'desc': 'استرد 2% من كل عملية دفع فاتورة اتصالات',
      'badge': 'جديد',
      'badgeColor': AppColors.success,
      'expiry': '30/04/2026',
      'icon': Icons.bolt_rounded,
      'color': AppColors.success,
      'saved': '500',
    },
    {
      'cat': 'إيداع',
      'title': 'مكافأة الإيداع الكبير',
      'desc': 'احصل على 500 ريال عند إيداع 50,000 أو أكثر',
      'badge': 'محدود',
      'badgeColor': AppColors.warning,
      'expiry': '15/04/2026',
      'icon': Icons.savings_rounded,
      'color': AppColors.warning,
      'saved': '500',
    },
    {
      'cat': 'تحويل',
      'title': 'خصم عيد الفطر',
      'desc': 'خصم 50% على رسوم التحويل خلال أيام العيد',
      'badge': 'قريباً',
      'badgeColor': AppColors.grey,
      'expiry': '10/04/2026',
      'icon': Icons.celebration_rounded,
      'color': const Color(0xFFFA709A),
      'saved': '750',
    },
    {
      'cat': 'كاشباك',
      'title': 'برنامج الولاء',
      'desc': 'اجمع نقاطاً مع كل معاملة واستبدلها بمكافآت نقدية',
      'badge': 'دائم',
      'badgeColor': AppColors.primaryBlue,
      'expiry': 'مستمر',
      'icon': Icons.stars_rounded,
      'color': const Color(0xFF667EEA),
      'saved': 'متغير',
    },
    {
      'cat': 'إيداع',
      'title': 'إيداع أصدقاؤك = فلوسك',
      'desc': 'احصل على 100 ريال لكل صديق يودع أول مبلغ',
      'badge': 'إحالة',
      'badgeColor': const Color(0xFF43E97B),
      'expiry': 'مستمر',
      'icon': Icons.people_rounded,
      'color': const Color(0xFF43E97B),
      'saved': '100+',
    },
  ];

  List<Map> _filtered(String cat) {
    if (cat == 'الكل') return List.from(_offers);
    return _offers.where((o) => o['cat'] == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('العروض والمكافآت',
            style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'تحويل'),
            Tab(text: 'كاشباك'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPage(isDark, 'الكل'),
          _buildPage(isDark, 'تحويل'),
          _buildPage(isDark, 'كاشباك'),
        ],
      ),
    );
  }

  Widget _buildPage(bool isDark, String cat) {
    final list = _filtered(cat);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (cat == 'الكل') ...[
          // البانر الدوار
          _buildBanner(),
          const SizedBox(height: 8),

          // مؤشرات البانر
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _activeBanner == i ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: _activeBanner == i
                      ? AppColors.primaryBlue
                      : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ملخص المدخرات
          _SavingsSummary(isDark: isDark),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: Row(
              children: [
                const Text('جميع العروض',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${list.length} عرض',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppColors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...list.map((offer) => _OfferCard(offer: offer, isDark: isDark)),
      ],
    );
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (i) => setState(() => _activeBanner = i),
        itemCount: _banners.length,
        itemBuilder: (context, i) {
          final b = _banners[i];
          final colors = b['colors'] as List<Color>;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: colors.first.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              b['title'] as String,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              b['subtitle'] as String,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('اعرف أكثر',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Icon(b['icon'] as IconData,
                          size: 64, color: Colors.white.withValues(alpha: 0.3)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SavingsSummary extends StatelessWidget {
  final bool isDark;
  const _SavingsSummary({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: 'عروض نشطة',
              value: '6',
              icon: Icons.local_offer_rounded,
              color: AppColors.primaryBlue,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.lightGrey),
          Expanded(
            child: _StatItem(
              label: 'وفّرت هذا الشهر',
              value: '1,850 ر',
              icon: Icons.savings_rounded,
              color: AppColors.success,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.lightGrey),
          Expanded(
            child: _StatItem(
              label: 'تنتهي قريباً',
              value: '2',
              icon: Icons.timer_outlined,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatItem(
      {super.key,
      required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color)),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 10, color: AppColors.grey)),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Map offer;
  final bool isDark;
  const _OfferCard({super.key, required this.offer, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = offer['color'] as Color;
    final badgeColor = offer['badgeColor'] as Color;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(offer['icon'] as IconData, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(offer['title'] as String,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(offer['badge'] as String,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: badgeColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(offer['desc'] as String,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 12, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Text('ينتهي: ${offer['expiry']}',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: AppColors.grey)),
                    const Spacer(),
                    Text('توفير: ${offer['saved']} ر',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
