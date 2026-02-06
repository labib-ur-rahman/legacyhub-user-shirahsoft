import 'dart:async';

import 'package:get/get.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/common/widgets/popups/custom_snackbar.dart';
import 'package:legacyhub/data/models/reward/streak_model.dart';
import 'package:legacyhub/data/models/reward/reward_transaction_model.dart';
import 'package:legacyhub/data/repositories/reward_repository.dart';

/// Reward Controller
/// Manages reward points, streaks, and ad watching
class RewardController extends GetxController {
  static RewardController get instance => Get.find();

  // ===== Repository =====
  final RewardRepository _rewardRepo = RewardRepository();
  final FirebaseService _firebase = FirebaseService.instance;

  // ===== Observable State =====
  final Rx<StreakModel?> streak = Rx<StreakModel?>(null);
  final RxList<RewardTransactionModel> rewardLogs =
      <RewardTransactionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isWatchingAd = false.obs;

  // ===== Streams =====
  StreamSubscription<StreakModel?>? _streakSubscription;

  // ===== Getters =====
  int get currentStreak => streak.value?.currentStreak ?? 0;
  int get longestStreak => streak.value?.longestStreak ?? 0;
  double get multiplier => streak.value?.multiplier ?? 1.0;
  String get formattedMultiplier => streak.value?.formattedMultiplier ?? '1.0x';
  int get adsWatchedToday => streak.value?.totalAdsToday ?? 0;
  int get maxAdsPerDay => streak.value?.maxAdsPerDay ?? 20;
  int get remainingAds => streak.value?.remainingAds ?? 20;
  bool get canWatchAd => streak.value?.canWatchMoreAds ?? true;
  int get pointsEarnedToday => streak.value?.pointsEarnedToday ?? 0;
  double get adsProgressPercentage =>
      streak.value?.adsProgressPercentage ?? 0.0;

  @override
  void onInit() {
    super.onInit();
    _initStreakStream();
  }

  @override
  void onClose() {
    _streakSubscription?.cancel();
    super.onClose();
  }

  /// Initialize streak stream
  void _initStreakStream() {
    final uid = _firebase.currentUserId;
    if (uid == null) return;

    _streakSubscription = _rewardRepo
        .streamStreak(uid)
        .listen(
          (streakData) {
            streak.value = streakData;
          },
          onError: (error) {
            // Silently fail
          },
        );
  }

  /// Refresh streak data
  Future<void> refreshStreak() async {
    final uid = _firebase.currentUserId;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final streakData = await _rewardRepo.getStreak(uid);
      streak.value = streakData;
    } finally {
      isLoading.value = false;
    }
  }

  /// Load reward logs
  Future<void> loadRewardLogs({RewardSource? source}) async {
    final uid = _firebase.currentUserId;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final logs = await _rewardRepo.getRewardLogs(
        uid,
        source: source,
        limit: 50,
      );
      rewardLogs.value = logs;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== AD WATCHING =====

  /// Called before showing an ad
  Future<bool> prepareToWatchAd() async {
    if (!canWatchAd) {
      AppSnackBar.showInfoSnackBar(
        title: 'Daily Limit Reached',
        message: 'You\'ve watched all $maxAdsPerDay ads for today',
      );
      return false;
    }

    isWatchingAd.value = true;
    return true;
  }

  /// Called after successfully watching an ad
  Future<void> onAdWatched({
    int basePoints = 30,
    String? adNetwork,
    String? adId,
  }) async {
    final uid = _firebase.currentUserId;
    if (uid == null) return;

    try {
      // Record the ad watch
      await _rewardRepo.recordAdWatched(
        uid: uid,
        basePoints: basePoints,
        multiplier: multiplier,
        adNetwork: adNetwork,
        adId: adId,
      );

      // Update streak
      await _rewardRepo.updateStreakAfterAd(uid);

      final earnedPoints = (basePoints * multiplier).round();

      AppSnackBar.successSnackBar(
        title: '+$earnedPoints Points!',
        message: 'Streak: Day $currentStreak • $formattedMultiplier',
      );
    } catch (e) {
      AppSnackBar.errorSnackBar(
        title: 'Error',
        message: 'Failed to record reward',
      );
    } finally {
      isWatchingAd.value = false;
    }
  }

  /// Called when ad fails to load or user cancels
  void onAdCancelled() {
    isWatchingAd.value = false;
  }

  /// Called when ad fails
  void onAdFailed(String? error) {
    isWatchingAd.value = false;
    AppSnackBar.errorSnackBar(
      title: 'Ad Failed',
      message: error ?? 'Failed to load ad',
    );
  }

  // ===== HELPERS =====

  /// Calculate estimated points for next ad
  int get nextAdReward => streak.value?.calculateAdReward() ?? 30;

  /// Get streak milestone message
  String? get streakMilestoneMessage {
    final day = currentStreak;
    if (day == 3) return '🔥 3 Day Streak! +10% bonus!';
    if (day == 5) return '🔥 5 Day Streak! +20% bonus!';
    if (day == 7) return '⭐ 1 Week Streak! +50% bonus!';
    if (day == 14) return '⭐ 2 Week Streak! 2x multiplier!';
    if (day == 30) return '🏆 1 Month Streak! 3x multiplier!';
    return null;
  }

  /// Check if streak is at risk (last active yesterday, not yet today)
  bool get isStreakAtRisk {
    if (streak.value == null) return false;
    return streak.value!.wasActiveYesterday && !streak.value!.wasActiveToday;
  }
}
