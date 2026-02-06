/// User Flags Model - Special user roles and states
/// Stored in: users/{uid}.flags
class UserFlagsModel {
  /// Admin user (full system access)
  final bool isAdmin;

  /// Moderator user (content moderation)
  final bool isModerator;

  /// Test user (dummy wallet, no real API calls)
  final bool isTestUser;

  const UserFlagsModel({
    required this.isAdmin,
    required this.isModerator,
    required this.isTestUser,
  });

  /// Default flags for new users
  factory UserFlagsModel.defaultFlags() {
    return const UserFlagsModel(
      isAdmin: false,
      isModerator: false,
      isTestUser: false,
    );
  }

  /// Create from map
  factory UserFlagsModel.fromMap(Map<String, dynamic> map) {
    return UserFlagsModel(
      isAdmin: map['isAdmin'] as bool? ?? false,
      isModerator: map['isModerator'] as bool? ?? false,
      isTestUser: map['isTestUser'] as bool? ?? false,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'isAdmin': isAdmin,
      'isModerator': isModerator,
      'isTestUser': isTestUser,
    };
  }

  /// Copy with
  UserFlagsModel copyWith({
    bool? isAdmin,
    bool? isModerator,
    bool? isTestUser,
  }) {
    return UserFlagsModel(
      isAdmin: isAdmin ?? this.isAdmin,
      isModerator: isModerator ?? this.isModerator,
      isTestUser: isTestUser ?? this.isTestUser,
    );
  }

  /// Check if user has any elevated role
  bool get hasElevatedRole => isAdmin || isModerator;
}
