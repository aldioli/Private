import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/constants.dart';

class _Level {
  final String name;
  final String nameAr;
  final double minVolume;
  final double maxVolume;
  final Color color;
  final Color dark;
  final IconData icon;
  final List<String> benefits;

  const _Level({
    required this.name,
    required this.nameAr,
    required this.minVolume,
    required this.maxVolume,
    required this.color,
    required this.dark,
    required this.icon,
    required this.benefits,
  });
}

const _levels = [
  _Level(
    name: 'Bronze',
    nameAr: 'برونزي',
    minVolume: 0,
    maxVolume: 500000,
    color: Color(0xFFCD7F32),
    dark: Color(0xFF8B4513),
    icon: Icons.star_outline_rounded,
    benefits: [
      'تحويل مجاني بين محافظ YemenPay',
      'دفع الفواتير',
      'حد يومي: 1,000,000 ريال',
      'خدمة عملاء عبر البريد الإلكتروني',
    ],
  ),
  _Level(
    name: 'Silver',
    nameAr: 'فضي',
    minVolume: 500000,
    maxVolume: 2000000,
    color: Color(0xFF9E9E9E),
    dark: Color(0xFF616161),
    icon: Icons.star_half_rounded,
    benefits: [
      'كل مزايا المستوى البرونزي',
      'حد يومي مرتفع: 3,000,000 ريال',
      'أولوية في خدمة العملاء',
      'عروض حصرية على الشحن',
      'تقارير شهرية مفصّلة',
    ],
  ),
  _Level(
    name: 'Gold',
    nameAr: 'ذهبي',
    minVolume: 2000000,
    maxVolume: double.infinity,
    color: Color(0xFFFFD600),
    dark: Color(0xFFF9A825),
    icon: Icons.star_rounded,
    benefits: [
      'كل مزايا المستوى الفضي',
      'حد يومي غير محدود',
      'مدير حساب شخصي',
      'أولوية قصوى في الدعم 24/7',
      'عروض حصرية وخصومات',
      'سحب مجاني من الوكلاء',
      'بطاقة ذهبية رقمية',
    ],
  ),
];

class AccountLevelScreen extends StatelessWidget {
  const AccountLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, wp, _) {
        // نستخدم حجم تحويلات وهمي في Demo Mode
        const totalVolume = 185000.0;
        final currentLevel = _levels.firstWhere(
          (l) => totalVolume >= l.minVolume && totalVolume < l.maxVolume,
          orElse: () => _levels.last,
        );
        final levelIdx = _levels.indexOf(currentLevel);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: const Text('مستوى حسابي',
                style: TextStyle(fontFamily: 'Cairo')),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // رأس الصفحة مع البطاقة
                _LevelHeader(
                    level: currentLevel,
                    totalVolume: totalVolume,
                    isDark: isDark),

                // تقدم المستويات
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مسار الترقية',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      _LevelsProgress(
                          levels: _levels,
                          currentIdx: levelIdx,
                          totalVolume: totalVolume,
                          isDark: isDark),

                      const SizedBox(height: AppSizes.paddingL),

                      // التالي: كم يحتاج للترقية
                      if (levelIdx < _levels.length - 1)
                        _NextLevelCard(
                          nextLevel: _levels[levelIdx + 1],
                          currentVolume: totalVolume,
                          isDark: isDark,
                        ),

                      const SizedBox(height: AppSizes.paddingL),

                      // مزايا المستوى الحالي
                      _BenefitsCard(
                          level: currentLevel, isDark: isDark),

                      const SizedBox(height: AppSizes.paddingL),

                      // مقارنة المستويات
                      _LevelsComparisonCard(
                          levels: _levels,
                          currentIdx: levelIdx,
                          isDark: isDark),

                      const SizedBox(height: AppSizes.paddingXL),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LevelHeader extends StatelessWidget {
  final _Level level;
  final double totalVolume;
  final bool isDark;

  const _LevelHeader({
    Key? key,
    required this.level,
    required this.totalVolume,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nextLevel = _levels.indexOf(level) < _levels.length - 1
        ? _levels[_levels.indexOf(level) + 1]
        : null;
    final progress = nextLevel != null
        ? (totalVolume - level.minVolume) /
            (level.maxVolume - level.minVolume)
        : 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [level.dark, level.color.withValues(alpha: 0.8)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        children: [
          // أيقونة المستوى
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
            ),
            child: Icon(level.icon, color: Colors.white, size: 52),
          ),
          const SizedBox(height: 14),
          Text(
            level.nameAr,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            level.name,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // شريط التقدم
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_fmt(totalVolume)} ريال',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                nextLevel != null
                    ? '${_fmt(nextLevel.minVolume)} ريال'
                    : 'أعلى مستوى',
                style: const TextStyle(
                    fontFamily: 'Cairo', color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _LevelsProgress extends StatelessWidget {
  final List<_Level> levels;
  final int currentIdx;
  final double totalVolume;
  final bool isDark;

  const _LevelsProgress({
    Key? key,
    required this.levels,
    required this.currentIdx,
    required this.totalVolume,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: List.generate(levels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final lineIdx = i ~/ 2;
            final done = lineIdx < currentIdx;
            return Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: done
                      ? LinearGradient(
                          colors: [
                            levels[lineIdx].color,
                            levels[lineIdx + 1].color
                          ],
                        )
                      : null,
                  color: done ? null : AppColors.lightGrey,
                ),
              ),
            );
          }
          final idx = i ~/ 2;
          final active = idx == currentIdx;
          final done = idx < currentIdx;
          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: active ? 52 : 44,
                height: active ? 52 : 44,
                decoration: BoxDecoration(
                  color: done || active
                      ? levels[idx].color
                      : AppColors.lightGrey,
                  shape: BoxShape.circle,
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: levels[idx].color.withValues(alpha: 0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  levels[idx].icon,
                  color: done || active ? Colors.white : AppColors.grey,
                  size: active ? 26 : 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                levels[idx].nameAr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight:
                      active ? FontWeight.bold : FontWeight.normal,
                  color: done || active
                      ? levels[idx].color
                      : AppColors.grey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _NextLevelCard extends StatelessWidget {
  final _Level nextLevel;
  final double currentVolume;
  final bool isDark;

  const _NextLevelCard({
    Key? key,
    required this.nextLevel,
    required this.currentVolume,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final remaining = nextLevel.minVolume - currentVolume;
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: nextLevel.color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: nextLevel.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(nextLevel.icon, color: nextLevel.color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'للترقية إلى ${nextLevel.nameAr}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'تبقى ${_fmt(remaining)} ريال',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: nextLevel.color,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: nextLevel.color),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _BenefitsCard extends StatelessWidget {
  final _Level level;
  final bool isDark;

  const _BenefitsCard({super.key, required this.level, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(level.icon, color: level.color, size: 20),
              const SizedBox(width: 8),
              Text(
                'مزايا المستوى ${level.nameAr}',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          ...level.benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: level.color, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(b,
                        style: const TextStyle(
                            fontFamily: 'Cairo', fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelsComparisonCard extends StatelessWidget {
  final List<_Level> levels;
  final int currentIdx;
  final bool isDark;

  const _LevelsComparisonCard({
    Key? key,
    required this.levels,
    required this.currentIdx,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : AppColors.white;
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('مقارنة المستويات',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(height: AppSizes.paddingM),
          Table(
            border: TableBorder.all(
                color: AppColors.lightGrey.withValues(alpha: 0.5), width: 1),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              // رأس الجدول
              TableRow(
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                ),
                children: [
                  _TH('الميزة'),
                  ...levels.map((l) => _TH(l.nameAr, color: l.color)),
                ],
              ),
              _TR('حد يومي', ['1M', '3M', 'لا حد']),
              _TR('دعم العملاء', ['بريد', 'أولوية', '24/7']),
              _TR('مدير حساب', ['✗', '✗', '✓']),
              _TR('تقارير مفصّلة', ['✗', '✓', '✓']),
              _TR('سحب مجاني', ['✗', '✗', '✓']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _TH(String text, {Color? color}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
        ),
      );

  TableRow _TR(String label, List<String> values) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.grey)),
          ),
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                values[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: i == currentIdx
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: i == currentIdx
                      ? levels[i].color
                      : (values[i] == '✓'
                          ? AppColors.success
                          : values[i] == '✗'
                              ? AppColors.grey
                              : null),
                ),
              ),
            ),
          ),
        ],
      );
}
