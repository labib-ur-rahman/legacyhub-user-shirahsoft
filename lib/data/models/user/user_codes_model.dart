/// User Codes Model - Invite and referral codes
/// Stored in: users/{uid}.codes
class UserCodesModel {
  /// User's unique invite code (for sharing)
  /// Format: S + 6_CHARS + L (e.g., SA7K9Q2L)
  final String inviteCode;

  /// User's referral code (backend identity)
  /// Usually equals UID
  final String referralCode;

  const UserCodesModel({required this.inviteCode, required this.referralCode});

  /// Empty codes
  factory UserCodesModel.empty() {
    return const UserCodesModel(inviteCode: '', referralCode: '');
  }

  /// Create from map
  factory UserCodesModel.fromMap(Map<String, dynamic> map) {
    return UserCodesModel(
      inviteCode: map['inviteCode']?.toString() ?? '',
      referralCode: map['referralCode']?.toString() ?? '',
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {'inviteCode': inviteCode, 'referralCode': referralCode};
  }

  /// Copy with
  UserCodesModel copyWith({String? inviteCode, String? referralCode}) {
    return UserCodesModel(
      inviteCode: inviteCode ?? this.inviteCode,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  /// Get formatted invite code for display
  /// SA7K9Q2L → SA7K-9Q2L
  String get formattedInviteCode {
    if (inviteCode.length != 8) return inviteCode;
    return '${inviteCode.substring(0, 4)}-${inviteCode.substring(4)}';
  }
}
