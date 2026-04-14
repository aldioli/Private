import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MarketRatesScreen extends StatefulWidget {
  const MarketRatesScreen({super.key});

  @override
  State<MarketRatesScreen> createState() => _MarketRatesScreenState();
}

class _RateItem {
  final String name;
  final String nameAr;
  final String symbol;
  final double buy;
  final double sell;
  final double change; // % change
  final String flag;
  final String category;

  const _RateItem({
    required this.name,
    required this.nameAr,
    required this.symbol,
    required this.buy,
    required this.sell,
    required this.change,
    required this.flag,
    required this.category,
  });
}

class _CommodityItem {
  final String nameAr;
  final String unit;
  final double price;
  final double change;
  final IconData icon;
  final Color color;

  const _CommodityItem({
    required this.nameAr,
    required this.unit,
    required this.price,
    required this.change,
    required this.icon,
    required this.color,
  });
}

class _MarketRatesScreenState extends State<MarketRatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _lastUpdated = DateTime.now();
  bool _refreshing = false;

  final List<_RateItem> _currencyRates = const [
    _RateItem(
      name: 'US Dollar',
      nameAr: 'الدولار الأمريكي',
      symbol: 'USD',
      buy: 1730,
      sell: 1735,
      change: 0.8,
      flag: '🇺🇸',
      category: 'رئيسية',
    ),
    _RateItem(
      name: 'Saudi Riyal',
      nameAr: 'الريال السعودي',
      symbol: 'SAR',
      buy: 460,
      sell: 462,
      change: 0.3,
      flag: '🇸🇦',
      category: 'خليجية',
    ),
    _RateItem(
      name: 'UAE Dirham',
      nameAr: 'الدرهم الإماراتي',
      symbol: 'AED',
      buy: 471,
      sell: 473,
      change: 0.5,
      flag: '🇦🇪',
      category: 'خليجية',
    ),
    _RateItem(
      name: 'Euro',
      nameAr: 'اليورو',
      symbol: 'EUR',
      buy: 1890,
      sell: 1895,
      change: -0.4,
      flag: '🇪🇺',
      category: 'رئيسية',
    ),
    _RateItem(
      name: 'British Pound',
      nameAr: 'الجنيه الإسترليني',
      symbol: 'GBP',
      buy: 2195,
      sell: 2202,
      change: -0.2,
      flag: '🇬🇧',
      category: 'رئيسية',
    ),
    _RateItem(
      name: 'Kuwaiti Dinar',
      nameAr: 'الدينار الكويتي',
      symbol: 'KWD',
      buy: 5580,
      sell: 5590,
      change: 0.1,
      flag: '🇰🇼',
      category: 'خليجية',
    ),
    _RateItem(
      name: 'Turkish Lira',
      nameAr: 'الليرة التركية',
      symbol: 'TRY',
      buy: 50,
      sell: 51,
      change: -1.2,
      flag: '🇹🇷',
      category: 'أخرى',
    ),
    _RateItem(
      name: 'Egyptian Pound',
      nameAr: 'الجنيه المصري',
      symbol: 'EGP',
      buy: 35,
      sell: 36,
      change: -0.6,
      flag: '🇪🇬',
      category: 'عربية',
    ),
    _RateItem(
      name: 'Jordanian Dinar',
      nameAr: 'الدينار الأردني',
      symbol: 'JOD',
      buy: 2440,
      sell: 2450,
      change: 0.0,
      flag: '🇯🇴',
      category: 'عربية',
    ),
    _RateItem(
      name: 'Chinese Yuan',
      nameAr: 'اليوان الصيني',
      symbol: 'CNY',
      buy: 238,
      sell: 240,
      change: 0.3,
      flag: '🇨🇳',
      category: 'أخرى',
    ),
  ];

  final List<_CommodityItem> _commodities = const [
    _CommodityItem(
      nameAr: 'الذهب عيار 21',
      unit: 'جرام',
      price: 95000,
      change: 1.2,
      icon: Icons.diamond_rounded,
      color: Color(0xFFFFD600),
    ),
    _CommodityItem(
      nameAr: 'الذهب عيار 18',
      unit: 'جرام',
      price: 81000,
      change: 1.1,
      icon: Icons.diamond_outlined,
      color: Color(0xFFFFA000),
    ),
    _CommodityItem(
      nameAr: 'الفضة',
      unit: 'جرام',
      price: 950,
      change: 0.8,
      icon: Icons.circle_outlined,
      color: Color(0xFF9E9E9E),
    ),
    _CommodityItem(
      nameAr: 'النفط الخام (برميل)',
      unit: 'دولار',
      price: 82,
      change: -0.9,
      icon: Icons.oil_barrel_rounded,
      color: Color(0xFF5D4037),
    ),
    _CommodityItem(
      nameAr: 'القمح (طن)',
      unit: 'دولار',
      price: 231,
      change: 2.1,
      icon: Icons.grass_rounded,
      color: Color(0xFF8D6E63),
    ),
  ];

  String _selectedCategory = 'الكل';
  final List<String> _categories = ['الكل', 'رئيسية', 'خليجية', 'عربية', 'أخرى'];

  List<_RateItem> get _filtered {
    if (_selectedCategory == 'الكل') return _currencyRates;
    return _currencyRates.where((r) => r.category == _selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() => _refreshing = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _refreshing = false;
        _lastUpdated = DateTime.now();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث الأسعار',
              style: TextStyle(fontFamily: 'Cairo')),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('أسعار الصرف والسوق',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: _refreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            onPressed: _refreshing ? null : _refresh,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle:
              const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(text: 'أسعار العملات'),
            Tab(text: 'السلع والمعادن'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CurrenciesTab(
            categories: _categories,
            selected: _selectedCategory,
            filtered: _filtered,
            lastUpdated: _lastUpdated,
            onCategoryTap: (c) => setState(() => _selectedCategory = c),
          ),
          _CommoditiesTab(commodities: _commodities),
        ],
      ),
    );
  }
}

// ======= Tab 1: العملات =======
class _CurrenciesTab extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final List<_RateItem> filtered;
  final DateTime lastUpdated;
  final void Function(String) onCategoryTap;

  const _CurrenciesTab({
    required this.categories,
    required this.selected,
    required this.filtered,
    required this.lastUpdated,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // تحديث + فلتر
        Container(
          color: AppColors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.update_rounded,
                        size: 16, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'آخر تحديث: ${lastUpdated.hour}:${lastUpdated.minute.toString().padLeft(2, '0')} — سعر Beepay',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                    right: AppSizes.paddingM,
                    left: AppSizes.paddingM,
                    bottom: AppSizes.paddingS),
                child: Row(
                  children: categories.map((cat) {
                    final isSel = cat == selected;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Text(cat,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: isSel ? AppColors.white : AppColors.grey,
                            )),
                        selected: isSel,
                        onSelected: (_) => onCategoryTap(cat),
                        backgroundColor: AppColors.white,
                        selectedColor: AppColors.primaryBlue,
                        checkmarkColor: AppColors.white,
                        side: BorderSide(
                          color: isSel
                              ? AppColors.primaryBlue
                              : AppColors.lightGrey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        // ترويسة الجدول
        Container(
          color: AppColors.primaryBlue.withValues(alpha: 0.05),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM, vertical: 10),
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text('العملة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.grey,
                    )),
              ),
              Expanded(
                child: Text('شراء',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.grey,
                    )),
              ),
              Expanded(
                child: Text('بيع',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.grey,
                    )),
              ),
              Expanded(
                child: Text('التغيير',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.grey,
                    )),
              ),
            ],
          ),
        ),
        // قائمة العملات
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            itemCount: filtered.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.background),
            itemBuilder: (_, i) => _CurrencyRow(rate: filtered[i]),
          ),
        ),
      ],
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  final _RateItem rate;
  const _CurrencyRow({required this.rate});

  @override
  Widget build(BuildContext context) {
    final isPos = rate.change >= 0;
    final changeColor = isPos ? AppColors.success : AppColors.error;

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(rate.flag, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rate.nameAr,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          )),
                      Text(rate.symbol,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: AppColors.grey,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              rate.buy.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              rate.sell.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPos
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  color: changeColor,
                  size: 20,
                ),
                Text(
                  '${rate.change.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======= Tab 2: السلع والمعادن =======
class _CommoditiesTab extends StatelessWidget {
  final List<_CommodityItem> commodities;
  const _CommoditiesTab({required this.commodities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: commodities.length,
      itemBuilder: (_, i) {
        final c = commodities[i];
        final isPos = c.change >= 0;
        final changeColor = isPos ? AppColors.success : AppColors.error;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: c.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(c.icon, color: c.color, size: 26),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.nameAr,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                    Text('لكل ${c.unit}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    c.unit == 'دولار'
                        ? '\$${c.price.toStringAsFixed(0)}'
                        : '${c.price.toStringAsFixed(0)} ريال',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        isPos
                            ? Icons.arrow_drop_up_rounded
                            : Icons.arrow_drop_down_rounded,
                        color: changeColor,
                        size: 18,
                      ),
                      Text(
                        '${c.change.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: changeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
