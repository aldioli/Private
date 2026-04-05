import 'package:flutter/material.dart';
import '../utils/constants.dart';

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
            color: const Color(0xFFFFD600),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD600).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.25),
            child: Image.asset(
              'assets/images/app_icon.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
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
