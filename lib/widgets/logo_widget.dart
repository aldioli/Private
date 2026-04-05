import 'package:flutter/material.dart';
import '../utils/constants.dart';

// شعار التطبيق
class LogoWidget extends StatelessWidget {
  final double size;
  final bool showName;
  
  const LogoWidget({
    Key? key,
    this.size = 100,
    this.showName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.accentYellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // أيقونة المحفظة
              Icon(
                Icons.account_balance_wallet_rounded,
                size: size * 0.5,
                color: AppColors.white,
              ),
              // نجمة صغيرة للتزيين
              Positioned(
                top: size * 0.15,
                right: size * 0.15,
                child: Icon(
                  Icons.star,
                  size: size * 0.15,
                  color: AppColors.accentYellow,
                ),
              ),
            ],
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 12),
          Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ],
    );
  }
}
