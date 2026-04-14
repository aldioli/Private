import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../models/transaction.dart';
import '../utils/constants.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOutgoing =
        transaction.type == 'transfer' || transaction.type == 'withdrawal';

    IconData icon;
    Color iconColor;
    String typeLabel;

    switch (transaction.type) {
      case 'deposit':
        icon = Icons.arrow_downward_rounded;
        iconColor = AppColors.success;
        typeLabel = 'إيداع';
        break;
      case 'withdrawal':
        icon = Icons.arrow_upward_rounded;
        iconColor = AppColors.warning;
        typeLabel = 'سحب';
        break;
      case 'transfer':
        icon = Icons.send_rounded;
        iconColor = AppColors.primaryBlue;
        typeLabel = 'تحويل';
        break;
      default:
        icon = Icons.receipt_rounded;
        iconColor = AppColors.grey;
        typeLabel = 'معاملة';
    }

    return Scaffold(
      backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text('تفاصيل المعاملة',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareTransaction(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            // بطاقة الحالة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingXL),
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
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 40),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${isOutgoing ? '-' : '+'}${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: isOutgoing ? AppColors.error : AppColors.success,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  Text(
                    AppConstants.currencySymbol,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 18,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  _StatusChip(status: transaction.status),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // تفاصيل المعاملة
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
                  const Text('تفاصيل المعاملة',
                      style: AppTextStyles.heading3),
                  const SizedBox(height: AppSizes.paddingM),
                  _DetailRow(
                    label: 'رقم المعاملة',
                    value: transaction.id,
                    copyable: true,
                  ),
                  _DetailRow(label: 'النوع', value: typeLabel),
                  if (transaction.toWallet != null)
                    _DetailRow(
                      label: 'المحفظة المستلمة',
                      value: transaction.toWallet!,
                      copyable: true,
                    ),
                  if (transaction.fromWallet != null)
                    _DetailRow(
                      label: 'المحفظة المرسلة',
                      value: transaction.fromWallet!,
                      copyable: true,
                    ),
                  if (transaction.recipientName != null)
                    _DetailRow(
                      label: 'اسم المستلم',
                      value: transaction.recipientName!,
                    ),
                  _DetailRow(
                    label: 'المبلغ',
                    value:
                        '${transaction.amount.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
                  ),
                  if (transaction.fee > 0)
                    _DetailRow(
                      label: 'الرسوم',
                      value:
                          '${transaction.fee.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
                    ),
                  _DetailRow(
                    label: 'التاريخ والوقت',
                    value: DateFormat('yyyy/MM/dd - HH:mm')
                        .format(transaction.createdAt),
                  ),
                  if (transaction.description != null &&
                      transaction.description!.isNotEmpty)
                    _DetailRow(
                      label: 'الملاحظة',
                      value: transaction.description!,
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // زر إعادة المعاملة (للتحويلات فقط)
            if (transaction.type == 'transfer') ...[
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transfer');
                  },
                  icon: const Icon(Icons.repeat_rounded,
                      color: AppColors.primaryBlue),
                  label: const Text(
                    'تحويل مرة أخرى',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _shareTransaction(BuildContext context) {
    final text =
        'معاملة Beepay\nالنوع: ${transaction.type}\nالمبلغ: ${transaction.amount} ${AppConstants.currencySymbol}\nالتاريخ: ${DateFormat('yyyy/MM/dd').format(transaction.createdAt)}\nالرقم: ${transaction.id}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ تفاصيل المعاملة',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;

  const _DetailRow({
    Key? key,
    required this.label,
    required this.value,
    this.copyable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.grey,
              fontFamily: 'Cairo',
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  value.length > 20 ? '${value.substring(0, 20)}...' : value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    fontSize: 14,
                  ),
                ),
              ),
              if (copyable) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم النسخ',
                            style: TextStyle(fontFamily: 'Cairo')),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(Icons.copy_outlined,
                      size: 16, color: AppColors.grey),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;
    switch (status) {
      case 'completed':
        color = AppColors.success;
        label = 'مكتملة';
        icon = Icons.check_circle_outline;
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'قيد المعالجة';
        icon = Icons.access_time;
        break;
      case 'failed':
        color = AppColors.error;
        label = 'فاشلة';
        icon = Icons.cancel_outlined;
        break;
      default:
        color = AppColors.grey;
        label = status;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
