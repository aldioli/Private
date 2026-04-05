import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  static const _points = 2450;
  static const _nextTier = 5000;
  static const _tier = 'فضي';
  static const _nextTierName = 'ذهبي';

  static const _history = [
    _PointEntry('تحويل إلى أحمد', '+50', true, '15 مارس'),
    _PointEntry('دفع فاتورة الكهرباء', '+30', true, '14 مارس'),
    _PointEntry('استرداد نقاط', '-200', false, '12 مارس'),
    _PointEntry('تحويل إلى فاطمة', '+50', true, '10 مارس'),
    _PointEntry('إيداع رصيد', '+20', true, '8 مارس'),
    _PointEntry('دعوة صديق', '+100', true, '5 مارس'),
  ];

  static const _ways = [
    _EarnWay(Icons.send_rounded, 'تحويل الأموال', '50 نقطة / تحويل', Color(0xFF1565C0)),
    _EarnWay(Icons.receipt_long_rounded, 'دفع الفواتير', '30 نقطة / فاتورة', Color(0xFFE53935)),
    _EarnWay(Icons.people_rounded, 'دعوة صديق', '100 نقطة / صديق', Color(0xFF388E3C)),
    _EarnWay(Icons.add_circle_outline, 'إيداع رصيد', '20 نقطة / إيداع', Color(0xFF8E24AA)),
    _EarnWay(Icons.shopping_bag_outlined, 'شراء عبر يمن باي', '2% كاشباك', Color(0xFFFA709A)),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = _points / _nextTier;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('نقاط الولاء',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA000), Color(0xFFFFD600)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA000).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('مستوى $_tier',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('رصيد نقاطك',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white70,
                          fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('$_points نقطة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  // Progress to next tier
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('$_tier',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 12)),
                      Text('$_nextTierName ($_nextTier نقطة)',
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.white30,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_nextTier - _points} نقطة تفصلك عن المستوى $_nextTierName',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Redeem button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showRedeemSheet(context),
                icon: const Icon(Icons.card_giftcard_rounded),
                label: const Text('استبدال النقاط',
                    style: TextStyle(
                        fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA000),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Ways to earn
            const Text('كيف تكسب نقاطاً؟',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.paddingS),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: _ways
                    .asMap()
                    .entries
                    .map((e) => Column(
                          children: [
                            ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: e.value.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(e.value.icon,
                                    color: e.value.color, size: 20),
                              ),
                              title: Text(e.value.title,
                                  style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFA000)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(e.value.reward,
                                    style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        color: Color(0xFFFFA000),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            if (e.key < _ways.length - 1)
                              const Divider(height: 1, indent: 60),
                          ],
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // History
            const Text('سجل النقاط',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.paddingS),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 56),
                itemBuilder: (_, i) {
                  final h = _history[i];
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: h.isCredit
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        h.isCredit
                            ? Icons.add_rounded
                            : Icons.remove_rounded,
                        color: h.isCredit ? AppColors.success : AppColors.error,
                        size: 18,
                      ),
                    ),
                    title: Text(h.title,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(h.date,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.grey)),
                    trailing: Text(
                      '${h.points} نقطة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: h.isCredit ? AppColors.success : AppColors.error),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }

  void _showRedeemSheet(BuildContext context) {
    final options = [
      ('خصم 1,000 ريال على التحويل', '500 نقطة'),
      ('شحن رصيد مجاني 2,000 ريال', '800 نقطة'),
      ('إعفاء من رسوم التحويل لشهر', '1,200 نقطة'),
      ('كاشباك 5% على الفواتير', '2,000 نقطة'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        expand: false,
        builder: (_, sc) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('استبدال النقاط',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: sc,
                itemCount: options.length,
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.card_giftcard_rounded,
                      color: Color(0xFFFFA000)),
                  title: Text(options[i].$1,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA000).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(options[i].$2,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xFFFFA000),
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم استبدال ${options[i].$2} بنجاح! ${options[i].$1}',
                          style: const TextStyle(fontFamily: 'Cairo'),
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointEntry {
  final String title;
  final String points;
  final bool isCredit;
  final String date;
  const _PointEntry(this.title, this.points, this.isCredit, this.date);
}

class _EarnWay {
  final IconData icon;
  final String title;
  final String reward;
  final Color color;
  const _EarnWay(this.icon, this.title, this.reward, this.color);
}
