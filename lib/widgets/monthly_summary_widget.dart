import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/constants.dart';
import '../screens/analytics_screen.dart';

class MonthlySummaryWidget extends StatelessWidget {
  const MonthlySummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context);
    final txns = wallet.transactions;
    final now = DateTime.now();

    double income = 0;
    double expense = 0;
    int txnCount = 0;

    for (final t in txns) {
      if (t.createdAt.month == now.month && t.createdAt.year == now.year) {
        txnCount++;
        if (t.type == 'deposit') {
          income += t.amount;
        } else if (t.type == 'transfer' || t.type == 'withdrawal') {
          expense += t.amount;
        }
      }
    }

    final savings = income - expense;
    final savingsPct = income > 0 ? (savings / income).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('ملخص هذا الشهر', style: AppTextStyles.heading3),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              ),
              child: const Text(
                'تقرير كامل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D47A1).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      icon: Icons.arrow_downward_rounded,
                      label: 'واردات',
                      amount: income,
                      color: const Color(0xFF69F0AE),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.white24,
                  ),
                  Expanded(
                    child: _SummaryItem(
                      icon: Icons.arrow_upward_rounded,
                      label: 'صادرات',
                      amount: expense,
                      color: const Color(0xFFFF6B6B),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.white24,
                  ),
                  Expanded(
                    child: _SummaryItem(
                      icon: Icons.receipt_long_rounded,
                      label: 'معاملات',
                      amount: txnCount.toDouble(),
                      color: const Color(0xFFFFD600),
                      isCount: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              // شريط التوفير
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'معدل التوفير',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        savings >= 0
                            ? '+ ${savings.toStringAsFixed(0)} ر'
                            : '- ${(-savings).toStringAsFixed(0)} ر',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: savings >= 0
                              ? const Color(0xFF69F0AE)
                              : const Color(0xFFFF6B6B),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: savingsPct.toDouble(),
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        savings >= 0
                            ? const Color(0xFF69F0AE)
                            : const Color(0xFFFF6B6B),
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color color;
  final bool isCount;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
    this.isCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          isCount
              ? amount.toInt().toString()
              : '${amount.toStringAsFixed(0)} ر',
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
