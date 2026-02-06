import 'package:cloud_firestore/cloud_firestore.dart';

/// Streak Model - User streak data for ads viewing
/// Stored in: streaks/{uid}
class StreakModel {
  final String uid;

  /// Current streak day count
  final int currentStreak;

  /// Longest streak ever achieved
  final int longestStreak;

  /// Last date user was active (YYYY-MM-DD format)
  final String lastActiveDate;

  /// Current multiplier based on streak
  final double multiplier;

  /// Number of ads watched today
  final int totalAdsToday;

  /// Maximum ads allowed per day
  final int maxAdsPerDay;

  /// Total reward points earned today
  final int pointsEarnedToday;

  const StreakModel({
    required this.uid,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActiveDate,
    required this.multiplier,
    required this.totalAdsToday,
    required this.maxAdsPerDay,
    required this.pointsEarnedToday,
  });

  /// Empty streak for new users
  factory StreakModel.empty(String uid) {
    return StreakModel(
      uid: uid,
      currentStreak: 0,
      longestStreak: 0,
      lastActiveDate: '',
      multiplier: 1.0,
      totalAdsToday: 0,
      maxAdsPerDay: 20,
      pointsEarnedToday: 0,
    );
  }

  /// Create from Firestore document
  factory StreakModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return StreakModel.fromMap(doc.id, data);
  }

  /// Create from map
  factory StreakModel.fromMap(String uid, Map<String, dynamic> map) {
    return StreakModel(
      uid: uid,
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (map['longestStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: map['lastActiveDate']?.toString() ?? '',
      multiplier: (map['multiplier'] as num?)?.toDouble() ?? 1.0,
      totalAdsToday: (map['totalAdsToday'] as num?)?.toInt() ?? 0,
      maxAdsPerDay: (map['maxAdsPerDay'] as num?)?.toInt() ?? 20,
      pointsEarnedToday: (map['pointsEarnedToday'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActiveDate': lastActiveDate,
      'multiplier': multiplier,
      'totalAdsToday': totalAdsToday,
      'maxAdsPerDay': maxAdsPerDay,
      'pointsEarnedToday': pointsEarnedToday,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  /// Copy with
  StreakModel copyWith({
    String? uid,
    int? currentStreak,
    int? longestStreak,
    String? lastActiveDate,
    double? multiplier,
    int? totalAdsToday,
    int? maxAdsPerDay,
    int? pointsEarnedToday,
  }) {
    return StreakModel(
      uid: uid ?? this.uid,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      multiplier: multiplier ?? this.multiplier,
      totalAdsToday: totalAdsToday ?? this.totalAdsToday,
      maxAdsPerDay: maxAdsPerDay ?? this.maxAdsPerDay,
      pointsEarnedToday: pointsEarnedToday ?? this.pointsEarnedToday,
    );
  }

  /// Calculate multiplier based on streak day
  static double getMultiplierForDay(int day) {
    if (day >= 30) return 3.0;
    if (day >= 28) return 3.0;
    if (day >= 26) return 2.8;
    if (day >= 24) return 2.7;
    if (day >= 22) return 2.6;
    if (day >= 20) return 2.5;
    if (day >= 18) return 2.2;
    if (day >= 16) return 2.1;
    if (day >= 14) return 2.0;
    if (day >= 10) return 1.6;
    if (day >= 7) return 1.5;
    if (day >= 5) return 1.2;
    if (day >= 3) return 1.1;
    return 1.0;
  }

  /// Calculate reward points for watching an ad
  int calculateAdReward({int basePoints = 30}) {
    return (basePoints * multiplier).round();
  }

  /// Check if can watch more ads today
  bool get canWatchMoreAds => totalAdsToday < maxAdsPerDay;

  /// Get remaining ads for today
  int get remainingAds => maxAdsPerDay - totalAdsToday;

  /// Get progress percentage for today's ads
  double get adsProgressPercentage => totalAdsToday / maxAdsPerDay;

  /// Format multiplier as string
  String get formattedMultiplier => '${multiplier.toStringAsFixed(1)}x';

  /// Get today's date as string (YYYY-MM-DD)
  static String getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Check if last active was today
  bool get wasActiveToday => lastActiveDate == getTodayDateString();

  /// Check if last active was yesterday
  bool get wasActiveYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayString =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    return lastActiveDate == yesterdayString;
  }
}
