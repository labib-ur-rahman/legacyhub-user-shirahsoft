import 'package:cloud_firestore/cloud_firestore.dart';

/// User Meta Model - Analytics and activity tracking
/// Stored in: users/{uid}.meta
class UserMetaModel {
  /// Account creation timestamp
  final DateTime? createdAt;

  /// Last activity timestamp
  final DateTime? lastActiveAt;

  /// Last login timestamp
  final DateTime? lastLoginAt;

  /// Total lifetime earnings (BDT)
  final double totalEarnings;

  /// Total referrals made
  final int totalReferrals;

  /// App version on last login
  final String? appVersion;

  /// Device info on last login
  final String? deviceInfo;

  const UserMetaModel({
    this.createdAt,
    this.lastActiveAt,
    this.lastLoginAt,
    required this.totalEarnings,
    required this.totalReferrals,
    this.appVersion,
    this.deviceInfo,
  });

  /// Empty meta
  factory UserMetaModel.empty() {
    return const UserMetaModel(
      createdAt: null,
      lastActiveAt: null,
      lastLoginAt: null,
      totalEarnings: 0.0,
      totalReferrals: 0,
      appVersion: null,
      deviceInfo: null,
    );
  }

  /// Create from map
  factory UserMetaModel.fromMap(Map<String, dynamic> map) {
    return UserMetaModel(
      createdAt: _parseTimestamp(map['createdAt']),
      lastActiveAt: _parseTimestamp(map['lastActiveAt']),
      lastLoginAt: _parseTimestamp(map['lastLoginAt']),
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      totalReferrals: (map['totalReferrals'] as num?)?.toInt() ?? 0,
      appVersion: map['appVersion']?.toString(),
      deviceInfo: map['deviceInfo']?.toString(),
    );
  }

  /// Parse timestamp from various formats
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'lastActiveAt': lastActiveAt != null
          ? Timestamp.fromDate(lastActiveAt!)
          : FieldValue.serverTimestamp(),
      'lastLoginAt': lastLoginAt != null
          ? Timestamp.fromDate(lastLoginAt!)
          : FieldValue.serverTimestamp(),
      'totalEarnings': totalEarnings,
      'totalReferrals': totalReferrals,
      'appVersion': appVersion,
      'deviceInfo': deviceInfo,
    };
  }

  /// Copy with
  UserMetaModel copyWith({
    DateTime? createdAt,
    DateTime? lastActiveAt,
    DateTime? lastLoginAt,
    double? totalEarnings,
    int? totalReferrals,
    String? appVersion,
    String? deviceInfo,
  }) {
    return UserMetaModel(
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      totalReferrals: totalReferrals ?? this.totalReferrals,
      appVersion: appVersion ?? this.appVersion,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }

  /// Get account age in days
  int get accountAgeDays {
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt!).inDays;
  }
}
