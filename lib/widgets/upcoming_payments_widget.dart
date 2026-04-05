import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// بطاقة الدفعات القادمة في الشاشة الرئيسية
class UpcomingPaymentsWidget extends StatelessWidget {
  const UpcomingPaymentsWidget({super.key});

  static const _payments = [
    _Payment(
      title: 'فاتورة الكهرباء',
      dueDate: '22 مارس',
      amount: 45000,
      icon: Icons.bolt_rounded,
      color: Color(0xFFFFA000),
      daysLeft: 3,
    ),
    _Payment(
      title: 'قسط السيارة',
      dueDate: '25 مارس',
      amount: 120000,
      icon: Icons.directions_car_rounded,
      color: Color(0xFF1565C0),
      daysLeft: 6,
    ),
    _Payment(
      title: 'فاتورة الإنترنت',
      dueDate: '30 مارس',
      amount: 18000,
      icon: Icons.wifi_rounded,
      color: Color(0xFF8E24AA),
      daysLeft: 11,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'دفعات قادمة',
              style: AppTextStyles.heading3,
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/scheduled_payments'),
              child: const Text('عرض الكل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.primaryBlue,
                  )),
            ),
          ],
        ),
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
          child: Column(
            children: _payments.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              final isLast = i == _payments.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                        vertical: AppSizes.paddingS),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: p.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(p.icon, color: p.color, size: 20),
                        ),
                        const SizedBox(width: AppSizes.paddingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  )),
                              Text(
                                'استحقاق: ${p.dueDate} • ${p.daysLeft} أيام',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: p.daysLeft <= 3
                                      ? AppColors.error
                                      : AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${p.amount.toStringAsFixed(0)} ريال',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم دفع ${p.title}',
                                        style: const TextStyle(
                                            fontFamily: 'Cairo')),
                                    backgroundColor: AppColors.success,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: p.color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('ادفع',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 56, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _Payment {
  final String title;
  final String dueDate;
  final double amount;
  final IconData icon;
  final Color color;
  final int daysLeft;

  const _Payment({
    required this.title,
    required this.dueDate,
    required this.amount,
    required this.icon,
    required this.color,
    required this.daysLeft,
  });
}
