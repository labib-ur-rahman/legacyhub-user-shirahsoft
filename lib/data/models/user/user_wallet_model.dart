/// User Wallet Model - Wallet balance snapshot
/// Stored in: users/{uid}.wallet
/// Note: This is a snapshot. Detailed wallet data is in wallets/{uid}
class UserWalletModel {
  /// Wallet balance in BDT (withdrawable)
  final double balance;

  /// Reward points (not directly withdrawable)
  final int rewardPoints;

  const UserWalletModel({required this.balance, required this.rewardPoints});

  /// Empty wallet
  factory UserWalletModel.empty() {
    return const UserWalletModel(balance: 0.0, rewardPoints: 0);
  }

  /// Create from map
  factory UserWalletModel.fromMap(Map<String, dynamic> map) {
    return UserWalletModel(
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      rewardPoints: (map['rewardPoints'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {'balance': balance, 'rewardPoints': rewardPoints};
  }

  /// Copy with
  UserWalletModel copyWith({double? balance, int? rewardPoints}) {
    return UserWalletModel(
      balance: balance ?? this.balance,
      rewardPoints: rewardPoints ?? this.rewardPoints,
    );
  }

  /// Get reward points as BDT equivalent
  /// 100 Reward Points = 1 BDT
  double get rewardPointsAsBDT => rewardPoints / 100;

  /// Get total value (balance + converted points)
  double get totalValue => balance + rewardPointsAsBDT;

  /// Check if has any balance
  bool get hasBalance => balance > 0;

  /// Check if has any reward points
  bool get hasRewardPoints => rewardPoints > 0;

  /// Format balance as string
  String get formattedBalance => '৳${balance.toStringAsFixed(2)}';

  /// Format reward points as string
  String get formattedRewardPoints => '$rewardPoints pts';
}
