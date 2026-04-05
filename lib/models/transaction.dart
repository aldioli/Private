// نموذج بيانات المعاملة
class Transaction {
  final String id;
  final String type; // transfer, deposit, withdrawal, payment
  final double amount;
  final double fee;
  final String status; // pending, completed, failed, cancelled
  final String? fromWallet;
  final String? toWallet;
  final String? recipientName;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
  
  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    this.fee = 0.0,
    required this.status,
    this.fromWallet,
    this.toWallet,
    this.recipientName,
    this.description,
    required this.createdAt,
    this.completedAt,
  });
  
  // هل المعاملة مكتملة
  bool get isCompleted => status == 'completed';
  
  // هل المعاملة فاشلة
  bool get isFailed => status == 'failed';
  
  // هل المعاملة معلقة
  bool get isPending => status == 'pending';
  
  // المبلغ الإجمالي (مع الرسوم)
  double get totalAmount => amount + fee;
  
  // تحويل من Supabase (مع join للمرسل والمستلم)
  factory Transaction.fromSupabase(
      Map<String, dynamic> json, String currentUserId) {
    final isSender = json['sender_id'] == currentUserId;
    final sender = json['sender'] as Map<String, dynamic>?;
    final receiver = json['receiver'] as Map<String, dynamic>?;
    final senderPhone =
        sender?['phone']?.toString().replaceAll('+', '') ?? '';
    final receiverPhone =
        receiver?['phone']?.toString().replaceAll('+', '') ?? '';
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? 'transfer',
      amount: (json['amount'] ?? 0).toDouble(),
      fee: 0,
      status: json['status'] ?? 'completed',
      fromWallet: senderPhone,
      toWallet: receiverPhone,
      recipientName: isSender
          ? (receiver?['full_name'] ?? 'مستخدم')
          : (sender?['full_name'] ?? 'مستخدم'),
      description: json['note'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      completedAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // تحويل من JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? 'transfer',
      amount: (json['amount'] ?? 0).toDouble(),
      fee: (json['fee'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      fromWallet: json['from_wallet'],
      toWallet: json['to_wallet'],
      recipientName: json['recipient_name'],
      description: json['description'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }
  
  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'fee': fee,
      'status': status,
      'from_wallet': fromWallet,
      'to_wallet': toWallet,
      'recipient_name': recipientName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
  
  // نسخ مع تعديل
  Transaction copyWith({
    String? id,
    String? type,
    double? amount,
    double? fee,
    String? status,
    String? fromWallet,
    String? toWallet,
    String? recipientName,
    String? description,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      status: status ?? this.status,
      fromWallet: fromWallet ?? this.fromWallet,
      toWallet: toWallet ?? this.toWallet,
      recipientName: recipientName ?? this.recipientName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
