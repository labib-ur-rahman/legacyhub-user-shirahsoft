import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/utils/constants/firebase_paths.dart';
import 'package:legacyhub/core/utils/helpers/invite_code_helper.dart';
import 'package:legacyhub/data/models/user/user_model.dart';
import 'package:legacyhub/data/models/user/user_identity_model.dart';
import 'package:legacyhub/data/models/user/user_codes_model.dart';
import 'package:legacyhub/data/models/user/user_network_model.dart';
import 'package:legacyhub/data/models/user/user_status_model.dart';
import 'package:legacyhub/data/models/user/user_wallet_model.dart';
import 'package:legacyhub/data/models/user/user_permissions_model.dart';
import 'package:legacyhub/data/models/user/user_flags_model.dart';
import 'package:legacyhub/data/models/user/user_limits_model.dart';
import 'package:legacyhub/data/models/user/user_meta_model.dart';

/// User Repository
/// Handles all Firebase operations related to users
class UserRepository {
  final FirebaseService _firebase = FirebaseService.instance;

  // ===== CREATE =====

  /// Create a new user document
  Future<void> createUser(UserModel user) async {
    await _firebase.usersCollection.doc(user.uid).set(user.toFirestore());
  }

  /// Create user with minimal data (during registration)
  Future<UserModel> createNewUser({
    required String uid,
    required String phone,
    String? parentUid,
  }) async {
    // Generate unique invite code
    final inviteCode = await _generateUniqueInviteCode();

    final now = DateTime.now();
    final user = UserModel(
      uid: uid,
      identity: UserIdentityModel(
        phone: phone,
        fullName: '',
        email: '',
        avatarUrl: '',
        nidVerified: false,
      ),
      codes: UserCodesModel(
        inviteCode: inviteCode,
        referralCode: uid, // UID as referral code
      ),
      network: UserNetworkModel(parentUid: parentUid, joinedAt: now),
      status: UserStatusModel(
        accountState: 'active',
        isVerified: false,
        isSubscribed: false,
        riskLevel: 'normal',
      ),
      wallet: UserWalletModel(balance: 0.0, rewardPoints: 0),
      permissions: UserPermissionsModel.defaultPermissions(),
      flags: UserFlagsModel.defaultFlags(),
      limits: UserLimitsModel.defaultLimits(),
      meta: UserMetaModel(
        createdAt: now,
        lastLoginAt: now,
        lastActiveAt: now,
        totalEarnings: 0.0,
        totalReferrals: 0,
        appVersion: '1.0.0',
      ),
    );

    await createUser(user);

    // Register invite code
    await _registerInviteCode(uid, inviteCode);

    return user;
  }

  /// Generate unique invite code
  Future<String> _generateUniqueInviteCode() async {
    String code;
    bool exists;
    int attempts = 0;
    const maxAttempts = 10;

    do {
      code = InviteCodeHelper.generate();
      exists = await _checkInviteCodeExists(code);
      attempts++;
    } while (exists && attempts < maxAttempts);

    if (attempts >= maxAttempts) {
      // Use timestamp-based fallback
      code =
          'S${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}L';
    }

    return code;
  }

  /// Check if invite code exists
  Future<bool> _checkInviteCodeExists(String code) async {
    final doc = await _firebase.firestore
        .collection(FirebasePaths.inviteCodes)
        .doc(code)
        .get();
    return doc.exists;
  }

  /// Register invite code in lookup collection
  Future<void> _registerInviteCode(String uid, String inviteCode) async {
    await _firebase.firestore
        .collection(FirebasePaths.inviteCodes)
        .doc(inviteCode)
        .set({'uid': uid, 'createdAt': FieldValue.serverTimestamp()});
  }

  // ===== READ =====

  /// Get user by UID
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firebase.usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser() async {
    final uid = _firebase.currentUserId;
    if (uid == null) return null;
    return getUser(uid);
  }

  /// Stream user data
  Stream<UserModel?> streamUser(String uid) {
    return _firebase.usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Stream current user data
  Stream<UserModel?> streamCurrentUser() {
    final uid = _firebase.currentUserId;
    if (uid == null) return Stream.value(null);
    return streamUser(uid);
  }

  /// Get user by invite code
  Future<UserModel?> getUserByInviteCode(String inviteCode) async {
    final cleanCode = InviteCodeHelper.unformat(inviteCode);

    // Lookup in invite_codes collection
    final inviteDoc = await _firebase.firestore
        .collection(FirebasePaths.inviteCodes)
        .doc(cleanCode)
        .get();

    if (!inviteDoc.exists) return null;

    final uid = inviteDoc.data()?['uid'] as String?;
    if (uid == null) return null;

    return getUser(uid);
  }

  /// Get user by phone number
  Future<UserModel?> getUserByPhone(String phone) async {
    final query = await _firebase.usersCollection
        .where('identity.phone', isEqualTo: phone)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return UserModel.fromFirestore(query.docs.first);
  }

  // ===== UPDATE =====

  /// Update user document
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    data['meta.lastActivityAt'] = FieldValue.serverTimestamp();
    await _firebase.usersCollection.doc(uid).update(data);
  }

  /// Update user identity
  Future<void> updateIdentity(String uid, UserIdentityModel identity) async {
    await updateUser(uid, {'identity': identity.toMap()});
  }

  /// Update user avatar
  Future<void> updateAvatar(String uid, String avatarUrl) async {
    await updateUser(uid, {'identity.avatarUrl': avatarUrl});
  }

  /// Update user name
  Future<void> updateName(String uid, String fullName) async {
    await updateUser(uid, {'identity.fullName': fullName});
  }

  /// Update user status
  Future<void> updateStatus(String uid, UserStatusModel status) async {
    await updateUser(uid, {'status': status.toMap()});
  }

  /// Update subscription status
  Future<void> updateSubscription({
    required String uid,
    required bool subscribed,
    String? tier,
    DateTime? expiry,
  }) async {
    await updateUser(uid, {
      'status.subscribed': subscribed,
      'status.subscriptionTier': tier,
      'status.subscriptionExpiry': expiry != null
          ? Timestamp.fromDate(expiry)
          : null,
    });
  }

  /// Update verification status
  Future<void> updateVerification(String uid, bool verified) async {
    await updateUser(uid, {'status.verified': verified});
  }

  /// Update last login
  Future<void> updateLastLogin(String uid) async {
    await _firebase.usersCollection.doc(uid).update({
      'meta.lastLogin': FieldValue.serverTimestamp(),
      'meta.lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update wallet snapshot (sync from wallet subcollection)
  Future<void> updateWalletSnapshot(
    String uid, {
    required double balance,
    required int rewardPoints,
  }) async {
    await updateUser(uid, {
      'wallet.balance': balance,
      'wallet.rewardPoints': rewardPoints,
    });
  }

  // ===== DELETE =====

  /// Deactivate user (soft delete)
  Future<void> deactivateUser(String uid) async {
    await updateUser(uid, {'status.accountState': 'deactivated'});
  }

  /// Suspend user
  Future<void> suspendUser(String uid, {String? reason}) async {
    await updateUser(uid, {
      'status.accountState': 'suspended',
      'meta.suspendReason': reason,
      'meta.suspendedAt': FieldValue.serverTimestamp(),
    });
  }

  // ===== NETWORK =====

  /// Get direct referrals (children)
  Future<List<UserModel>> getDirectReferrals(String uid) async {
    final query = await _firebase.usersCollection
        .where('network.parentUid', isEqualTo: uid)
        .orderBy('network.joinedAt', descending: true)
        .get();

    return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  /// Count direct referrals
  Future<int> countDirectReferrals(String uid) async {
    final query = await _firebase.usersCollection
        .where('network.parentUid', isEqualTo: uid)
        .count()
        .get();

    return query.count ?? 0;
  }
}
