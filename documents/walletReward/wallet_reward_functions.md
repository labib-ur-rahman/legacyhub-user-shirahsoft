# Wallet & Reward Functions

## 🌏 Region: `asia-south1` (Mumbai, India)

All functions require the region to be specified in Flutter:
```dart
final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
```

---

## Wallet Functions

### `requestWithdrawal`
**Type:** Callable  
**Auth Required:** Yes  
**Requirements:** User must be verified/subscribed and have sufficient balance

```dart
/// Request a withdrawal from wallet
Future<Map<String, dynamic>> requestWithdrawal({
  required int amount,
  required String paymentMethod, // 'bkash', 'nagad', 'rocket', etc.
  required Map<String, String> paymentDetails,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('requestWithdrawal').call({
    'amount': amount,  // Minimum 100 BDT
    'paymentMethod': paymentMethod,
    'paymentDetails': paymentDetails,
    // Example paymentDetails:
    // { 'accountNumber': '01712345678', 'accountName': 'John Doe' }
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Withdrawal request submitted",
  //   "data": {
  //     "id": "WDR-ABC123...",
  //     "uid": "...",
  //     "amount": 1000,
  //     "fee": 20,        // 20 BDT per 1000
  //     "netAmount": 980, // amount - fee
  //     "paymentMethod": "bkash",
  //     "paymentDetails": {...},
  //     "status": "pending",
  //     "createdAt": "..."
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `getMyWalletTransactions`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Get wallet transaction history
Future<List<Map<String, dynamic>>> getMyWalletTransactions({
  int limit = 50,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getMyWalletTransactions').call({
    'limit': limit,
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Transactions retrieved",
  //   "data": [
  //     {
  //       "id": "WTX-ABC123",
  //       "uid": "...",
  //       "type": "credit" | "debit",
  //       "source": "admin_credit" | "withdrawal" | "reward_conversion",
  //       "amount": 100.0,
  //       "balanceBefore": 500.0,
  //       "balanceAfter": 600.0,
  //       "description": "Admin credit: Bonus",
  //       "reference": "...",
  //       "createdAt": "..."
  //     },
  //     ...
  //   ]
  // }
  final data = Map<String, dynamic>.from(result.data);
  return List<Map<String, dynamic>>.from(
    (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
  );
}
```

---

### `getMyWithdrawalRequests`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Get withdrawal request history
Future<List<Map<String, dynamic>>> getMyWithdrawalRequests({
  int limit = 20,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getMyWithdrawalRequests').call({
    'limit': limit,
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Withdrawal requests retrieved",
  //   "data": [
  //     {
  //       "id": "WDR-ABC123",
  //       "uid": "...",
  //       "amount": 1000,
  //       "fee": 20,
  //       "netAmount": 980,
  //       "paymentMethod": "bkash",
  //       "paymentDetails": {...},
  //       "status": "pending" | "approved" | "rejected" | "completed",
  //       "adminUid": null,
  //       "adminNote": null,
  //       "createdAt": "...",
  //       "processedAt": null
  //     },
  //     ...
  //   ]
  // }
  final data = Map<String, dynamic>.from(result.data);
  return List<Map<String, dynamic>>.from(
    (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
  );
}
```

---

## Reward Functions

### `recordAdView`
**Type:** Callable  
**Auth Required:** Yes  
**Requirements:** User account must be active, not exceeding daily ad limit

```dart
/// Record an ad view and earn reward points
Future<Map<String, dynamic>> recordAdView({
  required String adType,   // 'rewarded', 'interstitial', etc.
  required String deviceId,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('recordAdView').call({
    'adType': adType,
    'deviceId': deviceId,
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Ad view recorded",
  //   "data": {
  //     "pointsEarned": 45,        // 30 base * 1.5x multiplier
  //     "multiplier": 1.5,         // Current streak multiplier
  //     "currentStreak": 7,        // Day 7 streak
  //     "dailyAdsRemaining": 15    // 20 - 5 = 15 remaining
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `convertRewardPoints`
**Type:** Callable  
**Auth Required:** Yes  
**Requirements:** User must be verified/subscribed, minimum 1000 points

```dart
/// Convert reward points to wallet balance
Future<Map<String, dynamic>> convertRewardPoints({
  required int points,  // Minimum 1000 points
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('convertRewardPoints').call({
    'points': points,
  });
  
  // Conversion: 100 points = 1 BDT, 5% fee
  // Example: 1000 points = 10 BDT gross, 0.5 BDT fee, 9.5 BDT net
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Reward points converted successfully",
  //   "data": {
  //     "pointsConverted": 1000,
  //     "amountCredited": 9.5,    // After 5% fee
  //     "fee": 0.5,
  //     "newRewardBalance": 500,
  //     "newWalletBalance": 109.5
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `getStreakInfo`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Get current streak and reward info
Future<Map<String, dynamic>> getStreakInfo() async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getStreakInfo').call();
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Streak info retrieved",
  //   "data": {
  //     "currentStreak": 7,
  //     "highestStreak": 15,
  //     "lastActiveDate": "2026-02-03",
  //     "currentMultiplier": 1.5,   // Day 7 multiplier
  //     "nextMultiplier": 1.5,      // Day 8 multiplier (same tier)
  //     "dailyAdsViewed": 5,
  //     "dailyAdsRemaining": 15,
  //     "dailyMaxPoints": 900       // 30 * 20 * 1.5 = 900 max today
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `getMyRewardTransactions`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Get reward point transaction history
Future<List<Map<String, dynamic>>> getMyRewardTransactions({
  int limit = 50,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getMyRewardTransactions').call({
    'limit': limit,
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Reward transactions retrieved",
  //   "data": [
  //     {
  //       "id": "RPT-ABC123",
  //       "uid": "...",
  //       "type": "credit" | "debit",
  //       "source": "ad_reward" | "subscription_commission" | "verification_commission" | "reward_conversion" | "admin_credit",
  //       "points": 45,
  //       "pointsBefore": 100,
  //       "pointsAfter": 145,
  //       "description": "Ad view reward (1.5x multiplier, Day 7)",
  //       "reference": "...",
  //       "createdAt": "..."
  //     },
  //     ...
  //   ]
  // }
  final data = Map<String, dynamic>.from(result.data);
  return List<Map<String, dynamic>>.from(
    (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
  );
}
```

---

## Streak Multiplier Table

| Day Range | Multiplier | Max Daily Points (20 ads × 30 pts) |
|-----------|------------|-----------------------------------|
| 1-2 | 1.0x | 600 |
| 3-4 | 1.1x | 660 |
| 5-6 | 1.2x | 720 |
| 7-9 | 1.5x | 900 |
| 10-11 | 1.6x | 960 |
| 12-13 | 1.7x | 1,020 |
| 14-15 | 2.0x | 1,200 |
| 16-17 | 2.1x | 1,260 |
| 18-19 | 2.2x | 1,320 |
| 20-21 | 2.5x | 1,500 |
| 22-23 | 2.6x | 1,560 |
| 24-25 | 2.7x | 1,620 |
| 26-27 | 2.8x | 1,680 |
| 28-30+ | 3.0x | 1,800 |

---

## Complete Wallet & Reward Repository Example

```dart
// lib/data/repositories/wallet/wallet_repository.dart
import 'package:cloud_functions/cloud_functions.dart';

class WalletRepository {
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-south1');

  Future<Map<String, dynamic>> requestWithdrawal({
    required int amount,
    required String paymentMethod,
    required Map<String, String> paymentDetails,
  }) async {
    final result = await _functions.httpsCallable('requestWithdrawal').call({
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentDetails': paymentDetails,
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<List<Map<String, dynamic>>> getTransactions({int limit = 50}) async {
    final result = await _functions.httpsCallable('getMyWalletTransactions').call({
      'limit': limit,
    });
    final data = Map<String, dynamic>.from(result.data);
    return List<Map<String, dynamic>>.from(
      (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
    );
  }

  Future<List<Map<String, dynamic>>> getWithdrawals({int limit = 20}) async {
    final result = await _functions.httpsCallable('getMyWithdrawalRequests').call({
      'limit': limit,
    });
    final data = Map<String, dynamic>.from(result.data);
    return List<Map<String, dynamic>>.from(
      (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
    );
  }

  Future<Map<String, dynamic>> recordAdView({
    required String adType,
    required String deviceId,
  }) async {
    final result = await _functions.httpsCallable('recordAdView').call({
      'adType': adType,
      'deviceId': deviceId,
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> convertPoints(int points) async {
    final result = await _functions.httpsCallable('convertRewardPoints').call({
      'points': points,
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> getStreakInfo() async {
    final result = await _functions.httpsCallable('getStreakInfo').call();
    return Map<String, dynamic>.from(result.data);
  }

  Future<List<Map<String, dynamic>>> getRewardTransactions({int limit = 50}) async {
    final result = await _functions.httpsCallable('getMyRewardTransactions').call({
      'limit': limit,
    });
    final data = Map<String, dynamic>.from(result.data);
    return List<Map<String, dynamic>>.from(
      (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
    );
  }
}
```
