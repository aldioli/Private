import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/wallet_provider.dart';
import '../utils/constants.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen>
    with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController();
  bool _showAmountQr = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String get _qrData {
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final walletNum = wallet.wallet?.walletNumber ?? '';
    if (_showAmountQr && _amountController.text.isNotEmpty) {
      return 'yemenpay://pay?wallet=$walletNum&amount=${_amountController.text}';
    }
    return 'yemenpay://pay?wallet=$walletNum';
  }

  void _copyWalletNumber(String walletNum) {
    Clipboard.setData(ClipboardData(text: walletNum));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('تم نسخ رقم المحفظة', style: TextStyle(fontFamily: 'Cairo')),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareWalletNumber(String walletNum, String name) {
    // في التطبيق الحقيقي نستخدم share_plus package
    Clipboard.setData(ClipboardData(
        text: 'رقم محفظتي في YemenPay: $walletNum\nالاسم: $name'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ معلومات المشاركة',
            style: TextStyle(fontFamily: 'Cairo')),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('استقبال الأموال',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          final walletNum = walletProvider.wallet?.walletNumber ?? '---';
          final userName =
              walletProvider.wallet?.walletNumber != null ? 'أحمد علي الحمدي' : '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: [
                // بطاقة QR الرئيسية
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.paddingXL),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, Color(0xFF1565C0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.4),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'رمز QR الخاص بي',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // QR
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: QrImageView(
                            data: _qrData,
                            version: QrVersions.auto,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: AppColors.primaryBlue,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // رقم المحفظة
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            walletNum,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _showAmountQr && _amountController.text.isNotEmpty
                              ? 'طلب مبلغ: ${_amountController.text} ريال'
                              : 'امسح الرمز لإرسال المال',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // أزرار الإجراءات
                Row(
                  children: [
                    Expanded(
                      child: _ActionBtn(
                        icon: Icons.copy_rounded,
                        label: 'نسخ الرقم',
                        color: AppColors.primaryBlue,
                        onTap: () => _copyWalletNumber(walletNum),
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: _ActionBtn(
                        icon: Icons.share_rounded,
                        label: 'مشاركة',
                        color: AppColors.success,
                        onTap: () => _shareWalletNumber(walletNum, userName),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingL),

                // طلب مبلغ محدد
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
                      Row(
                        children: [
                          const Icon(Icons.request_quote_outlined,
                              color: AppColors.primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'طلب مبلغ محدد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _showAmountQr,
                            onChanged: (v) {
                              setState(() {
                                _showAmountQr = v;
                                if (!v) _amountController.clear();
                              });
                            },
                            activeColor: AppColors.primaryBlue,
                          ),
                        ],
                      ),
                      if (_showAmountQr) ...[
                        const SizedBox(height: AppSizes.paddingM),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontFamily: 'Cairo'),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'المبلغ المطلوب (ريال)',
                            labelStyle:
                                TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
                            prefixIcon: Icon(Icons.attach_money_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        // مبالغ سريعة
                        Wrap(
                          spacing: 8,
                          children: [5000, 10000, 25000, 50000].map((amt) {
                            return ActionChip(
                              label: Text(
                                '${(amt / 1000).toStringAsFixed(0)}K',
                                style: const TextStyle(
                                    fontFamily: 'Cairo', fontSize: 12),
                              ),
                              onPressed: () {
                                _amountController.text = amt.toString();
                                setState(() {});
                              },
                              backgroundColor:
                                  AppColors.primaryBlue.withValues(alpha: 0.08),
                              side: BorderSide(
                                  color:
                                      AppColors.primaryBlue.withValues(alpha: 0.3)),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // معلومات وتعليمات
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.06),
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                    border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.qr_code_scanner_rounded,
                        text: 'اطلب من المُرسِل مسح رمز QR بتطبيق YemenPay',
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.dialpad_rounded,
                        text: 'أو شارك رقم محفظتك مباشرة',
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.flash_on_rounded,
                        text: 'يُضاف المبلغ فوراً إلى رصيدك',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingXL),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: AppColors.darkGrey,
            ),
          ),
        ),
      ],
    );
  }
}
