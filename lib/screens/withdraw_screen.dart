import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/wallet_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedMethod = 'agent';
  bool _obscurePin = true;

  final List<Map<String, dynamic>> _withdrawMethods = [
    {
      'id': 'agent',
      'title': 'وكيل معتمد',
      'subtitle': 'استلم النقود من أقرب وكيل',
      'icon': Icons.store_outlined,
      'color': AppColors.success,
    },
    {
      'id': 'bank',
      'title': 'تحويل بنكي',
      'subtitle': 'تحويل إلى حسابك البنكي',
      'icon': Icons.account_balance_outlined,
      'color': AppColors.primaryBlue,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title:
            const Text('سحب رصيد', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          final balance = walletProvider.balance;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بطاقة الرصيد المتاح
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLarge),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined,
                            color: Colors.white, size: 32),
                        const SizedBox(width: AppSizes.paddingM),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الرصيد المتاح للسحب',
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              '${balance.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),

                  // المبلغ
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLarge),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('المبلغ', style: AppTextStyles.heading3),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextField(
                          controller: _amountController,
                          labelText:
                              'المبلغ (${AppConstants.currencySymbol})',
                          hintText: '0',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.attach_money,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال المبلغ';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null) return 'المبلغ غير صحيح';
                            if (amount < AppConstants.minWithdrawalAmount) {
                              return 'الحد الأدنى ${AppConstants.minWithdrawalAmount.toStringAsFixed(0)} ${AppConstants.currencySymbol}';
                            }
                            if (amount > AppConstants.maxWithdrawalAmount) {
                              return 'الحد الأقصى ${AppConstants.maxWithdrawalAmount.toStringAsFixed(0)} ${AppConstants.currencySymbol}';
                            }
                            if (amount > balance) {
                              return 'الرصيد غير كافي';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        // زر السحب الكامل
                        TextButton.icon(
                          onPressed: () {
                            _amountController.text =
                                balance.toStringAsFixed(0);
                          },
                          icon: const Icon(Icons.select_all,
                              size: 18, color: AppColors.primaryBlue),
                          label: const Text(
                            'سحب كامل الرصيد',
                            style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontFamily: 'Cairo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),

                  // طريقة السحب
                  const Text('طريقة السحب', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSizes.paddingM),

                  ..._withdrawMethods.map((method) {
                    final isSelected = _selectedMethod == method['id'];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedMethod = method['id']),
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: AppSizes.paddingM),
                        padding: const EdgeInsets.all(AppSizes.paddingM),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (method['color'] as Color).withValues(alpha: 0.05)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(
                              AppSizes.borderRadiusLarge),
                          border: Border.all(
                            color: isSelected
                                ? method['color'] as Color
                                : AppColors.lightGrey,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: (method['color'] as Color)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                method['icon'] as IconData,
                                color: method['color'] as Color,
                              ),
                            ),
                            const SizedBox(width: AppSizes.paddingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  Text(
                                    method['subtitle'] as String,
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 13,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle,
                                  color: method['color'] as Color),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: AppSizes.paddingM),

                  // الرقم السري
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLarge),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('الرقم السري',
                            style: AppTextStyles.heading3),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextField(
                          controller: _pinController,
                          labelText: 'الرقم السري',
                          keyboardType: TextInputType.number,
                          obscureText: _obscurePin,
                          prefixIcon: Icons.lock_outline,
                          maxLength: AppConstants.pinLength,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePin
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.grey,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePin = !_obscurePin),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال الرقم السري';
                            }
                            if (value.length != AppConstants.pinLength) {
                              return 'الرقم السري يجب أن يكون ${AppConstants.pinLength} أرقام';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingXL),

                  CustomButton(
                    text: 'طلب السحب',
                    icon: Icons.arrow_downward,
                    onPressed:
                        walletProvider.isLoading ? null : _handleWithdraw,
                    isLoading: walletProvider.isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleWithdraw() async {
    if (!_formKey.currentState!.validate()) return;

    final walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    final result = await walletProvider.requestWithdrawal(
      amount: double.parse(_amountController.text),
      pin: _pinController.text,
    );

    if (mounted) {
      if (result != null) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                walletProvider.errorMessage ?? 'فشل طلب السحب'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'تم إرسال طلب السحب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتم معالجة طلبك خلال 24 ساعة',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('حسناً',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
