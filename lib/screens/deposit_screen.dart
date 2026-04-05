import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/wallet_provider.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('إيداع رصيد',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentYellow,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
              fontFamily: 'Cairo', fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.credit_card_rounded, size: 20), text: 'بطاقة صراف'),
            Tab(icon: Icon(Icons.account_balance_rounded, size: 20), text: 'تحويل بنكي'),
            Tab(icon: Icon(Icons.store_rounded, size: 20), text: 'وكيل / اتصالات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _CardDepositTab(),
          _BankDepositTab(),
          _AgentDepositTab(),
        ],
      ),
    );
  }
}

// ========================================
// تبويب 1: بطاقة الصراف الآلي
// ========================================
class _CardDepositTab extends StatefulWidget {
  const _CardDepositTab({super.key});

  @override
  State<_CardDepositTab> createState() => _CardDepositTabState();
}

class _CardDepositTabState extends State<_CardDepositTab> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _amountController = TextEditingController();
  bool _obscureCvv = true;
  bool _isFlipped = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // معاينة البطاقة
            _buildCardPreview(),
            const SizedBox(height: AppSizes.paddingL),

            // بيانات البطاقة
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('بيانات البطاقة',
                      style: AppTextStyles.heading3),
                  const SizedBox(height: AppSizes.paddingM),

                  // رقم البطاقة
                  _buildLabel('رقم البطاقة'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        letterSpacing: 3,
                        fontSize: 16),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CardNumberFormatter(),
                    ],
                    decoration: _inputDecoration(
                      hint: '0000  0000  0000  0000',
                      icon: Icons.credit_card_rounded,
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.replaceAll(' ', '').length != 16) {
                        return 'رقم البطاقة يجب أن يكون 16 رقماً';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  // الاسم على البطاقة
                  _buildLabel('الاسم على البطاقة'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cardNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        letterSpacing: 2,
                        fontSize: 14),
                    decoration: _inputDecoration(
                      hint: 'AHMED ALI',
                      icon: Icons.person_outline_rounded,
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) => v == null || v.isEmpty
                        ? 'يرجى إدخال الاسم'
                        : null,
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  Row(
                    children: [
                      // تاريخ الانتهاء
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('تاريخ الانتهاء'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _expiryController,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                _ExpiryFormatter(),
                              ],
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  letterSpacing: 3,
                                  fontSize: 15),
                              decoration: _inputDecoration(
                                hint: 'MM/YY',
                                icon: Icons.calendar_month_rounded,
                              ),
                              validator: (v) {
                                if (v == null || v.length != 5) {
                                  return 'تاريخ غير صحيح';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      // CVV
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('CVV'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              obscureText: _obscureCvv,
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  letterSpacing: 5,
                                  fontSize: 16),
                              decoration: _inputDecoration(
                                hint: '•••',
                                icon: Icons.lock_outline_rounded,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureCvv
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscureCvv = !_obscureCvv),
                                ),
                              ),
                              onTap: () => setState(() => _isFlipped = true),
                              onEditingComplete: () =>
                                  setState(() => _isFlipped = false),
                              validator: (v) => v == null || v.length != 3
                                  ? 'CVV 3 أرقام'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  // المبلغ
                  _buildLabel('المبلغ المراد إيداعه (ريال)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    decoration: _inputDecoration(
                      hint: '0',
                      icon: Icons.attach_money_rounded,
                      suffix: 'ريال',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'يرجى إدخال المبلغ';
                      final a = double.tryParse(v);
                      if (a == null || a <= 0) return 'مبلغ غير صحيح';
                      if (a < 1000) return 'الحد الأدنى 1,000 ريال';
                      return null;
                    },
                  ),

                  // مبالغ سريعة
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [10000, 25000, 50000, 100000].map((a) {
                      return GestureDetector(
                        onTap: () => setState(
                            () => _amountController.text = a.toString()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primaryBlue.withValues(alpha: 0.4)),
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.primaryBlue.withValues(alpha: 0.05),
                          ),
                          child: Text(
                            '${(a / 1000).toStringAsFixed(0)}K',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            Consumer<WalletProvider>(
              builder: (context, wp, _) => CustomButton(
                text: 'إيداع الآن',
                onPressed: wp.isLoading ? null : _handleDeposit,
                isLoading: wp.isLoading,
              ),
            ),

            const SizedBox(height: AppSizes.paddingM),

            // أمان
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded,
                    size: 14, color: AppColors.success),
                const SizedBox(width: 4),
                Text(
                  'معاملة آمنة ومشفرة بـ SSL',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    final cardNum = _cardNumberController.text.isEmpty
        ? '0000  0000  0000  0000'
        : _cardNumberController.text.padRight(19, '0');
    final name = _cardNameController.text.isEmpty
        ? 'CARDHOLDER NAME'
        : _cardNameController.text.toUpperCase();
    final expiry =
        _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _isFlipped
          ? _buildCardBack()
          : Container(
              key: const ValueKey('front'),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryBlue,
                    Color(0xFF1565C0),
                    AppColors.lightBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // نمط دائري خلفي
                  Positioned(
                    top: -30,
                    left: -30,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    right: -20,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الشعار
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Beepay',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.credit_card_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // رقم البطاقة
                        Text(
                          cardNum,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        // الاسم والتاريخ
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('صاحب البطاقة',
                                    style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        fontSize: 10,
                                        fontFamily: 'Cairo')),
                                Text(name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('تاريخ الانتهاء',
                                    style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        fontSize: 10,
                                        fontFamily: 'Cairo')),
                                Text(expiry,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      key: const ValueKey('back'),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), AppColors.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(height: 40, color: Colors.black54),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    color: Colors.white,
                    child: const Center(
                      child: Text('CVV',
                          style: TextStyle(
                              color: AppColors.grey, fontFamily: 'Cairo')),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 60,
                  height: 36,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      _cvvController.text.isEmpty
                          ? '•••'
                          : _cvvController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          fontFamily: 'Cairo'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
      counterText: '',
      prefixIcon: Icon(icon, size: 20),
      suffixText: suffix,
      suffixStyle: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: const BorderSide(color: AppColors.lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: const BorderSide(color: AppColors.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide:
            const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.grey,
        fontSize: 13,
      ),
    );
  }

  Future<void> _handleDeposit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    if (ApiService.isDemoMode) {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      final success = await walletProvider.depositDemo(
        amount: amount,
        method: 'بطاقة الصراف',
      );
      if (!mounted) return;
      if (success) _showSuccess(amount, 'بطاقة الصراف الآلي');
      return;
    }

    // TODO: Real card API integration
    _showSuccess(amount, 'بطاقة الصراف الآلي');
  }

  void _showSuccess(double amount, String method) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _SuccessDialog(
        amount: amount,
        method: method,
        onDone: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ========================================
// تبويب 2: تحويل بنكي
// ========================================
class _BankDepositTab extends StatefulWidget {
  const _BankDepositTab({super.key});

  @override
  State<_BankDepositTab> createState() => _BankDepositTabState();
}

class _BankDepositTabState extends State<_BankDepositTab> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedBank = 'بنك اليمن والخليج';
  bool _confirmed = false;

  final List<String> _banks = [
    'بنك اليمن والخليج',
    'البنك الأهلي اليمني',
    'بنك التضامن الإسلامي',
    'البنك العربي',
    'بنك اليمن الدولي',
    'بنك سبأ الإسلامي',
    'البنك الوطني اليمني',
  ];

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // معلومات الإيداع
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Colors.white70, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'أرسل التحويل إلى الحساب البنكي لـ Beepay ثم أدخل رقم العملية',
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Cairo',
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),

            // حسابات البنوك المستهدفة
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('حسابات Beepay البنكية',
                      style: AppTextStyles.heading3),
                  const SizedBox(height: AppSizes.paddingM),
                  ...[
                    {'bank': 'بنك اليمن والخليج', 'number': '1234-5678-9012', 'iban': 'YE12 YBLK 0000 1234 5678 9012'},
                    {'bank': 'البنك الأهلي اليمني', 'number': '9876-5432-1098', 'iban': 'YE12 NABY 0000 9876 5432 1098'},
                    {'bank': 'بنك التضامن', 'number': '5555-1234-7890', 'iban': 'YE12 TSIB 0000 5555 1234 7890'},
                  ].map((b) => _BankAccountTile(
                      bank: b['bank']!,
                      number: b['number']!,
                      iban: b['iban']!)),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingM),

            // إدخال بيانات التحويل
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('تأكيد التحويل', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSizes.paddingM),

                  // اختيار البنك
                  const Text('البنك المُرسِل',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey),
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBank,
                        isExpanded: true,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.black,
                            fontSize: 14),
                        items: _banks
                            .map((b) =>
                                DropdownMenuItem(value: b, child: Text(b)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedBank = v!),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  // رقم الحوالة / المرجع
                  const Text('رقم العملية / الحوالة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _accountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontFamily: 'Cairo'),
                    decoration: InputDecoration(
                      hintText: 'أدخل رقم العملية البنكية',
                      hintStyle: const TextStyle(fontFamily: 'Cairo'),
                      prefixIcon: const Icon(Icons.receipt_long_rounded),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        borderSide:
                            const BorderSide(color: AppColors.lightGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        borderSide:
                            const BorderSide(color: AppColors.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        borderSide: const BorderSide(
                            color: AppColors.primaryBlue, width: 2),
                      ),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? 'يرجى إدخال رقم العملية'
                        : null,
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  // المبلغ
                  const Text('المبلغ المُحوَّل (ريال)',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: const TextStyle(fontFamily: 'Cairo'),
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                      suffixText: 'ريال',
                      suffixStyle: const TextStyle(
                          fontFamily: 'Cairo', color: AppColors.grey),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        borderSide:
                            const BorderSide(color: AppColors.lightGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        borderSide:
                            const BorderSide(color: AppColors.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        borderSide: const BorderSide(
                            color: AppColors.primaryBlue, width: 2),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'يرجى إدخال المبلغ';
                      final a = double.tryParse(v);
                      if (a == null || a <= 0) return 'مبلغ غير صحيح';
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  // تأكيد
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _confirmed,
                    onChanged: (v) => setState(() => _confirmed = v!),
                    title: const Text(
                      'أؤكد أنني أرسلت التحويل البنكي',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            Consumer<WalletProvider>(
              builder: (context, wp, _) => CustomButton(
                text: 'إرسال طلب الإيداع',
                onPressed:
                    (wp.isLoading || !_confirmed) ? null : _handleDeposit,
                isLoading: wp.isLoading,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeposit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    if (ApiService.isDemoMode) {
      final wp = Provider.of<WalletProvider>(context, listen: false);
      final success = await wp.depositDemo(amount: amount, method: 'تحويل بنكي');
      if (!mounted) return;
      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _SuccessDialog(
            amount: amount,
            method: 'تحويل بنكي',
            subtitle: 'رقم العملية: ${_accountController.text}',
            onDone: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
          ),
        );
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال طلب الإيداع، سيُراجع خلال 24 ساعة',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }
}

// ========================================
// تبويب 3: وكيل / اتصالات
// ========================================
class _AgentDepositTab extends StatelessWidget {
  const _AgentDepositTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // وكيل معتمد
          _MethodSection(
            icon: Icons.store_rounded,
            color: AppColors.success,
            title: 'وكيل Beepay المعتمد',
            steps: const [
              'ابحث عن أقرب وكيل Beepay في منطقتك',
              'أعطِه رقم محفظتك',
              'ادفع المبلغ النقدي',
              'ستصلك رسالة تأكيد فورية',
            ],
            extra: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('أكثر من 500 وكيل',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold)),
                        Text('في جميع محافظات اليمن',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.grey,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          // شبكات الاتصالات
          _MethodSection(
            icon: Icons.phone_android_rounded,
            color: AppColors.warning,
            title: 'شبكات الاتصالات',
            steps: const [
              'أرسل رسالة تحويل من هاتفك',
              'اكتب رقم محفظتك Beepay كوجهة',
              'حدد المبلغ وأرسل',
              'سيُضاف الرصيد تلقائياً',
            ],
            extra: Column(
              children: [
                _TelecomRow('يمن موبايل', '*111#', AppColors.warning),
                const SizedBox(height: 6),
                _TelecomRow('MTN اليمن', '*999#', const Color(0xFFFF6600)),
                const SizedBox(height: 6),
                _TelecomRow('سبأفون', '*131#', const Color(0xFF1565C0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodSection extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<String> steps;
  final Widget? extra;

  const _MethodSection({
    Key? key,
    required this.icon,
    required this.color,
    required this.title,
    required this.steps,
    this.extra,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          ...steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e.value,
                          style: const TextStyle(
                              fontFamily: 'Cairo', fontSize: 14)),
                    ),
                  ],
                ),
              )),
          if (extra != null) ...[
            const SizedBox(height: AppSizes.paddingS),
            extra!,
          ],
        ],
      ),
    );
  }
}

class _TelecomRow extends StatelessWidget {
  final String name;
  final String code;
  final Color color;

  const _TelecomRow(this.name, this.code, this.color, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(name,
                  style: const TextStyle(
                      fontFamily: 'Cairo', fontWeight: FontWeight.w600))),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(code,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    color: color,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _BankAccountTile extends StatelessWidget {
  final String bank;
  final String number;
  final String iban;

  const _BankAccountTile({
    Key? key,
    required this.bank,
    required this.number,
    required this.iban,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_rounded,
              color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bank,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text(number,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 12,
                        letterSpacing: 1)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded,
                size: 18, color: AppColors.primaryBlue),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: iban));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم نسخ رقم الآيبان',
                      style: TextStyle(fontFamily: 'Cairo')),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ========================================
// نافذة النجاح المشتركة
// ========================================
class _SuccessDialog extends StatelessWidget {
  final double amount;
  final String method;
  final String? subtitle;
  final VoidCallback onDone;

  const _SuccessDialog({
    Key? key,
    required this.amount,
    required this.method,
    this.subtitle,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
                color: AppColors.success, shape: BoxShape.circle),
            child:
                const Icon(Icons.check_rounded, color: Colors.white, size: 44),
          ),
          const SizedBox(height: 16),
          const Text('تم الإيداع بنجاح!',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(0)} ريال',
            style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.success,
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
          const SizedBox(height: 4),
          Text(method,
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.grey)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.grey,
                    fontSize: 12)),
          ],
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onDone,
            child:
                const Text('حسناً', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ),
      ],
    );
  }
}

// ========================================
// Formatters
// ========================================
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('  ');
      buffer.write(digits[i]);
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length >= 3) {
      final text = '${digits.substring(0, 2)}/${digits.substring(2)}';
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    return newValue;
  }
}
