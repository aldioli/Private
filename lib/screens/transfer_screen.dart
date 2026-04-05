import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'beneficiaries_screen.dart';

class TransferScreen extends StatefulWidget {
  final String? prefillWallet;
  final String? prefillName;

  const TransferScreen({Key? key, this.prefillWallet, this.prefillName})
      : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _walletNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _recipientName;
  bool _isCheckingWallet = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefillWallet != null) {
      _walletNumberController.text = widget.prefillWallet!;
      _recipientName = widget.prefillName;
    }
  }

  @override
  void dispose() {
    _walletNumberController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text(
          'تحويل أموال',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // المستفيدون السريعون
              _QuickBeneficiaries(
                onSelect: (walletNum, name) {
                  _walletNumberController.text = walletNum;
                  setState(() => _recipientName = name);
                },
              ),
              const SizedBox(height: AppSizes.paddingM),

              // بطاقة معلومات التحويل
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات المستلم',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    
                    // رقم المحفظة
                    CustomTextField(
                      controller: _walletNumberController,
                      labelText: 'رقم المحفظة',
                      hintText: '967771234567',
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      prefixIcon: Icons.account_balance_wallet_outlined,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ماسح QR قيد التطوير'),
                            ),
                          );
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم المحفظة';
                        }
                        if (value.length != AppConstants.walletNumberLength) {
                          return 'رقم المحفظة يجب أن يكون ${AppConstants.walletNumberLength} رقم';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length == AppConstants.walletNumberLength) {
                          _checkWalletNumber(value);
                        } else {
                          setState(() {
                            _recipientName = null;
                          });
                        }
                      },
                    ),
                    
                    // عرض اسم المستلم إذا تم التحقق
                    if (_isCheckingWallet)
                      const Padding(
                        padding: EdgeInsets.only(top: AppSizes.paddingM),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('جاري التحقق...'),
                          ],
                        ),
                      ),
                    
                    if (_recipientName != null && !_isCheckingWallet)
                      Container(
                        margin: const EdgeInsets.only(top: AppSizes.paddingM),
                        padding: const EdgeInsets.all(AppSizes.paddingM),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: AppSizes.paddingS),
                            Expanded(
                              child: Text(
                                'المستلم: $_recipientName',
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSizes.paddingL),
                    
                    // المبلغ
                    const Text(
                      'المبلغ',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    
                    CustomTextField(
                      controller: _amountController,
                      labelText: 'المبلغ (${AppConstants.currencySymbol})',
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.attach_money,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال المبلغ';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'المبلغ غير صحيح';
                        }
                        if (amount < AppConstants.minTransferAmount) {
                          return 'الحد الأدنى ${AppConstants.minTransferAmount.toStringAsFixed(0)} ${AppConstants.currencySymbol}';
                        }
                        if (amount > AppConstants.maxTransferAmount) {
                          return 'الحد الأقصى ${AppConstants.maxTransferAmount.toStringAsFixed(0)} ${AppConstants.currencySymbol}';
                        }
                        
                        // التحقق من الرصيد
                        final balance = Provider.of<WalletProvider>(
                          context,
                          listen: false,
                        ).balance;
                        if (amount > balance) {
                          return 'الرصيد غير كافي';
                        }
                        
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    
                    // أزرار المبالغ السريعة
                    Wrap(
                      spacing: AppSizes.paddingS,
                      runSpacing: AppSizes.paddingS,
                      children: [
                        _QuickAmountButton(
                          amount: 1000,
                          onTap: () => _setAmount(1000),
                        ),
                        _QuickAmountButton(
                          amount: 5000,
                          onTap: () => _setAmount(5000),
                        ),
                        _QuickAmountButton(
                          amount: 10000,
                          onTap: () => _setAmount(10000),
                        ),
                        _QuickAmountButton(
                          amount: 20000,
                          onTap: () => _setAmount(20000),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    
                    // ملاحظة (اختياري)
                    CustomTextField(
                      controller: _descriptionController,
                      labelText: 'ملاحظة (اختياري)',
                      hintText: 'أضف ملاحظة...',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.note_outlined,
                      maxLength: 100,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingXL),
              
              // زر التحويل
              Consumer<WalletProvider>(
                builder: (context, walletProvider, child) {
                  return CustomButton(
                    text: 'تحويل',
                    onPressed: walletProvider.isLoading ? null : _handleTransfer,
                    isLoading: walletProvider.isLoading,
                    icon: Icons.send,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setAmount(double amount) {
    _amountController.text = amount.toStringAsFixed(0);
  }

  Future<void> _checkWalletNumber(String walletNumber) async {
    setState(() {
      _isCheckingWallet = true;
      _recipientName = null;
    });

    try {
      final walletProvider = Provider.of<WalletProvider>(
        context,
        listen: false,
      );
      final result = await walletProvider.checkWalletNumber(walletNumber);
      
      if (result != null && mounted) {
        setState(() {
          _recipientName = result['name'] ?? 'مستخدم Beepay';
          _isCheckingWallet = false;
        });
      } else {
        setState(() {
          _isCheckingWallet = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('رقم المحفظة غير موجود'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isCheckingWallet = false;
      });
    }
  }

  Future<void> _handleTransfer() async {
    if (_formKey.currentState!.validate()) {
      if (_recipientName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى التحقق من رقم المحفظة أولاً'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // عرض تأكيد
      final confirm = await _showConfirmDialog();
      if (confirm == true) {
        _showPinDialog();
      }
    }
  }

  Future<bool?> _showConfirmDialog() {
    final amount = double.parse(_amountController.text);
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تأكيد التحويل',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل تريد تحويل ${amount.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 8),
            Text(
              'إلى: $_recipientName',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Future<void> _showPinDialog() {
    final pinController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'أدخل الرقم السري',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: AppConstants.pinLength,
          decoration: const InputDecoration(
            hintText: '• • • • • •',
            counterText: '',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeTransfer(pinController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Future<void> _completeTransfer(String pin) async {
    if (pin.length != AppConstants.pinLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرقم السري غير صحيح'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    
    final success = await walletProvider.makeTransfer(
      toWallet: _walletNumberController.text,
      amount: double.parse(_amountController.text),
      pin: pin,
      description: _descriptionController.text.isEmpty 
          ? null 
          : _descriptionController.text,
    );

    if (mounted) {
      if (success) {
        _showSuccessDialog(double.parse(_amountController.text));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(walletProvider.errorMessage ?? 'فشل التحويل'),
            backgroundColor: AppColors.error,
          ),
        );
      }
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
                  color: AppColors.primaryBlue, shape: BoxShape.circle),
              child:
                  const Icon(Icons.check_rounded, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 16),
            const Text('تم التحويل بنجاح!',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              '${amount.toStringAsFixed(0)} ريال',
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            const SizedBox(height: 4),
            Text('إلى: $_recipientName',
                style: const TextStyle(
                    fontFamily: 'Cairo', color: AppColors.grey)),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
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

class _QuickAmountButton extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;

  const _QuickAmountButton({
    Key? key,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayAmount = amount >= 1000 
        ? '${(amount / 1000).toStringAsFixed(0)}k' 
        : amount.toStringAsFixed(0);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryBlue),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Text(
          displayAmount,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}

// ========= مستفيدون سريعون =========
class _QuickBeneficiaries extends StatelessWidget {
  final void Function(String walletNumber, String name) onSelect;

  const _QuickBeneficiaries({Key? key, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'المستفيدون',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await Navigator.push<Beneficiary>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const BeneficiariesScreen(selectionMode: true),
                  ),
                );
                if (result != null) {
                  onSelect(result.walletNumber, result.name);
                }
              },
              child: const Text(
                'عرض الكل',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.primaryBlue,
                    fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: demoBeneficiaries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final b = demoBeneficiaries[i];
              return GestureDetector(
                onTap: () => onSelect(b.walletNumber, b.name),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: b.avatarColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isDark
                                ? Colors.white24
                                : Colors.transparent,
                            width: 2),
                      ),
                      child: Center(
                        child: Text(
                          b.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      b.name.split(' ').first,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
