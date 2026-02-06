import 'package:cloud_firestore/cloud_firestore.dart';

/// Transaction Type Enum
enum TransactionType {
  deposit,
  withdraw,
  recharge,
  earning,
  conversion,
  refund,
  bonus,
}

/// Transaction Status Enum
enum TransactionStatus { pending, processing, completed, failed, cancelled }

/// Transaction Model - Financial transaction history
/// Stored in: transactions/{transactionId}
class TransactionModel {
  final String id;
  final String uid;
  final TransactionType type;
  final double amount;
  final int rewardPoints;
  final TransactionStatus status;
  final String description;
  final String? reference;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? completedAt;

  const TransactionModel({
    required this.id,
    required this.uid,
    required this.type,
    required this.amount,
    required this.rewardPoints,
    required this.status,
    required this.description,
    this.reference,
    this.metadata,
    this.createdAt,
    this.completedAt,
  });

  /// Create from Firestore document
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TransactionModel(
      id: doc.id,
      uid: data['uid']?.toString() ?? '',
      type: _parseType(data['type']),
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      rewardPoints: (data['rewardPoints'] as num?)?.toInt() ?? 0,
      status: _parseStatus(data['status']),
      description: data['description']?.toString() ?? '',
      reference: data['reference']?.toString(),
      metadata: data['metadata'] as Map<String, dynamic>?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Parse transaction type from string
  static TransactionType _parseType(dynamic value) {
    switch (value?.toString()) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdraw':
        return TransactionType.withdraw;
      case 'recharge':
        return TransactionType.recharge;
      case 'earning':
        return TransactionType.earning;
      case 'conversion':
        return TransactionType.conversion;
      case 'refund':
        return TransactionType.refund;
      case 'bonus':
        return TransactionType.bonus;
      default:
        return TransactionType.earning;
    }
  }

  /// Parse transaction status from string
  static TransactionStatus _parseStatus(dynamic value) {
    switch (value?.toString()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'processing':
        return TransactionStatus.processing;
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'type': type.name,
      'amount': amount,
      'rewardPoints': rewardPoints,
      'status': status.name,
      'description': description,
      'reference': reference,
      'metadata': metadata,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
    };
  }

  /// Copy with
  TransactionModel copyWith({
    String? id,
    String? uid,
    TransactionType? type,
    double? amount,
    int? rewardPoints,
    TransactionStatus? status,
    String? description,
    String? reference,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      status: status ?? this.status,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Check if transaction is credit (adds to balance)
  bool get isCredit =>
      type == TransactionType.deposit ||
      type == TransactionType.earning ||
      type == TransactionType.conversion ||
      type == TransactionType.refund ||
      type == TransactionType.bonus;

  /// Check if transaction is debit (subtracts from balance)
  bool get isDebit =>
      type == TransactionType.withdraw || type == TransactionType.recharge;

  /// Check if transaction is completed
  bool get isCompleted => status == TransactionStatus.completed;

  /// Check if transaction is pending
  bool get isPending => status == TransactionStatus.pending;

  /// Format amount as string
  String get formattedAmount {
    final prefix = isCredit ? '+' : '-';
    return '$prefix৳${amount.toStringAsFixed(2)}';
  }

  /// Get type display name
  String get typeDisplayName {
    switch (type) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.withdraw:
        return 'Withdrawal';
      case TransactionType.recharge:
        return 'Recharge';
      case TransactionType.earning:
        return 'Earning';
      case TransactionType.conversion:
        return 'Points Conversion';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.bonus:
        return 'Bonus';
    }
  }
}
