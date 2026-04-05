import 'package:flutter/material.dart';

// ألوان التطبيق - أزرق وأصفر زاهي
class AppColors {
  // الألوان الأساسية
  static const Color primaryBlue = Color(0xFF0D47A1); // أزرق داكن
  static const Color lightBlue = Color(0xFF42A5F5); // أزرق فاتح
  static const Color accentYellow = Color(0xFFFFD600); // أصفر زاهي
  static const Color lightYellow = Color(0xFFFFF59D); // أصفر فاتح
  
  // ألوان إضافية
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);
  
  // ألوان الحالات
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ألوان النص والخلفية
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  // تدرج الألوان
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, lightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient yellowGradient = LinearGradient(
    colors: [accentYellow, lightYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueYellowGradient = LinearGradient(
    colors: [primaryBlue, lightBlue, accentYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// الثوابت العامة
class AppConstants {
  // معلومات التطبيق
  static const String appName = 'YemenPay';
  static const String appVersion = '1.0.0';
  static const String currencySymbol = 'ريال';
  static const String currencyCode = 'YER';
  
  // حدود المعاملات
  static const double minTransferAmount = 100.0;
  static const double maxTransferAmount = 500000.0;
  static const double minWithdrawalAmount = 500.0;
  static const double maxWithdrawalAmount = 200000.0;
  static const double dailyTransferLimit = 1000000.0;
  
  // رسوم المعاملات
  static const double transferFeePercent = 0.0; // مجاني حالياً
  static const double withdrawalFee = 0.0;
  
  // معلومات الاتصال
  static const String supportPhone = '+967 777 123 456';
  static const String supportEmail = 'support@yemenpay.ye';
  static const String website = 'https://yemenpay.ye';
  
  // API (ستحتاج لتغييره للسيرفر الفعلي)
  static const String baseUrl = 'https://api.yemenpay.ye';
  static const String apiVersion = 'v1';
  
  // أطوال الحقول
  static const int phoneLength = 9; // بعد كود الدولة
  static const int pinLength = 8;
  static const int otpLength = 6;
  static const int walletNumberLength = 12;
  
  // أنماط التنسيق
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  
  // مدة الجلسة
  static const int sessionTimeoutMinutes = 15;
  
  // أنواع المعاملات
  static const String transactionTypeTransfer = 'transfer';
  static const String transactionTypeDeposit = 'deposit';
  static const String transactionTypeWithdrawal = 'withdrawal';
  static const String transactionTypePayment = 'payment';
}

// أنماط النصوص
class AppTextStyles {
  // العناوين الكبيرة
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    fontFamily: 'Cairo',
  );
  
  // النصوص العادية
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.black,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.black,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.grey,
    fontFamily: 'Cairo',
  );
  
  // نصوص الأزرار
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    fontFamily: 'Cairo',
  );
  
  // نصوص خاصة
  static const TextStyle balance = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle amount = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
    fontFamily: 'Cairo',
  );
}

// المسافات والأحجام
class AppSizes {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusSmall = 8.0;
  
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  static const double buttonHeight = 50.0;
  static const double inputHeight = 56.0;
}
