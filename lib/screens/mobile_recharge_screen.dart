import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final _phoneCtrl = TextEditingController();
  String _selectedOperator = '';
  double _selectedAmount = 0;
  bool _isLoading = false;

  static const _operators = [
    _Operator('يمن موبايل', Color(0xFF1565C0), Icons.signal_cellular_alt),
    _Operator('سبأفون', Color(0xFFE53935), Icons.signal_cellular_alt_2_bar),
    _Operator('MTN', Color(0xFFFFA000), Icons.signal_cellular_alt_1_bar),
    _Operator('يو', Color(0xFF388E3C), Icons.signal_cellular_connected_no_internet_4_bar),
  ];

  static const _amounts = [500.0, 1000.0, 2000.0, 5000.0, 10000.0, 20000.0];

  static const _savedNumbers = [
    _SavedNumber('أبو أحمد', '777123456', 'يمن موبايل'),
    _SavedNumber('أم محمد', '736789012', 'سبأفون'),
    _SavedNumber('أخي خالد', '711345678', 'MTN'),
  ];

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _recharge() async {
    if (_phoneCtrl.text.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل رقم هاتف صحيح', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_selectedOperator.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختر شركة الاتصالات', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_selectedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختر قيمة الشحن', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    _showConfirmSheet();
  }

  void _showConfirmSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone_android_rounded,
                  color: AppColors.primaryBlue, size: 32),
            ),
            const SizedBox(height: 12),
            const Text('تأكيد شحن الرصيد',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _Row('رقم الهاتف', _phoneCtrl.text),
            _Row('الشبكة', _selectedOperator),
            _Row('المبلغ', '${_selectedAmount.toStringAsFixed(0)} ريال'),
            _Row('الرسوم', 'مجاناً'),
            const Divider(height: 24),
            _Row('الإجمالي', '${_selectedAmount.toStringAsFixed(0)} ريال', bold: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _isLoading = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (!mounted) return;
                  setState(() => _isLoading = false);
                  _showSuccess();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                  ),
                ),
                child: const Text('تأكيد الشحن',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white,
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 50),
            ),
            const SizedBox(height: 16),
            const Text('تم الشحن بنجاح!',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'تم شحن ${_selectedAmount.toStringAsFixed(0)} ريال\nللرقم ${_phoneCtrl.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('حسناً', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('شحن رصيد الهاتف',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جارٍ شحن الرصيد...',
                      style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone number input
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('رقم الهاتف',
                            style: TextStyle(fontFamily: 'Cairo',
                                color: AppColors.grey, fontSize: 13)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('+967',
                                  style: TextStyle(fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9),
                                ],
                                style: const TextStyle(fontFamily: 'Cairo', fontSize: 18),
                                decoration: const InputDecoration(
                                  hintText: '7XX XXX XXX',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Cairo', color: AppColors.lightGrey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.contacts_outlined,
                                  color: AppColors.primaryBlue),
                              onPressed: () => _showSavedNumbers(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // Saved numbers
                  if (_savedNumbers.isNotEmpty) ...[
                    const Text('الأرقام المحفوظة',
                        style: TextStyle(fontFamily: 'Cairo',
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 72,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _savedNumbers.length,
                        itemBuilder: (_, i) {
                          final n = _savedNumbers[i];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _phoneCtrl.text = n.number;
                                _selectedOperator = n.operator;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _phoneCtrl.text == n.number
                                      ? AppColors.primaryBlue
                                      : AppColors.lightGrey,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(n.name,
                                      style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                  Text(n.number,
                                      style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 11,
                                          color: AppColors.grey)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                  ],

                  // Operator selection
                  const Text('شركة الاتصالات',
                      style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                    children: _operators.map((op) {
                      final selected = _selectedOperator == op.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedOperator = op.name),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected ? op.color : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected ? op.color : AppColors.lightGrey,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(op.icon,
                                  color: selected ? Colors.white : op.color,
                                  size: 26),
                              const SizedBox(height: 4),
                              Text(op.name,
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.textPrimary),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // Amount selection
                  const Text('قيمة الشحن',
                      style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.2,
                    children: _amounts.map((amt) {
                      final selected = _selectedAmount == amt;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAmount = amt),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryBlue
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primaryBlue
                                  : AppColors.lightGrey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${amt.toStringAsFixed(0)} ر',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textPrimary),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.paddingXL),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _recharge,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                        ),
                      ),
                      child: Text(
                        _selectedAmount > 0
                            ? 'شحن ${_selectedAmount.toStringAsFixed(0)} ريال'
                            : 'شحن الرصيد',
                        style: const TextStyle(fontFamily: 'Cairo',
                            color: Colors.white, fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXL),
                ],
              ),
            ),
    );
  }

  void _showSavedNumbers() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('الأرقام المحفوظة',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ..._savedNumbers.map((n) => ListTile(
                leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: Icon(Icons.phone, color: Colors.white, size: 20)),
                title: Text(n.name,
                    style: const TextStyle(fontFamily: 'Cairo')),
                subtitle: Text('${n.number} · ${n.operator}',
                    style: const TextStyle(fontFamily: 'Cairo',
                        fontSize: 12, color: AppColors.grey)),
                onTap: () {
                  setState(() {
                    _phoneCtrl.text = n.number;
                    _selectedOperator = n.operator;
                  });
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Operator {
  final String name;
  final Color color;
  final IconData icon;
  const _Operator(this.name, this.color, this.icon);
}

class _SavedNumber {
  final String name;
  final String number;
  final String operator;
  const _SavedNumber(this.name, this.number, this.operator);
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(fontFamily: 'Cairo',
                  color: AppColors.grey, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}
