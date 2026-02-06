import 'package:cloud_firestore/cloud_firestore.dart';

/// Reward Source Enum
enum RewardSource {
  ads,
  referral,
  subscription,
  verification,
  task,
  bonus,
  dailyLogin,
  streak,
}

/// Reward Transaction Model - Reward point history
/// Stored in: reward_logs/{logId}
class RewardTransactionModel {
  final String id;
  final String uid;
  final RewardSource source;
  final int points;
  final double multiplier;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  const RewardTransactionModel({
    required this.id,
    required this.uid,
    required this.source,
    required this.points,
    required this.multiplier,
    required this.description,
    this.metadata,
    this.createdAt,
  });

  /// Create from Firestore document
  factory RewardTransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return RewardTransactionModel(
      id: doc.id,
      uid: data['uid']?.toString() ?? '',
      source: _parseSource(data['source']),
      points: (data['points'] as num?)?.toInt() ?? 0,
      multiplier: (data['multiplier'] as num?)?.toDouble() ?? 1.0,
      description: data['description']?.toString() ?? '',
      metadata: data['metadata'] as Map<String, dynamic>?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Parse reward source from string
  static RewardSource _parseSource(dynamic value) {
    switch (value?.toString()) {
      case 'ads':
        return RewardSource.ads;
      case 'referral':
        return RewardSource.referral;
      case 'subscription':
        return RewardSource.subscription;
      case 'verification':
        return RewardSource.verification;
      case 'task':
        return RewardSource.task;
      case 'bonus':
        return RewardSource.bonus;
      case 'dailyLogin':
        return RewardSource.dailyLogin;
      case 'streak':
        return RewardSource.streak;
      default:
        return RewardSource.bonus;
    }
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'source': source.name,
      'points': points,
      'multiplier': multiplier,
      'description': description,
      'metadata': metadata,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  /// Copy with
  RewardTransactionModel copyWith({
    String? id,
    String? uid,
    RewardSource? source,
    int? points,
    double? multiplier,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return RewardTransactionModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      source: source ?? this.source,
      points: points ?? this.points,
      multiplier: multiplier ?? this.multiplier,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get base points before multiplier
  int get basePoints => (points / multiplier).round();

  /// Get bonus points from multiplier
  int get bonusPoints => points - basePoints;

  /// Format points as string
  String get formattedPoints => '+$points pts';

  /// Get source display name
  String get sourceDisplayName {
    switch (source) {
      case RewardSource.ads:
        return 'Rewarded Ad';
      case RewardSource.referral:
        return 'Referral Bonus';
      case RewardSource.subscription:
        return 'Subscription Bonus';
      case RewardSource.verification:
        return 'Verification Bonus';
      case RewardSource.task:
        return 'Task Completion';
      case RewardSource.bonus:
        return 'Bonus';
      case RewardSource.dailyLogin:
        return 'Daily Login';
      case RewardSource.streak:
        return 'Streak Bonus';
    }
  }
}
