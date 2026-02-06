/// User Permissions Model - Feature access control
/// Stored in: users/{uid}.permissions
class UserPermissionsModel {
  /// Can withdraw funds
  final bool canWithdraw;

  /// Can create community posts
  final bool canPost;

  /// Can perform recharges
  final bool canRecharge;

  /// Can view rewarded ads
  final bool canViewAds;

  /// Can sell products (reselling)
  final bool canSell;

  /// Can complete micro jobs
  final bool canDoJobs;

  /// Can create marketplace listings
  final bool canListMarketplace;

  /// Can convert reward points
  final bool canConvertPoints;

  const UserPermissionsModel({
    required this.canWithdraw,
    required this.canPost,
    required this.canRecharge,
    required this.canViewAds,
    required this.canSell,
    required this.canDoJobs,
    required this.canListMarketplace,
    required this.canConvertPoints,
  });

  /// Default permissions for new users
  factory UserPermissionsModel.defaultPermissions() {
    return const UserPermissionsModel(
      canWithdraw: true,
      canPost: false, // Requires verification
      canRecharge: true,
      canViewAds: true,
      canSell: false, // Requires verification
      canDoJobs: true,
      canListMarketplace: false, // Requires verification
      canConvertPoints: false, // Requires verification
    );
  }

  /// Verified user permissions
  factory UserPermissionsModel.verified() {
    return const UserPermissionsModel(
      canWithdraw: true,
      canPost: true,
      canRecharge: true,
      canViewAds: true,
      canSell: true,
      canDoJobs: true,
      canListMarketplace: true,
      canConvertPoints: true,
    );
  }

  /// Create from map
  factory UserPermissionsModel.fromMap(Map<String, dynamic> map) {
    return UserPermissionsModel(
      canWithdraw: map['canWithdraw'] as bool? ?? true,
      canPost: map['canPost'] as bool? ?? false,
      canRecharge: map['canRecharge'] as bool? ?? true,
      canViewAds: map['canViewAds'] as bool? ?? true,
      canSell: map['canSell'] as bool? ?? false,
      canDoJobs: map['canDoJobs'] as bool? ?? true,
      canListMarketplace: map['canListMarketplace'] as bool? ?? false,
      canConvertPoints: map['canConvertPoints'] as bool? ?? false,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'canWithdraw': canWithdraw,
      'canPost': canPost,
      'canRecharge': canRecharge,
      'canViewAds': canViewAds,
      'canSell': canSell,
      'canDoJobs': canDoJobs,
      'canListMarketplace': canListMarketplace,
      'canConvertPoints': canConvertPoints,
    };
  }

  /// Copy with
  UserPermissionsModel copyWith({
    bool? canWithdraw,
    bool? canPost,
    bool? canRecharge,
    bool? canViewAds,
    bool? canSell,
    bool? canDoJobs,
    bool? canListMarketplace,
    bool? canConvertPoints,
  }) {
    return UserPermissionsModel(
      canWithdraw: canWithdraw ?? this.canWithdraw,
      canPost: canPost ?? this.canPost,
      canRecharge: canRecharge ?? this.canRecharge,
      canViewAds: canViewAds ?? this.canViewAds,
      canSell: canSell ?? this.canSell,
      canDoJobs: canDoJobs ?? this.canDoJobs,
      canListMarketplace: canListMarketplace ?? this.canListMarketplace,
      canConvertPoints: canConvertPoints ?? this.canConvertPoints,
    );
  }
}
