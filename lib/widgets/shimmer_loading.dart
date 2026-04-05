import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/constants.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    Key? key,
    required this.width,
    required this.height,
    this.radius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF3A3A5E) : const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// بطاقة الرصيد أثناء التحميل
class BalanceCardShimmer extends StatelessWidget {
  const BalanceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryBlue.withValues(alpha: 0.7),
      highlightColor: AppColors.primaryBlue.withValues(alpha: 0.4),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
      ),
    );
  }
}

/// قائمة معاملات أثناء التحميل
class TransactionListShimmer extends StatelessWidget {
  final int count;
  const TransactionListShimmer({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            baseColor:
                isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE0E0E0),
            highlightColor:
                isDark ? const Color(0xFF3A3A5E) : const Color(0xFFF5F5F5),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 13,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: 120,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(height: 14, width: 60, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقات إجمالي (statement) أثناء التحميل
class SummaryCardsShimmer extends StatelessWidget {
  const SummaryCardsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor:
          isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF3A3A5E) : const Color(0xFFF5F5F5),
      child: Row(
        children: List.generate(3, (_) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadius),
              ),
            ),
          );
        }),
      ),
    );
  }
}
