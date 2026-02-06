import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legacyhub/data/models/user/user_codes_model.dart';
import 'package:legacyhub/data/models/user/user_flags_model.dart';
import 'package:legacyhub/data/models/user/user_identity_model.dart';
import 'package:legacyhub/data/models/user/user_limits_model.dart';
import 'package:legacyhub/data/models/user/user_meta_model.dart';
import 'package:legacyhub/data/models/user/user_network_model.dart';
import 'package:legacyhub/data/models/user/user_permissions_model.dart';
import 'package:legacyhub/data/models/user/user_status_model.dart';
import 'package:legacyhub/data/models/user/user_wallet_model.dart';

/// User Model - Complete user document structure
/// Represents the core user document in Firestore: users/{uid}
class UserModel {
  final String uid;
  final UserIdentityModel identity;
  final UserCodesModel codes;
  final UserNetworkModel network;
  final UserStatusModel status;
  final UserWalletModel wallet;
  final UserPermissionsModel permissions;
  final UserFlagsModel flags;
  final UserLimitsModel limits;
  final UserMetaModel meta;

  const UserModel({
    required this.uid,
    required this.identity,
    required this.codes,
    required this.network,
    required this.status,
    required this.wallet,
    required this.permissions,
    required this.flags,
    required this.limits,
    required this.meta,
  });

  /// Empty user for initialization
  factory UserModel.empty() {
    return UserModel(
      uid: '',
      identity: UserIdentityModel.empty(),
      codes: UserCodesModel.empty(),
      network: UserNetworkModel.empty(),
      status: UserStatusModel.empty(),
      wallet: UserWalletModel.empty(),
      permissions: UserPermissionsModel.defaultPermissions(),
      flags: UserFlagsModel.defaultFlags(),
      limits: UserLimitsModel.defaultLimits(),
      meta: UserMetaModel.empty(),
    );
  }

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel.fromMap(doc.id, data);
  }

  /// Create from map with UID
  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      identity: UserIdentityModel.fromMap(
        data['identity'] as Map<String, dynamic>? ?? {},
      ),
      codes: UserCodesModel.fromMap(
        data['codes'] as Map<String, dynamic>? ?? {},
      ),
      network: UserNetworkModel.fromMap(
        data['network'] as Map<String, dynamic>? ?? {},
      ),
      status: UserStatusModel.fromMap(
        data['status'] as Map<String, dynamic>? ?? {},
      ),
      wallet: UserWalletModel.fromMap(
        data['wallet'] as Map<String, dynamic>? ?? {},
      ),
      permissions: UserPermissionsModel.fromMap(
        data['permissions'] as Map<String, dynamic>? ?? {},
      ),
      flags: UserFlagsModel.fromMap(
        data['flags'] as Map<String, dynamic>? ?? {},
      ),
      limits: UserLimitsModel.fromMap(
        data['limits'] as Map<String, dynamic>? ?? {},
      ),
      meta: UserMetaModel.fromMap(data['meta'] as Map<String, dynamic>? ?? {}),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'identity': identity.toMap(),
      'codes': codes.toMap(),
      'network': network.toMap(),
      'status': status.toMap(),
      'wallet': wallet.toMap(),
      'permissions': permissions.toMap(),
      'flags': flags.toMap(),
      'limits': limits.toMap(),
      'meta': meta.toMap(),
    };
  }

  /// Create new user document for signup
  Map<String, dynamic> toNewUserFirestore() {
    return {
      'identity': identity.toMap(),
      'codes': codes.toMap(),
      'network': network.toMap(),
      'status': status.toMap(),
      'wallet': wallet.toMap(),
      'permissions': permissions.toMap(),
      'flags': flags.toMap(),
      'limits': limits.toMap(),
      'meta': {
        ...meta.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      },
    };
  }

  /// Copy with
  UserModel copyWith({
    String? uid,
    UserIdentityModel? identity,
    UserCodesModel? codes,
    UserNetworkModel? network,
    UserStatusModel? status,
    UserWalletModel? wallet,
    UserPermissionsModel? permissions,
    UserFlagsModel? flags,
    UserLimitsModel? limits,
    UserMetaModel? meta,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      identity: identity ?? this.identity,
      codes: codes ?? this.codes,
      network: network ?? this.network,
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      permissions: permissions ?? this.permissions,
      flags: flags ?? this.flags,
      limits: limits ?? this.limits,
      meta: meta ?? this.meta,
    );
  }

  /// Check if user is active
  bool get isActive => status.accountState == 'active';

  /// Check if user is verified
  bool get isVerified => status.isVerified;

  /// Check if user is subscribed
  bool get isSubscribed => status.isSubscribed;

  /// Check if user is admin
  bool get isAdmin => flags.isAdmin;

  /// Check if user is moderator
  bool get isModerator => flags.isModerator;

  /// Check if user is test user
  bool get isTestUser => flags.isTestUser;

  /// Get display name
  String get displayName =>
      identity.fullName.isNotEmpty ? identity.fullName : 'User';

  /// Get formatted invite code
  String get formattedInviteCode {
    final code = codes.inviteCode;
    if (code.length != 8) return code;
    return '${code.substring(0, 4)}-${code.substring(4)}';
  }

  @override
  String toString() => 'UserModel(uid: $uid, name: ${identity.fullName})';
}
