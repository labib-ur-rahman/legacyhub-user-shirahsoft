import 'dart:async';

import 'package:get/get.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/data/models/user/user_model.dart';
import 'package:legacyhub/data/repositories/user_repository.dart';

/// User Controller
/// Manages current user data and profile operations
class UserController extends GetxController {
  static UserController get instance => Get.find();

  // ===== Repository =====
  final UserRepository _userRepo = UserRepository();
  final FirebaseService _firebase = FirebaseService.instance;

  // ===== Observable State =====
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  // ===== Streams =====
  StreamSubscription<UserModel?>? _userSubscription;

  // ===== Getters =====
  String? get uid => _firebase.currentUserId;
  bool get hasUser => user.value != null;

  // Identity
  String get fullName => user.value?.identity.fullName ?? '';
  String get phone => user.value?.identity.phone ?? '';
  String get email => user.value?.identity.email ?? '';
  String get avatarUrl => user.value?.identity.avatarUrl ?? '';

  // Codes
  String get inviteCode => user.value?.formattedInviteCode ?? '';
  String get referralCode => user.value?.codes.referralCode ?? '';

  // Status
  bool get isActive => user.value?.isActive ?? false;
  bool get isVerified => user.value?.isVerified ?? false;
  bool get isSubscribed => user.value?.isSubscribed ?? false;
  // Note: subscriptionTier not in model, using isSubscribed instead

  // Wallet (snapshot)
  double get balance => user.value?.wallet.balance ?? 0.0;
  int get rewardPoints => user.value?.wallet.rewardPoints ?? 0;

  // Flags
  bool get isAdmin => user.value?.flags.isAdmin ?? false;
  bool get isModerator => user.value?.flags.isModerator ?? false;

  @override
  void onInit() {
    super.onInit();
    _initUserStream();
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }

  /// Initialize user stream
  void _initUserStream() {
    final currentUid = _firebase.currentUserId;
    if (currentUid == null) return;

    _userSubscription = _userRepo
        .streamUser(currentUid)
        .listen(
          (userData) {
            user.value = userData;
          },
          onError: (error) {
            // Silently handle error
          },
        );
  }

  /// Re-initialize when user logs in
  void onUserLoggedIn() {
    _userSubscription?.cancel();
    _initUserStream();
  }

  /// Clear when user logs out
  void onUserLoggedOut() {
    _userSubscription?.cancel();
    user.value = null;
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    final currentUid = _firebase.currentUserId;
    if (currentUid == null) return;

    try {
      isLoading.value = true;
      final userData = await _userRepo.getUser(currentUid);
      user.value = userData;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== PROFILE UPDATES =====

  /// Update user name
  Future<bool> updateName(String newName) async {
    final currentUid = uid;
    if (currentUid == null) return false;

    try {
      isUpdating.value = true;
      await _userRepo.updateName(currentUid, newName);
      return true;
    } catch (e) {
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update user avatar
  Future<bool> updateAvatar(String avatarUrl) async {
    final currentUid = uid;
    if (currentUid == null) return false;

    try {
      isUpdating.value = true;
      await _userRepo.updateAvatar(currentUid, avatarUrl);
      return true;
    } catch (e) {
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update full identity
  Future<bool> updateIdentity({
    String? fullName,
    String? email,
    String? avatarUrl,
  }) async {
    final currentUid = uid;
    if (currentUid == null || user.value == null) return false;

    try {
      isUpdating.value = true;

      final updatedIdentity = user.value!.identity.copyWith(
        fullName: fullName,
        email: email,
        avatarUrl: avatarUrl,
      );

      await _userRepo.updateIdentity(currentUid, updatedIdentity);
      return true;
    } catch (e) {
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // ===== REFERRAL =====

  /// Get direct referrals (users who joined with this user's invite code)
  Future<List<UserModel>> getDirectReferrals() async {
    final currentUid = uid;
    if (currentUid == null) return [];

    return _userRepo.getDirectReferrals(currentUid);
  }

  /// Count direct referrals
  Future<int> countDirectReferrals() async {
    final currentUid = uid;
    if (currentUid == null) return 0;

    return _userRepo.countDirectReferrals(currentUid);
  }
}
