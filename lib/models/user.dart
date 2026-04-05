class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String walletNumber;
  final String email;
  final bool isVerified;
  final double balance;
  final String kycStatus;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.walletNumber = '',
    this.email = '',
    this.isVerified = false,
    this.balance = 0,
    this.kycStatus = 'pending',
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final phone = json['phone'] ?? '';
    // wallet number = phone without '+' (e.g. +967771234567 → 967771234567)
    final derivedWallet = json['wallet_number'] ??
        (phone.isNotEmpty ? phone.replaceAll('+', '') : '');
    return User(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: phone,
      walletNumber: derivedWallet,
      email: json['email'] ?? '',
      isVerified: json['kyc_status'] == 'verified',
      balance: (json['balance'] ?? 0).toDouble(),
      kycStatus: json['kyc_status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phoneNumber,
      'wallet_number': walletNumber,
      'balance': balance,
      'kyc_status': kycStatus,
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? walletNumber,
    String? email,
    bool? isVerified,
    double? balance,
    String? kycStatus,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      walletNumber: walletNumber ?? this.walletNumber,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      balance: balance ?? this.balance,
      kycStatus: kycStatus ?? this.kycStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
