import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  _BillCategory? _selectedCategory;

  final List<_BillCategory> _categories = [
    _BillCategory(
      id: 'electricity',
      name: 'كهرباء',
      icon: Icons.bolt_rounded,
      color: const Color(0xFFFFB300),
      providers: ['يمن كهرباء - صنعاء', 'يمن كهرباء - عدن', 'يمن كهرباء - تعز'],
    ),
    _BillCategory(
      id: 'water',
      name: 'مياه',
      icon: Icons.water_drop_rounded,
      color: const Color(0xFF0288D1),
      providers: ['مؤسسة المياه - صنعاء', 'مؤسسة المياه - عدن'],
    ),
    _BillCategory(
      id: 'internet',
      name: 'إنترنت',
      icon: Icons.wifi_rounded,
      color: const Color(0xFF7B1FA2),
      providers: ['TeleYemen', 'YemenNet', 'MTN Internet'],
    ),
    _BillCategory(
      id: 'mobile',
      name: 'شحن رصيد',
      icon: Icons.phone_android_rounded,
      color: const Color(0xFF388E3C),
      providers: ['يمن موبايل', 'MTN اليمن', 'سبأفون'],
    ),
    _BillCategory(
      id: 'tv',
      name: 'تلفزيون',
      icon: Icons.tv_rounded,
      color: const Color(0xFFE53935),
      providers: ['نايل سات', 'عرب سات', 'OSN'],
    ),
    _BillCategory(
      id: 'other',
      name: 'أخرى',
      icon: Icons.receipt_long_rounded,
      color: const Color(0xFF546E7A),
      providers: ['خدمة حكومية', 'رسوم جامعية', 'تأمين'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('دفع الفواتير',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: _selectedCategory == null
          ? _buildCategoryGrid()
          : _buildPaymentForm(),
    );
  }

  Widget _buildCategoryGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر نوع الفاتورة',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: AppSizes.paddingM),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSizes.paddingM,
              mainAxisSpacing: AppSizes.paddingM,
              childAspectRatio: 1.0,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: cat.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cat.icon, color: cat.color, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSizes.paddingXL),

          // بانر توفير الوقت
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
            child: const Row(
              children: [
                Icon(Icons.flash_on_rounded, color: Colors.white, size: 36),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ادفع فواتيرك بسرعة',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'بدون رسوم إضافية على جميع الفواتير',
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Cairo',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    return _BillPaymentForm(
      category: _selectedCategory!,
      onBack: () => setState(() => _selectedCategory = null),
    );
  }
}

// ========== فورم الدفع ==========

class _BillPaymentForm extends StatefulWidget {
  final _BillCategory category;
  final VoidCallback onBack;

  const _BillPaymentForm({
    Key? key,
    required this.category,
    required this.onBack,
  }) : super(key: key);

  @override
  State<_BillPaymentForm> createState() => _BillPaymentFormState();
}

class _BillPaymentFormState extends State<_BillPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();
  String? _selectedProvider;
  bool _obscurePin = true;
  bool _accountChecked = false;
  String? _accountName;

  @override
  void initState() {
    super.initState();
    _selectedProvider = widget.category.providers.first;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس الفئة المختارة
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
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
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.category.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.category.icon,
                          color: widget.category.color, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.category.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_back_ios_rounded,
                        color: AppColors.grey, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.paddingM),

            // بطاقة التفاصيل
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
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اختيار المزود
                  const Text(
                    'المزود',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey),
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProvider,
                        isExpanded: true,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.black,
                          fontSize: 14,
                        ),
                        items: widget.category.providers
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedProvider = val),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  // رقم الحساب
                  const Text(
                    'رقم الحساب / المشترك',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _accountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontFamily: 'Cairo'),
                          decoration: InputDecoration(
                            hintText: 'أدخل رقم الحساب',
                            hintStyle: const TextStyle(fontFamily: 'Cairo'),
                            prefixIcon: const Icon(Icons.tag_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.borderRadius),
                              borderSide:
                                  const BorderSide(color: AppColors.lightGrey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.borderRadius),
                              borderSide:
                                  const BorderSide(color: AppColors.lightGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.borderRadius),
                              borderSide: const BorderSide(
                                  color: AppColors.primaryBlue, width: 2),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'يرجى إدخال رقم الحساب'
                              : null,
                          onChanged: (_) =>
                              setState(() => _accountChecked = false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _checkAccount,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 50),
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadius),
                          ),
                        ),
                        child: const Text(
                          'تحقق',
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                      ),
                    ],
                  ),

                  if (_accountChecked && _accountName != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: AppColors.success, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _accountName!,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSizes.paddingM),

                  // المبلغ
                  const Text(
                    'المبلغ (ريال)',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
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
                      prefixIcon:
                          const Icon(Icons.attach_money_rounded),
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
                      final amount = double.tryParse(v);
                      if (amount == null || amount <= 0) {
                        return 'مبلغ غير صحيح';
                      }
                      return null;
                    },
                  ),

                  // مبالغ سريعة
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [2000, 5000, 10000, 20000].map((a) {
                      return GestureDetector(
                        onTap: () => setState(
                            () => _amountController.text = a.toString()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primaryBlue.withValues(alpha: 0.4)),
                            borderRadius: BorderRadius.circular(20),
                            color:
                                AppColors.primaryBlue.withValues(alpha: 0.05),
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

                  const SizedBox(height: AppSizes.paddingM),

                  // الرقم السري
                  const Text(
                    'الرقم السري',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: _obscurePin,
                    maxLength: 6,
                    style: const TextStyle(
                        fontFamily: 'Cairo', letterSpacing: 8, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: '• • • • • •',
                      hintStyle: const TextStyle(letterSpacing: 4),
                      counterText: '',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePin
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _obscurePin = !_obscurePin),
                      ),
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
                      if (v == null || v.isEmpty)
                        return 'يرجى إدخال الرقم السري';
                      if (v.length != 6) return 'الرقم السري 6 أرقام';
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // زر الدفع
            Consumer<WalletProvider>(
              builder: (context, wallet, _) {
                return CustomButton(
                  text: 'دفع الفاتورة',
                  onPressed: wallet.isLoading ? null : _handlePayment,
                  isLoading: wallet.isLoading,
                );
              },
            ),

            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }

  void _checkAccount() {
    if (_accountController.text.isEmpty) return;
    setState(() {
      _accountChecked = true;
      _accountName = 'مشترك ${_accountController.text}';
    });
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final walletProvider =
        Provider.of<WalletProvider>(context, listen: false);

    if (amount > walletProvider.balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('رصيدك غير كافٍ', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        title: const Text('تأكيد الدفع',
            style: TextStyle(fontFamily: 'Cairo'),
            textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.category.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.category.icon,
                  color: widget.category.color, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedProvider ?? widget.category.name,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'حساب: ${_accountController.text}',
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 13),
            ),
            const SizedBox(height: 16),
            Text(
              '${amount.toStringAsFixed(0)} ريال',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء',
                style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text('تأكيد الدفع',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final success = await walletProvider.payBill(
      billType: widget.category.id,
      accountNumber: _accountController.text,
      amount: amount,
      pin: _pinController.text,
      description:
          'فاتورة ${widget.category.name} - ${_selectedProvider ?? ''}',
    );

    if (!mounted) return;

    if (success) {
      _showSuccessDialog(amount);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            walletProvider.errorMessage ?? 'فشل الدفع',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
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
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 44),
            ),
            const SizedBox(height: 16),
            const Text(
              'تم الدفع بنجاح!',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${amount.toStringAsFixed(0)} ريال',
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _selectedProvider ?? widget.category.name,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onBack();
              },
              child: const Text('حسناً',
                  style: TextStyle(fontFamily: 'Cairo')),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== نموذج الفئة ==========
class _BillCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> providers;

  const _BillCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.providers,
  });
}
