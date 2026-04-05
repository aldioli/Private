import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class InternationalTransferScreen extends StatefulWidget {
  const InternationalTransferScreen({super.key});

  @override
  State<InternationalTransferScreen> createState() =>
      _InternationalTransferScreenState();
}

class _InternationalTransferScreenState
    extends State<InternationalTransferScreen> {
  int _step = 0; // 0=country 1=details 2=amount 3=review
  String _selectedCountry = '';
  String _selectedMethod = '';
  final _nameCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _isLoading = false;

  static const _countries = [
    _Country('المملكة العربية السعودية', '🇸🇦', 'SAR', 440.0),
    _Country('الإمارات العربية المتحدة', '🇦🇪', 'AED', 449.0),
    _Country('مصر', '🇪🇬', 'EGP', 33.0),
    _Country('تركيا', '🇹🇷', 'TRY', 51.0),
    _Country('الأردن', '🇯🇴', 'JOD', 2330.0),
    _Country('الكويت', '🇰🇼', 'KWD', 5400.0),
    _Country('قطر', '🇶🇦', 'QAR', 453.0),
    _Country('المملكة المتحدة', '🇬🇧', 'GBP', 2090.0),
    _Country('الولايات المتحدة', '🇺🇸', 'USD', 1650.0),
  ];

  static const _methods = ['تحويل بنكي', 'محفظة إلكترونية', 'وسترن يونيون'];

  _Country? get _country =>
      _countries.where((c) => c.name == _selectedCountry).firstOrNull;

  double get _amountYER => double.tryParse(_amountCtrl.text) ?? 0;
  double get _amountForeign =>
      _country != null && _country!.rateToYER > 0
          ? _amountYER / _country!.rateToYER
          : 0;
  double get _fee => _amountYER * 0.015; // 1.5%
  double get _total => _amountYER + _fee;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _accountCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 0 && _selectedCountry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('اختر دولة الاستلام', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    if (_step == 1 && (_nameCtrl.text.isEmpty || _accountCtrl.text.isEmpty || _selectedMethod.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('أكمل بيانات المستلم', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    if (_step == 2 && _amountYER < 1000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('الحد الأدنى للتحويل الدولي 1,000 ريال',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _confirmTransfer();
    }
  }

  Future<void> _confirmTransfer() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacementNamed(context, '/receipt', arguments: {
      'type': 'transfer',
      'amount': _total,
      'recipient': '${_nameCtrl.text} — $_selectedCountry',
      'reference': 'INTL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'date': DateTime.now(),
      'details': {
        'الدولة': _selectedCountry,
        'طريقة الإرسال': _selectedMethod,
        'المبلغ المُرسَل': '${_amountForeign.toStringAsFixed(2)} ${_country!.currency}',
        'الرسوم': '${_fee.toStringAsFixed(0)} ريال (1.5%)',
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تحويل دولي',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step--),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جارٍ إرسال التحويل الدولي...',
                      style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                _StepBar(step: _step),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    child: [
                      _buildStep0(),
                      _buildStep1(),
                      _buildStep2(),
                      _buildStep3(),
                    ][_step],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                        ),
                      ),
                      child: Text(
                        _step < 3 ? 'التالي' : 'تأكيد التحويل',
                        style: const TextStyle(fontFamily: 'Cairo',
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر دولة الاستلام',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
          ),
          itemCount: _countries.length,
          itemBuilder: (_, i) {
            final c = _countries[i];
            final sel = _selectedCountry == c.name;
            return GestureDetector(
              onTap: () => setState(() => _selectedCountry = c.name),
              child: Container(
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryBlue : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? AppColors.primaryBlue : AppColors.lightGrey,
                    width: sel ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(c.flag, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text(
                      c.name.length > 14 ? '${c.name.substring(0, 12)}..' : c.name,
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    Text(c.currency,
                        style: TextStyle(
                            fontFamily: 'Cairo', fontSize: 10,
                            color: sel ? Colors.white70 : AppColors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('بيانات المستلم'),
        _Field(controller: _nameCtrl, label: 'الاسم الكامل', icon: Icons.person_outline),
        const SizedBox(height: 12),
        _Field(
          controller: _accountCtrl,
          label: _selectedMethod == 'محفظة إلكترونية' ? 'رقم المحفظة' : 'رقم الحساب / IBAN',
          icon: Icons.account_balance_outlined,
          inputType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _SectionLabel('طريقة الإرسال'),
        const SizedBox(height: 8),
        ..._methods.map((m) => GestureDetector(
              onTap: () => setState(() => _selectedMethod = m),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _selectedMethod == m
                      ? AppColors.primaryBlue.withValues(alpha: 0.06)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedMethod == m
                        ? AppColors.primaryBlue
                        : AppColors.lightGrey,
                    width: _selectedMethod == m ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedMethod == m
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _selectedMethod == m ? AppColors.primaryBlue : AppColors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(m,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: _selectedMethod == m
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('المبلغ المُرسَل (بالريال اليمني)'),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontFamily: 'Cairo',
                      fontSize: 32, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(fontFamily: 'Cairo',
                        fontSize: 32, color: AppColors.lightGrey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Text('ريال',
                  style: TextStyle(fontFamily: 'Cairo',
                      fontSize: 18, color: AppColors.grey)),
            ],
          ),
        ),
        if (_amountYER > 0 && _country != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                _CalcRow('المبلغ', '${_amountYER.toStringAsFixed(0)} ريال'),
                _CalcRow('سيصل', '${_amountForeign.toStringAsFixed(2)} ${_country!.currency}'),
                _CalcRow('الرسوم (1.5%)', '${_fee.toStringAsFixed(0)} ريال'),
                const Divider(height: 16),
                _CalcRow('الإجمالي المخصوم', '${_total.toStringAsFixed(0)} ريال',
                    bold: true),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        _Field(controller: _noteCtrl, label: 'ملاحظة (اختياري)', icon: Icons.note_outlined),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingS),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.warning, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'قد يستغرق التحويل الدولي 1-3 أيام عمل حسب الدولة والطريقة.',
                  style: TextStyle(fontFamily: 'Cairo',
                      fontSize: 12, color: AppColors.warning),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('مراجعة التحويل'),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(_country!.flag, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedCountry,
                            style: const TextStyle(fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(_selectedMethod,
                            style: const TextStyle(fontFamily: 'Cairo',
                                color: AppColors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _ReviewRow('المستلم', _nameCtrl.text),
              _ReviewRow('الحساب / المحفظة', _accountCtrl.text),
              _ReviewRow('المبلغ المُرسَل', '${_amountForeign.toStringAsFixed(2)} ${_country!.currency}'),
              _ReviewRow('ما يُخصم منك', '${_total.toStringAsFixed(0)} ريال يمني', bold: true),
              _ReviewRow('رسوم التحويل', '${_fee.toStringAsFixed(0)} ريال (1.5%)'),
              if (_noteCtrl.text.isNotEmpty)
                _ReviewRow('ملاحظة', _noteCtrl.text),
              const Divider(height: 24),
              const Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.grey, size: 16),
                  SizedBox(width: 6),
                  Text('وقت الوصول: 1-3 أيام عمل',
                      style: TextStyle(fontFamily: 'Cairo',
                          color: AppColors.grey, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepBar extends StatelessWidget {
  final int step;
  const _StepBar({required this.step});

  static const _labels = ['الدولة', 'المستلم', 'المبلغ', 'مراجعة'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: i ~/ 2 < step ? AppColors.primaryBlue : AppColors.lightGrey,
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < step;
          final active = idx == step;
          return Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active ? AppColors.primaryBlue : AppColors.lightGrey,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text('${idx + 1}',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: active ? Colors.white : AppColors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 4),
              Text(_labels[idx],
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: active ? AppColors.primaryBlue : AppColors.grey,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal)),
            ],
          );
        }),
      ),
    );
  }
}

class _Country {
  final String name, flag, currency;
  final double rateToYER;
  const _Country(this.name, this.flag, this.currency, this.rateToYER);
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(fontFamily: 'Cairo',
                fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.grey)),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  const _Field({required this.controller, required this.label,
      required this.icon, this.inputType = TextInputType.text});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: inputType,
        style: const TextStyle(fontFamily: 'Cairo'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Cairo'),
          prefixIcon: Icon(icon, color: AppColors.grey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
          filled: true,
          fillColor: AppColors.white,
        ),
      );
}

class _CalcRow extends StatelessWidget {
  final String l, v;
  final bool bold;
  const _CalcRow(this.l, this.v, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Text(l, style: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey, fontSize: 13)),
          const Spacer(),
          Text(v, style: TextStyle(
              fontFamily: 'Cairo', fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: bold ? AppColors.primaryBlue : AppColors.textPrimary)),
        ]),
      );
}

class _ReviewRow extends StatelessWidget {
  final String l, v;
  final bool bold;
  const _ReviewRow(this.l, this.v, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Text(l, style: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey, fontSize: 13)),
          const Spacer(),
          Text(v, style: TextStyle(
              fontFamily: 'Cairo', fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: bold ? 15 : 14,
              color: bold ? AppColors.primaryBlue : AppColors.textPrimary)),
        ]),
      );
}
