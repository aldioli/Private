import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../screens/transfer_screen.dart';
import '../screens/receive_screen.dart';
import '../screens/deposit_screen.dart';
import 'shimmer_loading.dart';
import 'beepay_loading.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    return Consumer2<WalletProvider, AuthProvider>(
      builder: (context, walletProvider, authProvider, child) {
        if (walletProvider.isLoading && walletProvider.balance == 0) {
          return const BalanceCardShimmer();
        }

        final balance = walletProvider.balance;
        final walletNumber = authProvider.user?.walletNumber ?? '';

        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            gradient: AppColors.blueYellowGradient,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان وزر الإخفاء
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الرصيد الحالي',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _showBalance ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _showBalance = !_showBalance;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              
              // الرصيد
              walletProvider.isLoading
                  ? const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _showBalance
                              ? balance.toStringAsFixed(2)
                              : '••••••',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          AppConstants.currencySymbol,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: AppSizes.paddingM),

              // أزرار الإجراء السريع
              Row(
                children: [
                  _QuickAction(
                    icon: Icons.send_rounded,
                    label: 'تحويل',
                    onTap: () => BeepayTransitionOverlay.navigate(context: context,
                        onNavigate: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const TransferScreen()))),
                  ),
                  _QuickAction(
                    icon: Icons.call_received_rounded,
                    label: 'استقبال',
                    onTap: () => BeepayTransitionOverlay.navigate(context: context,
                        onNavigate: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ReceiveScreen()))),
                  ),
                  _QuickAction(
                    icon: Icons.add_rounded,
                    label: 'إيداع',
                    onTap: () => BeepayTransitionOverlay.navigate(context: context,
                        onNavigate: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const DepositScreen()))),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),

              // رقم المحفظة
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.paddingS,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Expanded(
                      child: Text(
                        'رقم المحفظة: $walletNumber',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: AppColors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: walletNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم نسخ رقم المحفظة',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
