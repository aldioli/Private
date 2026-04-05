import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';
import 'shimmer_loading.dart';
import '../screens/transaction_detail_screen.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        final transactions = walletProvider.transactions.take(5).toList();

        if (walletProvider.isLoading && transactions.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('آخر المعاملات', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              const TransactionListShimmer(count: 4),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'آخر المعاملات',
                  style: AppTextStyles.heading3,
                ),
                if (transactions.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/transactions');
                    },
                    child: const Text(
                      'عرض الكل',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingM),
            
            if (walletProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.paddingL),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: AppColors.grey,
                      ),
                      SizedBox(height: AppSizes.paddingM),
                      Text(
                        'لا توجد معاملات حتى الآن',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return _TransactionItem(transaction: transaction);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOutgoing = transaction.type == 'transfer' ||
        transaction.type == 'withdrawal';
    
    IconData icon;
    Color iconColor;
    String title;
    
    switch (transaction.type) {
      case 'deposit':
        icon = Icons.arrow_downward;
        iconColor = AppColors.success;
        title = 'إيداع نقدي';
        break;
      case 'withdrawal':
        icon = Icons.arrow_upward;
        iconColor = AppColors.warning;
        title = 'سحب نقدي';
        break;
      case 'transfer':
        icon = Icons.send;
        iconColor = AppColors.primaryBlue;
        title = transaction.recipientName != null
            ? 'تحويل إلى ${transaction.recipientName}'
            : 'تحويل';
        break;
      default:
        icon = Icons.receipt;
        iconColor = AppColors.grey;
        title = transaction.description ?? 'معاملة';
    }
    
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TransactionDetailScreen(transaction: transaction),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          fontFamily: 'Cairo',
        ),
      ),
      subtitle: Text(
        _formatDate(transaction.createdAt),
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.grey,
          fontFamily: 'Cairo',
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isOutgoing ? '-' : '+'}${transaction.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isOutgoing ? AppColors.error : AppColors.success,
              fontFamily: 'Cairo',
            ),
          ),
          if (transaction.isPending)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'معلقة',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.warning,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'الآن';
        }
        return 'منذ ${difference.inMinutes} دقيقة';
      }
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays == 1) {
      return 'أمس ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }
}
