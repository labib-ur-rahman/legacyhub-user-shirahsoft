/// User Status Model - Account status and verification
/// Stored in: users/{uid}.status
class UserStatusModel {
  /// Account state: active, suspended, banned, deleted
  final String accountState;

  /// Profile verified (250 BDT)
  final bool isVerified;

  /// Lifetime subscription (400 BDT)
  final bool isSubscribed;

  /// Risk level: normal, watch, high, fraud
  final String riskLevel;

  const UserStatusModel({
    required this.accountState,
    required this.isVerified,
    required this.isSubscribed,
    required this.riskLevel,
  });

  /// Empty status (new user defaults)
  factory UserStatusModel.empty() {
    return const UserStatusModel(
      accountState: 'active',
      isVerified: false,
      isSubscribed: false,
      riskLevel: 'normal',
    );
  }

  /// Create from map
  factory UserStatusModel.fromMap(Map<String, dynamic> map) {
    return UserStatusModel(
      accountState: map['accountState']?.toString() ?? 'active',
      isVerified: map['isVerified'] as bool? ?? false,
      isSubscribed: map['isSubscribed'] as bool? ?? false,
      riskLevel: map['riskLevel']?.toString() ?? 'normal',
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'accountState': accountState,
      'isVerified': isVerified,
      'isSubscribed': isSubscribed,
      'riskLevel': riskLevel,
    };
  }

  /// Copy with
  UserStatusModel copyWith({
    String? accountState,
    bool? isVerified,
    bool? isSubscribed,
    String? riskLevel,
  }) {
    return UserStatusModel(
      accountState: accountState ?? this.accountState,
      isVerified: isVerified ?? this.isVerified,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }

  /// Check if account is active
  bool get isActive => accountState == 'active';

  /// Check if account is suspended
  bool get isSuspended => accountState == 'suspended';

  /// Check if account is banned
  bool get isBanned => accountState == 'banned';

  /// Check if account is deleted
  bool get isDeleted => accountState == 'deleted';

  /// Check if user has any premium status
  bool get hasPremiumStatus => isVerified || isSubscribed;

  /// Check if high risk
  bool get isHighRisk => riskLevel == 'high' || riskLevel == 'fraud';
}
