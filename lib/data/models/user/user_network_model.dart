import 'package:cloud_firestore/cloud_firestore.dart';

/// User Network Model - Network/referral relationship
/// Stored in: users/{uid}.network
class UserNetworkModel {
  /// Direct parent's UID (who invited this user)
  final String? parentUid;

  /// When user joined the network
  final DateTime? joinedAt;

  const UserNetworkModel({this.parentUid, this.joinedAt});

  /// Empty network
  factory UserNetworkModel.empty() {
    return const UserNetworkModel(parentUid: null, joinedAt: null);
  }

  /// Create from map
  factory UserNetworkModel.fromMap(Map<String, dynamic> map) {
    DateTime? joinedAt;
    if (map['joinedAt'] != null) {
      if (map['joinedAt'] is Timestamp) {
        joinedAt = (map['joinedAt'] as Timestamp).toDate();
      } else if (map['joinedAt'] is String) {
        joinedAt = DateTime.tryParse(map['joinedAt'] as String);
      }
    }

    return UserNetworkModel(
      parentUid: map['parentUid']?.toString(),
      joinedAt: joinedAt,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'parentUid': parentUid,
      'joinedAt': joinedAt != null
          ? Timestamp.fromDate(joinedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  /// Copy with
  UserNetworkModel copyWith({String? parentUid, DateTime? joinedAt}) {
    return UserNetworkModel(
      parentUid: parentUid ?? this.parentUid,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  /// Check if user has a parent (was referred)
  bool get hasParent => parentUid != null && parentUid!.isNotEmpty;
}
