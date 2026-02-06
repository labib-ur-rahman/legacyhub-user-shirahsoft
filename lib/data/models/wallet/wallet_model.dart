import 'package:cloud_firestore/cloud_firestore.dart';

/// Wallet Model - Detailed wallet data
/// Stored in: wallets/{uid}
class WalletModel {
  final String uid;

  /// Current wallet balance (BDT) - withdrawable
  final double balance;

  /// Current reward points - not directly withdrawable
  final int rewardPoints;

  /// Total deposits lifetime
  final double totalDeposits;

  /// Total withdrawals lifetime
  final double totalWithdrawals;

  /// Total earnings lifetime
  final double totalEarnings;

  /// Total reward points earned lifetime
  final int totalRewardPointsEarned;

  /// Total reward points converted lifetime
  final int totalRewardPointsConverted;

  /// Last updated timestamp
  final DateTime? lastUpdated;

  const WalletModel({
    required this.uid,
    required this.balance,
    required this.rewardPoints,
    required this.totalDeposits,
    required this.totalWithdrawals,
    required this.totalEarnings,
    required this.totalRewardPointsEarned,
    required this.totalRewardPointsConverted,
    this.lastUpdated,
  });

  /// Empty wallet
  factory WalletModel.empty(String uid) {
    return WalletModel(
      uid: uid,
      balance: 0.0,
      rewardPoints: 0,
      totalDeposits: 0.0,
      totalWithdrawals: 0.0,
      totalEarnings: 0.0,
      totalRewardPointsEarned: 0,
      totalRewardPointsConverted: 0,
      lastUpdated: null,
    );
  }

  /// Create from Firestore document
  factory WalletModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return WalletModel.fromMap(doc.id, data);
  }

  /// Create from map
  factory WalletModel.fromMap(String uid, Map<String, dynamic> map) {
    return WalletModel(
      uid: uid,
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      rewardPoints: (map['rewardPoints'] as num?)?.toInt() ?? 0,
      totalDeposits: (map['totalDeposits'] as num?)?.toDouble() ?? 0.0,
      totalWithdrawals: (map['totalWithdrawals'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      totalRewardPointsEarned:
          (map['totalRewardPointsEarned'] as num?)?.toInt() ?? 0,
      totalRewardPointsConverted:
          (map['totalRewardPointsConverted'] as num?)?.toInt() ?? 0,
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'balance': balance,
      'rewardPoints': rewardPoints,
      'totalDeposits': totalDeposits,
      'totalWithdrawals': totalWithdrawals,
      'totalEarnings': totalEarnings,
      'totalRewardPointsEarned': totalRewardPointsEarned,
      'totalRewardPointsConverted': totalRewardPointsConverted,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  /// Copy with
  WalletModel copyWith({
    String? uid,
    double? balance,
    int? rewardPoints,
    double? totalDeposits,
    double? totalWithdrawals,
    double? totalEarnings,
    int? totalRewardPointsEarned,
    int? totalRewardPointsConverted,
    DateTime? lastUpdated,
  }) {
    return WalletModel(
      uid: uid ?? this.uid,
      balance: balance ?? this.balance,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      totalDeposits: totalDeposits ?? this.totalDeposits,
      totalWithdrawals: totalWithdrawals ?? this.totalWithdrawals,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      totalRewardPointsEarned:
          totalRewardPointsEarned ?? this.totalRewardPointsEarned,
      totalRewardPointsConverted:
          totalRewardPointsConverted ?? this.totalRewardPointsConverted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Get reward points as BDT equivalent
  /// 100 Reward Points = 1 BDT
  double get rewardPointsAsBDT => rewardPoints / 100;

  /// Get total value (balance + converted points)
  double get totalValue => balance + rewardPointsAsBDT;

  /// Format balance as string
  String get formattedBalance => '৳${balance.toStringAsFixed(2)}';

  /// Format reward points as string
  String get formattedRewardPoints => '$rewardPoints pts';

  /// Check if can afford amount
  bool canAfford(double amount) => balance >= amount;

  /// Check if has enough points to convert
  bool canConvertPoints(int points) => rewardPoints >= points;
}
