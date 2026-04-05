import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // شراء / بيع
  String _selectedCurrency = 'USD';
  final _amountController = TextEditingController();
  final _resultController = TextEditingController();
  bool _calculating = false;

  // أسعار الصرف الافتراضية (ريال يمني لكل وحدة)
  static const _rates = {
    'USD': {'buy': 1660.0, 'sell': 1640.0, 'flag': '🇺🇸', 'name': 'دولار أمريكي'},
    'SAR': {'buy': 442.0, 'sell': 438.0, 'flag': '🇸🇦', 'name': 'ريال سعودي'},
    'EUR': {'buy': 1820.0, 'sell': 1800.0, 'flag': '🇪🇺', 'name': 'يورو'},
    'KWD': {'buy': 5420.0, 'sell': 5380.0, 'flag': '🇰🇼', 'name': 'دينار كويتي'},
    'AED': {'buy': 452.0, 'sell': 448.0, 'flag': '🇦🇪', 'name': 'درهم إماراتي'},
    'GBP': {'buy': 2100.0, 'sell': 2080.0, 'flag': '🇬🇧', 'name': 'جنيه إسترليني'},
  };

  static const _changes = {
    'USD': '+0.3%',
    'SAR': '-0.1%',
    'EUR': '+0.8%',
    'KWD': '+0.2%',
    'AED': '+0.1%',
    'GBP': '-0.4%',
  };

  bool get _isBuy => _tabController.index == 0;

  double get _rate {
    final r = _rates[_selectedCurrency]!;
    return _isBuy ? (r['buy']! as double) : (r['sell']! as double);
  }

  void _calculate(String value) {
    final amount = double.tryParse(value) ?? 0;
    if (amount <= 0) {
      _resultController.clear();
      return;
    }
    setState(() => _calculating = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final result = _isBuy ? amount * _rate : amount / _rate;
      _resultController.text = result.toStringAsFixed(0);
      setState(() => _calculating = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {
          _resultController.clear();
          _amountController.clear();
        }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الصرافة', style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          labelStyle:
              const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: '🛒 شراء'),
            Tab(text: '💰 بيع'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExchangeBody(isDark),
          _buildExchangeBody(isDark),
        ],
      ),
    );
  }

  Widget _buildExchangeBody(bool isDark) {
    final cardBg = isDark ? const Color(0xFF1E1E2E) : AppColors.white;
    final curr = _rates[_selectedCurrency]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة السعر الحالي
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isBuy
                    ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
                    : [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: (_isBuy
                          ? const Color(0xFF667EEA)
                          : const Color(0xFF43E97B))
                      .withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isBuy ? 'سعر الشراء' : 'سعر البيع',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${_rate.toStringAsFixed(0)} ',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const TextSpan(
                              text: 'ريال',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'لكل ${curr['name']} واحد',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      curr['flag'] as String,
                      style: const TextStyle(fontSize: 42),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _changes[_selectedCurrency]!,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // اختيار العملة
          const Text('اختر العملة',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _rates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final code = _rates.keys.toList()[i];
                final data = _rates[code]!;
                final sel = code == _selectedCurrency;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCurrency = code);
                    _calculate(_amountController.text);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primaryBlue : cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel
                            ? AppColors.primaryBlue
                            : AppColors.lightGrey,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(data['flag'] as String,
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          code,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color:
                                sel ? Colors.white : null,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // حاسبة الصرف
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('حاسبة الصرف',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // حقل الإدخال
                _ExchangeField(
                  controller: _amountController,
                  label: _isBuy
                      ? 'المبلغ بـ $_selectedCurrency'
                      : 'المبلغ بالريال',
                  suffix: _isBuy ? _selectedCurrency : 'ريال',
                  flag: _isBuy
                      ? curr['flag'] as String
                      : '🇾🇪',
                  onChanged: _calculate,
                  isDark: isDark,
                ),

                const SizedBox(height: 12),

                // سهم التحويل
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.swap_vert_rounded,
                        color: AppColors.primaryBlue),
                  ),
                ),

                const SizedBox(height: 12),

                // حقل النتيجة
                _ExchangeField(
                  controller: _resultController,
                  label: _isBuy
                      ? 'المبلغ بالريال'
                      : 'المبلغ بـ $_selectedCurrency',
                  suffix: _isBuy ? 'ريال' : _selectedCurrency,
                  flag: _isBuy
                      ? '🇾🇪'
                      : curr['flag'] as String,
                  readOnly: true,
                  loading: _calculating,
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                // ملاحظة الرسوم
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.warning, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'رسوم الصرف: 0.5% — السعر قد يتغير عند التنفيذ',
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: AppColors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // زر التنفيذ
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _amountController.text.isEmpty
                  ? null
                  : () => _confirmExchange(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBuy
                    ? AppColors.primaryBlue
                    : AppColors.success,
                disabledBackgroundColor: AppColors.lightGrey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadius)),
              ),
              child: Text(
                _isBuy
                    ? 'شراء $_selectedCurrency'
                    : 'بيع $_selectedCurrency',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // جدول الأسعار الكاملة
          const Text('أسعار اليوم',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // رأس الجدول
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSizes.borderRadiusLarge)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text('العملة',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey))),
                      Expanded(
                          child: Text('شراء',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey))),
                      Expanded(
                          child: Text('بيع',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey))),
                      Expanded(
                          child: Text('تغيير',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey))),
                    ],
                  ),
                ),
                ..._rates.entries.map((e) {
                  final change = _changes[e.key]!;
                  final isPos = change.startsWith('+');
                  return _RateRow(
                    code: e.key,
                    flag: e.value['flag'] as String,
                    name: e.value['name'] as String,
                    buy: (e.value['buy'] as double).toStringAsFixed(0),
                    sell: (e.value['sell'] as double).toStringAsFixed(0),
                    change: change,
                    isPos: isPos,
                    isSelected: e.key == _selectedCurrency,
                    onTap: () => setState(() => _selectedCurrency = e.key),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _confirmExchange(BuildContext context) {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final resultAmount =
        _isBuy ? amount * _rate : amount / _rate;
    final curr = _rates[_selectedCurrency]!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.borderRadiusLarge)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text(
                _isBuy
                    ? 'تأكيد شراء $_selectedCurrency'
                    : 'تأكيد بيع $_selectedCurrency',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _ConfirmRow(
                label: _isBuy ? 'تدفع' : 'تبيع',
                value: _isBuy
                    ? '${amount.toStringAsFixed(2)} $_selectedCurrency  ${curr['flag']}'
                    : '${amount.toStringAsFixed(0)} ريال 🇾🇪',
              ),
              const Divider(height: 20),
              _ConfirmRow(
                label: _isBuy ? 'تستلم' : 'تستلم',
                value: _isBuy
                    ? '${resultAmount.toStringAsFixed(0)} ريال 🇾🇪'
                    : '${resultAmount.toStringAsFixed(2)} $_selectedCurrency  ${curr['flag']}',
                highlight: true,
              ),
              const Divider(height: 20),
              _ConfirmRow(
                label: 'السعر المطبق',
                value:
                    '${_rate.toStringAsFixed(0)} ريال / $_selectedCurrency',
              ),
              _ConfirmRow(
                label: 'الرسوم',
                value:
                    '${(amount * 0.005).toStringAsFixed(2)} ${_isBuy ? _selectedCurrency : 'ريال'}',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSizes.borderRadius)),
                      ),
                      child: const Text('إلغاء',
                          style: TextStyle(fontFamily: 'Cairo')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSuccess(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSizes.borderRadius)),
                      ),
                      child: const Text('تأكيد',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('تمت عملية الصرف بنجاح ✓',
                style: TextStyle(fontFamily: 'Cairo')),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
    _amountController.clear();
    _resultController.clear();
  }
}

class _ExchangeField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;
  final String flag;
  final bool readOnly;
  final bool loading;
  final void Function(String)? onChanged;
  final bool isDark;

  const _ExchangeField({
    Key? key,
    required this.controller,
    required this.label,
    required this.suffix,
    required this.flag,
    this.readOnly = false,
    this.loading = false,
    this.onChanged,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF252540)
            : AppColors.lightGrey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(
            color: readOnly
                ? Colors.transparent
                : AppColors.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onChanged: onChanged,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
              ],
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: readOnly ? AppColors.primaryBlue : null,
              ),
              decoration: InputDecoration(
                hintText: readOnly ? '—' : '0',
                hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.grey,
                    fontSize: 20),
                border: InputBorder.none,
                labelText: label,
                labelStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.grey),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          if (loading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.primaryBlue),
            )
          else
            Text(suffix,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey,
                    fontSize: 13)),
        ],
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final String code, flag, name, buy, sell, change;
  final bool isPos, isSelected;
  final VoidCallback onTap;

  const _RateRow({
    Key? key,
    required this.code,
    required this.flag,
    required this.name,
    required this.buy,
    required this.sell,
    required this.change,
    required this.isPos,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
              bottom: BorderSide(
                  color: AppColors.lightGrey.withValues(alpha: 0.5), width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(code,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : null)),
                      Text(name,
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: AppColors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(buy,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            Expanded(
              child: Text(sell,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            Expanded(
              child: Text(
                change,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isPos ? AppColors.success : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label, value;
  final bool highlight;
  const _ConfirmRow(
      {super.key,
      required this.label,
      required this.value,
      this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 14)),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight:
                      highlight ? FontWeight.bold : FontWeight.w500,
                  fontSize: highlight ? 16 : 14,
                  color: highlight ? AppColors.primaryBlue : null)),
        ],
      ),
    );
  }
}
