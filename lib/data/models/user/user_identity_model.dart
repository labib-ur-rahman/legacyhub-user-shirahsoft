/// User Identity Model - User profile information
/// Stored in: users/{uid}.identity
class UserIdentityModel {
  final String fullName;
  final String phone;
  final String email;
  final String avatarUrl;
  final bool nidVerified;

  const UserIdentityModel({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.nidVerified,
  });

  /// Empty identity
  factory UserIdentityModel.empty() {
    return const UserIdentityModel(
      fullName: '',
      phone: '',
      email: '',
      avatarUrl: '',
      nidVerified: false,
    );
  }

  /// Create from map
  factory UserIdentityModel.fromMap(Map<String, dynamic> map) {
    return UserIdentityModel(
      fullName: map['fullName']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      avatarUrl: map['avatarUrl']?.toString() ?? '',
      nidVerified: map['nidVerified'] as bool? ?? false,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'avatarUrl': avatarUrl,
      'nidVerified': nidVerified,
    };
  }

  /// Copy with
  UserIdentityModel copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? avatarUrl,
    bool? nidVerified,
  }) {
    return UserIdentityModel(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nidVerified: nidVerified ?? this.nidVerified,
    );
  }

  /// Check if has avatar
  bool get hasAvatar => avatarUrl.isNotEmpty;

  /// Get initials for avatar placeholder
  String get initials {
    if (fullName.isEmpty) return '?';
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }
}
