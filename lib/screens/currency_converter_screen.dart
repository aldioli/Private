import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  String _fromCurrency = 'YER';
  String _toCurrency = 'USD';

  static const _currencies = {
    'YER': _Currency('ريال يمني', '🇾🇪', 1.0),
    'USD': _Currency('دولار أمريكي', '🇺🇸', 1650.0),
    'SAR': _Currency('ريال سعودي', '🇸🇦', 440.0),
    'EUR': _Currency('يورو', '🇪🇺', 1810.0),
    'GBP': _Currency('جنيه إسترليني', '🇬🇧', 2090.0),
    'KWD': _Currency('دينار كويتي', '🇰🇼', 5400.0),
    'AED': _Currency('درهم إماراتي', '🇦🇪', 449.0),
    'TRY': _Currency('ليرة تركية', '🇹🇷', 51.0),
    'EGP': _Currency('جنيه مصري', '🇪🇬', 33.0),
  };

  double _convert(double amount, String from, String to) {
    final fromRate = _currencies[from]!.rateToYER;
    final toRate = _currencies[to]!.rateToYER;
    // Convert to YER first, then to target
    if (from == 'YER') return amount / toRate;
    if (to == 'YER') return amount * fromRate;
    return (amount * fromRate) / toRate;
  }

  void _onFromChanged(String val) {
    final amount = double.tryParse(val) ?? 0;
    if (amount == 0) {
      _toCtrl.clear();
      return;
    }
    final result = _convert(amount, _fromCurrency, _toCurrency);
    _toCtrl.text = result.toStringAsFixed(result < 1 ? 4 : 2);
  }

  void _onToChanged(String val) {
    final amount = double.tryParse(val) ?? 0;
    if (amount == 0) {
      _fromCtrl.clear();
      return;
    }
    final result = _convert(amount, _toCurrency, _fromCurrency);
    _fromCtrl.text = result.toStringAsFixed(result < 1 ? 4 : 2);
  }

  void _swap() {
    setState(() {
      final tmp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = tmp;
      _fromCtrl.clear();
      _toCtrl.clear();
    });
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fromC = _currencies[_fromCurrency]!;
    final toC = _currencies[_toCurrency]!;
    final rate = _convert(1, _fromCurrency, _toCurrency);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('محول العملات',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          children: [
            // Converter card
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 15, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  // Rate display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '1 $_fromCurrency = ${rate.toStringAsFixed(rate < 1 ? 4 : 2)} $_toCurrency',
                      style: const TextStyle(fontFamily: 'Cairo',
                          color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // From field
                  _CurrencyField(
                    label: 'من',
                    controller: _fromCtrl,
                    currency: _fromCurrency,
                    flag: fromC.flag,
                    name: fromC.name,
                    onChanged: _onFromChanged,
                    onCurrencyTap: () => _pickCurrency(true),
                  ),
                  const SizedBox(height: 12),

                  // Swap button
                  Center(
                    child: GestureDetector(
                      onTap: _swap,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(
                              color: AppColors.primaryBlue.withValues(alpha: 0.3),
                              blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: const Icon(Icons.swap_vert_rounded,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // To field
                  _CurrencyField(
                    label: 'إلى',
                    controller: _toCtrl,
                    currency: _toCurrency,
                    flag: toC.flag,
                    name: toC.name,
                    onChanged: _onToChanged,
                    onCurrencyTap: () => _pickCurrency(false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Quick amounts
            const Align(
              alignment: Alignment.centerRight,
              child: Text('مبالغ سريعة',
                  style: TextStyle(fontFamily: 'Cairo',
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [100, 500, 1000, 5000, 10000, 50000, 100000]
                  .map((amt) => ActionChip(
                        label: Text('$amt',
                            style: const TextStyle(
                                fontFamily: 'Cairo', fontSize: 13)),
                        backgroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.lightGrey),
                        onPressed: () {
                          _fromCtrl.text = amt.toString();
                          _onFromChanged(amt.toString());
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // All rates table
            const Align(
              alignment: Alignment.centerRight,
              child: Text('جدول أسعار الصرف',
                  style: TextStyle(fontFamily: 'Cairo',
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: _currencies.entries
                    .where((e) => e.key != 'YER')
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  final c = e.value;
                  return Column(
                    children: [
                      ListTile(
                        leading: Text(c.flag,
                            style: const TextStyle(fontSize: 26)),
                        title: Text(e.key,
                            style: const TextStyle(fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(c.name,
                            style: const TextStyle(fontFamily: 'Cairo',
                                fontSize: 12, color: AppColors.grey)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${c.rateToYER.toStringAsFixed(0)} ر.ي',
                                style: const TextStyle(fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const Text('لكل وحدة',
                                style: TextStyle(fontFamily: 'Cairo',
                                    fontSize: 11, color: AppColors.grey)),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _fromCurrency = 'YER';
                            _toCurrency = e.key;
                            _fromCtrl.clear();
                            _toCtrl.clear();
                          });
                        },
                      ),
                      if (i < _currencies.length - 2)
                        const Divider(height: 1, indent: 60),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Last updated
            Text(
              'آخر تحديث: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(fontFamily: 'Cairo',
                  fontSize: 12, color: AppColors.grey),
            ),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }

  void _pickCurrency(bool isFrom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, sc) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(isFrom ? 'اختر عملة المصدر' : 'اختر عملة الهدف',
                  style: const TextStyle(fontFamily: 'Cairo',
                      fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: sc,
                children: _currencies.entries.map((e) => ListTile(
                      leading: Text(e.value.flag,
                          style: const TextStyle(fontSize: 26)),
                      title: Text(e.key,
                          style: const TextStyle(fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(e.value.name,
                          style: const TextStyle(fontFamily: 'Cairo',
                              fontSize: 12, color: AppColors.grey)),
                      trailing: (isFrom ? _fromCurrency : _toCurrency) == e.key
                          ? const Icon(Icons.check_circle,
                              color: AppColors.primaryBlue)
                          : null,
                      onTap: () {
                        setState(() {
                          if (isFrom) _fromCurrency = e.key;
                          else _toCurrency = e.key;
                          _fromCtrl.clear();
                          _toCtrl.clear();
                        });
                        Navigator.pop(context);
                      },
                    )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Currency {
  final String name;
  final String flag;
  final double rateToYER;
  const _Currency(this.name, this.flag, this.rateToYER);
}

class _CurrencyField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String currency;
  final String flag;
  final String name;
  final ValueChanged<String> onChanged;
  final VoidCallback onCurrencyTap;

  const _CurrencyField({
    required this.label,
    required this.controller,
    required this.currency,
    required this.flag,
    required this.name,
    required this.onChanged,
    required this.onCurrencyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontFamily: 'Cairo',
                  color: AppColors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: onCurrencyTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Text(currency,
                          style: const TextStyle(fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: AppColors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
                  ],
                  onChanged: onChanged,
                  style: const TextStyle(fontFamily: 'Cairo',
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(fontFamily: 'Cairo',
                        color: AppColors.lightGrey, fontSize: 22),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
