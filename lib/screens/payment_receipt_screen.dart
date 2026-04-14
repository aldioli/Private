import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

/// يُمرر له بيانات العملية ويعرض إيصالاً قابلاً للمشاركة
class PaymentReceiptScreen extends StatelessWidget {
  final String type;         // 'transfer' | 'deposit' | 'withdrawal' | 'bill'
  final double amount;
  final String recipient;
  final String reference;
  final DateTime date;
  final Map<String, String> details;

  const PaymentReceiptScreen({
    Key? key,
    required this.type,
    required this.amount,
    required this.recipient,
    required this.reference,
    required this.date,
    this.details = const {},
  }) : super(key: key);

  String get _typeLabel => const {
        'transfer': 'تحويل',
        'deposit': 'إيداع',
        'withdrawal': 'سحب',
        'bill': 'دفع فاتورة',
      }[type] ?? type;

  IconData get _typeIcon => const {
        'transfer': Icons.send_rounded,
        'deposit': Icons.arrow_downward_rounded,
        'withdrawal': Icons.arrow_upward_rounded,
        'bill': Icons.receipt_long_rounded,
      }[type] ?? Icons.receipt_rounded;

  Color get _typeColor => const {
        'transfer': AppColors.primaryBlue,
        'deposit': AppColors.success,
        'withdrawal': AppColors.warning,
        'bill': Color(0xFFE53935),
      }[type] ?? AppColors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إيصال العملية',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _share(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          children: [
            // Success icon + amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingXL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 46),
                  ),
                  const SizedBox(height: 12),
                  const Text('تمت العملية بنجاح',
                      style: TextStyle(fontFamily: 'Cairo',
                          color: AppColors.success, fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    '${amount.toStringAsFixed(2)} ريال',
                    style: const TextStyle(fontFamily: 'Cairo',
                        fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_typeIcon, color: _typeColor, size: 16),
                        const SizedBox(width: 4),
                        Text(_typeLabel,
                            style: TextStyle(fontFamily: 'Cairo',
                                color: _typeColor, fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),

            // Details card
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('تفاصيل العملية',
                      style: TextStyle(fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 16),
                  _DetailRow('المستلم / الجهة', recipient),
                  _DetailRow('التاريخ',
                      DateFormat('d MMMM yyyy').format(date)),
                  _DetailRow('الوقت', DateFormat('h:mm a').format(date)),
                  ...details.entries
                      .map((e) => _DetailRow(e.key, e.value)),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('رقم المرجع',
                                style: TextStyle(fontFamily: 'Cairo',
                                    color: AppColors.grey, fontSize: 12)),
                            SizedBox(height: 2),
                            Text('الحالة',
                                style: TextStyle(fontFamily: 'Cairo',
                                    color: AppColors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: reference));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم نسخ رقم المرجع',
                                        style: TextStyle(fontFamily: 'Cairo')),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(reference,
                                      style: const TextStyle(fontFamily: 'Cairo',
                                          fontSize: 13,
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.copy,
                                      size: 14, color: AppColors.primaryBlue),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('مكتملة',
                                  style: TextStyle(fontFamily: 'Cairo',
                                      color: AppColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _share(context),
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('مشاركة',
                        style: TextStyle(fontFamily: 'Cairo')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    },
                    icon: const Icon(Icons.home_rounded, size: 18),
                    label: const Text('الرئيسية',
                        style: TextStyle(fontFamily: 'Cairo')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
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

  void _share(BuildContext context) {
    final text = '''إيصال عملية - Beepay
━━━━━━━━━━━━━━━
نوع العملية: $_typeLabel
المبلغ: ${amount.toStringAsFixed(2)} ريال
المستلم: $recipient
التاريخ: ${DateFormat('d/M/yyyy h:mm a').format(date)}
رقم المرجع: $reference
الحالة: مكتملة ✅
━━━━━━━━━━━━━━━
Beepay - محفظتك الرقمية''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الإيصال للمشاركة',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(fontFamily: 'Cairo',
                  color: AppColors.grey, fontSize: 13)),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
