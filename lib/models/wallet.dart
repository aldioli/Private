// نموذج بيانات المحفظة
class Wallet {
  final String walletNumber;
  final double balance;
  final double dailyLimit;
  final double usedDailyLimit;
  final bool isActive;
  final DateTime lastUpdate;
  
  Wallet({
    required this.walletNumber,
    required this.balance,
    this.dailyLimit = 1000000.0,
    this.usedDailyLimit = 0.0,
    this.isActive = true,
    required this.lastUpdate,
  });
  
  // الرصيد المتاح
  double get availableBalance => balance;
  
  // الحد المتبقي اليومي
  double get remainingDailyLimit => dailyLimit - usedDailyLimit;
  
  // تحويل من JSON
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      walletNumber: json['wallet_number'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      dailyLimit: (json['daily_limit'] ?? 1000000).toDouble(),
      usedDailyLimit: (json['used_daily_limit'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? true,
      lastUpdate: json['last_update'] != null 
          ? DateTime.parse(json['last_update']) 
          : DateTime.now(),
    );
  }
  
  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'wallet_number': walletNumber,
      'balance': balance,
      'daily_limit': dailyLimit,
      'used_daily_limit': usedDailyLimit,
      'is_active': isActive,
      'last_update': lastUpdate.toIso8601String(),
    };
  }
  
  // نسخ مع تعديل
  Wallet copyWith({
    String? walletNumber,
    double? balance,
    double? dailyLimit,
    double? usedDailyLimit,
    bool? isActive,
    DateTime? lastUpdate,
  }) {
    return Wallet(
      walletNumber: walletNumber ?? this.walletNumber,
      balance: balance ?? this.balance,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      usedDailyLimit: usedDailyLimit ?? this.usedDailyLimit,
      isActive: isActive ?? this.isActive,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
