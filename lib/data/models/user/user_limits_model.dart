/// User Limits Model - Rate limiting and abuse prevention
/// Stored in: users/{uid}.limits
class UserLimitsModel {
  /// Maximum withdrawal per day (BDT)
  final double dailyWithdrawLimit;

  /// Maximum recharge per day (BDT)
  final double dailyRechargeLimit;

  /// Maximum ads per day
  final int dailyAdsLimit;

  /// Maximum point conversions per day
  final int dailyConversionLimit;

  /// Maximum posts per day
  final int dailyPostLimit;

  /// Maximum job submissions per day
  final int dailyJobLimit;

  const UserLimitsModel({
    required this.dailyWithdrawLimit,
    required this.dailyRechargeLimit,
    required this.dailyAdsLimit,
    required this.dailyConversionLimit,
    required this.dailyPostLimit,
    required this.dailyJobLimit,
  });

  /// Default limits for new users
  factory UserLimitsModel.defaultLimits() {
    return const UserLimitsModel(
      dailyWithdrawLimit: 5000.0,
      dailyRechargeLimit: 10000.0,
      dailyAdsLimit: 20,
      dailyConversionLimit: 2,
      dailyPostLimit: 5,
      dailyJobLimit: 10,
    );
  }

  /// Premium limits for verified/subscribed users
  factory UserLimitsModel.premiumLimits() {
    return const UserLimitsModel(
      dailyWithdrawLimit: 20000.0,
      dailyRechargeLimit: 50000.0,
      dailyAdsLimit: 30,
      dailyConversionLimit: 5,
      dailyPostLimit: 20,
      dailyJobLimit: 50,
    );
  }

  /// Create from map
  factory UserLimitsModel.fromMap(Map<String, dynamic> map) {
    return UserLimitsModel(
      dailyWithdrawLimit:
          (map['dailyWithdrawLimit'] as num?)?.toDouble() ?? 5000.0,
      dailyRechargeLimit:
          (map['dailyRechargeLimit'] as num?)?.toDouble() ?? 10000.0,
      dailyAdsLimit: (map['dailyAdsLimit'] as num?)?.toInt() ?? 20,
      dailyConversionLimit: (map['dailyConversionLimit'] as num?)?.toInt() ?? 2,
      dailyPostLimit: (map['dailyPostLimit'] as num?)?.toInt() ?? 5,
      dailyJobLimit: (map['dailyJobLimit'] as num?)?.toInt() ?? 10,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'dailyWithdrawLimit': dailyWithdrawLimit,
      'dailyRechargeLimit': dailyRechargeLimit,
      'dailyAdsLimit': dailyAdsLimit,
      'dailyConversionLimit': dailyConversionLimit,
      'dailyPostLimit': dailyPostLimit,
      'dailyJobLimit': dailyJobLimit,
    };
  }

  /// Copy with
  UserLimitsModel copyWith({
    double? dailyWithdrawLimit,
    double? dailyRechargeLimit,
    int? dailyAdsLimit,
    int? dailyConversionLimit,
    int? dailyPostLimit,
    int? dailyJobLimit,
  }) {
    return UserLimitsModel(
      dailyWithdrawLimit: dailyWithdrawLimit ?? this.dailyWithdrawLimit,
      dailyRechargeLimit: dailyRechargeLimit ?? this.dailyRechargeLimit,
      dailyAdsLimit: dailyAdsLimit ?? this.dailyAdsLimit,
      dailyConversionLimit: dailyConversionLimit ?? this.dailyConversionLimit,
      dailyPostLimit: dailyPostLimit ?? this.dailyPostLimit,
      dailyJobLimit: dailyJobLimit ?? this.dailyJobLimit,
    );
  }
}
