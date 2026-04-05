import 'package:flutter/material.dart';
import '../utils/constants.dart';

// أسعار وهمية قابلة للتحديث عند ربط API
class _Rate {
  final String currency;
  final String flag;
  final double buyRate;
  final double sellRate;
  final bool isUp;

  const _Rate({
    required this.currency,
    required this.flag,
    required this.buyRate,
    required this.sellRate,
    required this.isUp,
  });
}

const _rates = [
  _Rate(currency: 'دولار أمريكي', flag: '🇺🇸', buyRate: 1720, sellRate: 1740, isUp: true),
  _Rate(currency: 'ريال سعودي',  flag: '🇸🇦', buyRate: 458,  sellRate: 463,  isUp: false),
  _Rate(currency: 'يورو',        flag: '🇪🇺', buyRate: 1860, sellRate: 1885, isUp: true),
  _Rate(currency: 'دينار كويتي', flag: '🇰🇼', buyRate: 5590, sellRate: 5640, isUp: false),
];

class CurrencyRates extends StatefulWidget {
  const CurrencyRates({super.key});

  @override
  State<CurrencyRates> createState() => _CurrencyRatesState();
}

class _CurrencyRatesState extends State<CurrencyRates> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final visibleRates = _expanded ? _rates : _rates.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('أسعار العملات', style: AppTextStyles.heading3),
            TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              label: Text(
                _expanded ? 'أقل' : 'عرض الكل',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.primaryBlue,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // رأس الجدول
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM, vertical: 10),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'العملة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'شراء (ريال)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'بيع (ريال)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...visibleRates.asMap().entries.map((entry) {
                final i = entry.key;
                final rate = entry.value;
                final isLast = i == visibleRates.length - 1;
                return _RateRow(rate: rate, isLast: isLast);
              }),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'آخر تحديث: ${_todayDate()}',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }

  String _todayDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }
}

class _RateRow extends StatelessWidget {
  final _Rate rate;
  final bool isLast;

  const _RateRow({super.key, required this.rate, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = rate.isUp ? AppColors.success : AppColors.error;
    final arrowIcon = rate.isUp
        ? Icons.arrow_drop_up_rounded
        : Icons.arrow_drop_down_rounded;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(rate.flag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rate.currency,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _format(rate.buyRate),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _format(rate.sellRate),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Icon(arrowIcon, color: color, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  String _format(double v) {
    if (v >= 1000) {
      return '${(v / 1000).toStringAsFixed(1)}K';
    }
    return v.toStringAsFixed(0);
  }
}
