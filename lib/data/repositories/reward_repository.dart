import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/utils/constants/firebase_paths.dart';
import 'package:legacyhub/data/models/reward/streak_model.dart';
import 'package:legacyhub/data/models/reward/reward_transaction_model.dart';

/// Reward Repository
/// Handles all Firebase operations related to rewards and streaks
class RewardRepository {
  final FirebaseService _firebase = FirebaseService.instance;

  // ===== STREAK =====

  /// Get streak by UID
  Future<StreakModel?> getStreak(String uid) async {
    final doc = await _firebase.firestore
        .collection(FirebasePaths.streaks)
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return StreakModel.fromFirestore(doc);
  }

  /// Stream streak data
  Stream<StreakModel?> streamStreak(String uid) {
    return _firebase.firestore
        .collection(FirebasePaths.streaks)
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return StreakModel.fromFirestore(doc);
        });
  }

  /// Get current user's streak
  Future<StreakModel?> getCurrentStreak() async {
    final uid = _firebase.currentUserId;
    if (uid == null) return null;
    return getStreak(uid);
  }

  /// Stream current user's streak
  Stream<StreakModel?> streamCurrentStreak() {
    final uid = _firebase.currentUserId;
    if (uid == null) return Stream.value(null);
    return streamStreak(uid);
  }

  /// Initialize streak for new user
  Future<void> initializeStreak(String uid) async {
    final streak = StreakModel.empty(uid);
    await _firebase.firestore
        .collection(FirebasePaths.streaks)
        .doc(uid)
        .set(streak.toFirestore());
  }

  /// Update streak after watching ad
  /// Note: This should be called from Cloud Functions for security
  Future<void> updateStreakAfterAd(String uid) async {
    final streak = await getStreak(uid);
    if (streak == null) return;

    final today = StreakModel.getTodayDateString();
    int newStreak = streak.currentStreak;
    int newAdsToday = streak.totalAdsToday;

    // Check if continuing streak
    if (!streak.wasActiveToday) {
      if (streak.wasActiveYesterday) {
        // Continue streak
        newStreak++;
      } else if (streak.lastActiveDate.isNotEmpty) {
        // Streak broken, reset to 1
        newStreak = 1;
      } else {
        // First time user
        newStreak = 1;
      }
      newAdsToday = 1;
    } else {
      // Same day, increment ads count
      newAdsToday++;
    }

    // Calculate new multiplier
    final newMultiplier = StreakModel.getMultiplierForDay(newStreak);

    await _firebase.firestore
        .collection(FirebasePaths.streaks)
        .doc(uid)
        .update({
          'currentStreak': newStreak,
          'longestStreak': newStreak > streak.longestStreak
              ? newStreak
              : streak.longestStreak,
          'lastActiveDate': today,
          'multiplier': newMultiplier,
          'totalAdsToday': newAdsToday,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
  }

  /// Reset daily ad count (called at midnight by Cloud Scheduler)
  Future<void> resetDailyAdCount(String uid) async {
    await _firebase.firestore.collection(FirebasePaths.streaks).doc(uid).update(
      {'totalAdsToday': 0, 'pointsEarnedToday': 0},
    );
  }

  // ===== REWARD LOGS =====

  /// Get reward transaction logs
  Future<List<RewardTransactionModel>> getRewardLogs(
    String uid, {
    int limit = 20,
    DocumentSnapshot? startAfter,
    RewardSource? source,
  }) async {
    Query query = _firebase.firestore
        .collection(FirebasePaths.rewardLogs)
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true);

    if (source != null) {
      query = query.where('source', isEqualTo: source.name);
    }

    query = query.limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => RewardTransactionModel.fromFirestore(doc))
        .toList();
  }

  /// Stream recent reward logs
  Stream<List<RewardTransactionModel>> streamRecentRewardLogs(
    String uid, {
    int limit = 10,
  }) {
    return _firebase.firestore
        .collection(FirebasePaths.rewardLogs)
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RewardTransactionModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Log reward earned
  /// Note: This should be called from Cloud Functions for security
  Future<String> logReward({
    required String uid,
    required RewardSource source,
    required int points,
    required double multiplier,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final log = RewardTransactionModel(
      id: '',
      uid: uid,
      source: source,
      points: points,
      multiplier: multiplier,
      description: description,
      metadata: metadata,
    );

    final docRef = await _firebase.firestore
        .collection(FirebasePaths.rewardLogs)
        .add(log.toFirestore());

    return docRef.id;
  }

  // ===== AD REWARDS =====

  /// Record ad watched (creates reward log)
  /// Note: Actual point crediting should be done via Cloud Functions
  Future<void> recordAdWatched({
    required String uid,
    required int basePoints,
    required double multiplier,
    String? adNetwork,
    String? adId,
  }) async {
    final points = (basePoints * multiplier).round();

    await logReward(
      uid: uid,
      source: RewardSource.ads,
      points: points,
      multiplier: multiplier,
      description: 'Earned $points points from watching ad',
      metadata: {
        'basePoints': basePoints,
        'adNetwork': adNetwork,
        'adId': adId,
      },
    );

    // Update today's points in streak
    final streakRef = _firebase.firestore
        .collection(FirebasePaths.streaks)
        .doc(uid);

    await streakRef.update({'pointsEarnedToday': FieldValue.increment(points)});
  }

  // ===== STATISTICS =====

  /// Get total points earned today
  Future<int> getTodayPointsEarned(String uid) async {
    final streak = await getStreak(uid);
    return streak?.pointsEarnedToday ?? 0;
  }

  /// Get total ads watched today
  Future<int> getTodayAdsWatched(String uid) async {
    final streak = await getStreak(uid);
    return streak?.totalAdsToday ?? 0;
  }

  /// Check if can watch more ads today
  Future<bool> canWatchMoreAds(String uid) async {
    final streak = await getStreak(uid);
    return streak?.canWatchMoreAds ?? true;
  }
}
