# Firebase Functions Quick Reference

## 🌏 Region Configuration

All functions are deployed to **`asia-south1`** (Mumbai, India) for optimal latency to Bangladesh users.

**Important:** When calling functions from Flutter, you must specify the region:

```dart
final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
```

---

## 🚀 All Available Functions

### Auth Triggers (Internal - Not called from Flutter)
| Function | Trigger | Description |
|----------|---------|-------------|
| `onUserLogin` | beforeSignIn | Update last login timestamp |
| `onUserDeleted` | onDelete | Soft delete user document |

### User Functions (Called from Flutter)
| Function | Auth | Description |
|----------|------|-------------|
| `createUser` | No | Create new user with invite code |
| `completeGoogleSignIn` | Yes | Complete Google OAuth signup |
| `getUserProfile` | Yes | Get own profile |
| `updateUserProfile` | Yes | Update own profile |

### Auth Functions (Called from Flutter)
| Function | Auth | Description |
|----------|------|-------------|
| `verifyUserProfile` | Yes | Verify user after payment |
| `subscribeUser` | Yes | Subscribe user after payment |
| `checkAuthStatus` | No | Check if authenticated |

### Wallet Functions (Called from Flutter)
| Function | Auth | Description |
|----------|------|-------------|
| `getMyWalletTransactions` | Yes | Get transaction history |
| `getMyWithdrawalRequests` | Yes | Get withdrawal history |
| `requestWithdrawal` | Yes | Request payout |

### Reward Functions (Called from Flutter)
| Function | Auth | Description |
|----------|------|-------------|
| `recordAdView` | Yes | Log ad view for points |
| `convertRewardPoints` | Yes | Convert points to BDT |
| `getStreakInfo` | Yes | Get current streak info |
| `getMyRewardTransactions` | Yes | Get reward history |

### Permission Functions (Called from Flutter)
| Function | Auth | Admin+ |
|----------|------|--------|
| `getMyPermissions` | Yes | - |
| `getUserPermissions` | Yes | Support+ |
| `grantUserPermissions` | Yes | Admin+ |
| `revokeUserPermissions` | Yes | Admin+ |
| `changeUserRole` | Yes | Admin+ |

### Admin Functions (Called from Flutter Admin Panel)
| Function | Auth | Permission |
|----------|------|------------|
| `suspendUser` | Yes | user.suspend |
| `banUser` | Yes | user.ban |
| `unbanUser` | Yes | user.unban |
| `setUserRiskLevel` | Yes | user.risk |
| `adminCreditWallet` | Yes | wallet.credit |
| `adminCreditRewardPoints` | Yes | reward.credit |
| `adminLockWallet` | Yes | wallet.lock |
| `adminUnlockWallet` | Yes | wallet.unlock |
| `getPendingWithdrawals` | Yes | withdraw.review |
| `approveWithdrawal` | Yes | withdraw.approve |
| `rejectWithdrawal` | Yes | withdraw.reject |
| `getAdminUserDetails` | Yes | user.view |
| `searchUsers` | Yes | user.search |

---

## 📦 Collections Reference

| Collection | Description |
|------------|-------------|
| `users` | Main user documents |
| `invite_codes` | Code → UID mapping |
| `user_uplines` | Cached 15-level uplines |
| `user_relations` | Upline-downline relationships |
| `user_network_stats` | Network counters |
| `wallet_transactions` | Money movement logs |
| `reward_transactions` | Point movement logs |
| `withdrawal_requests` | Payout requests |
| `admin_permissions` | RBAC permissions |
| `audit_logs` | Admin action logs |
| `streak_data` | Daily streak tracking |
| `ad_view_logs` | Ad view history |

---

## 💰 Key Constants

```dart
// Reward Points
const int POINTS_PER_BDT = 100;        // 100 points = 1 BDT
const int POINTS_PER_AD = 30;          // Base points per ad
const int MAX_DAILY_ADS = 20;          // Max ads per day
const int MIN_CONVERSION_POINTS = 1000; // Minimum 1000 points to convert

// Streak Multipliers (30 days)
// Day 1-2: 1.0x | Day 3-4: 1.1x | Day 5-6: 1.2x
// Day 7-9: 1.5x | Day 10-11: 1.6x | Day 12-13: 1.7x
// Day 14-15: 2.0x | Day 16-17: 2.1x | Day 18-19: 2.2x
// Day 20-21: 2.5x | Day 22-23: 2.6x | Day 24-25: 2.7x
// Day 26-27: 2.8x | Day 28-30+: 3.0x (max)

// Withdrawal
const int MIN_WITHDRAWAL_BDT = 100;
const int WITHDRAWAL_FEE_PER_1000 = 20; // 20 BDT per 1000

// Roles (hierarchy)
// superAdmin (highest) > admin > moderator > support > user (lowest)
```

---

## 🔧 Flutter Service Setup

### Base Cloud Functions Service

```dart
// lib/core/services/cloud_functions_service.dart
import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  CloudFunctionsService._();
  static final CloudFunctionsService instance = CloudFunctionsService._();

  // IMPORTANT: Use asia-south1 region for Bangladesh users
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-south1',
  );

  /// Call a Cloud Function with error handling
  Future<Map<String, dynamic>> call(
    String functionName, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final result = await _functions
          .httpsCallable(functionName)
          .call(data ?? {});
      
      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw CloudFunctionException(
        code: e.code,
        message: e.message ?? 'Function call failed',
        details: e.details,
      );
    }
  }
}

class CloudFunctionException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  CloudFunctionException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'CloudFunctionException: [$code] $message';
}
```

---

## 📝 Response Format

```dart
// Success Response
{
  "success": true,
  "message": "Optional success message",
  "data": { ... }  // Optional data object
}

// Error Response (thrown as FirebaseFunctionsException)
// code: 'unauthenticated' | 'permission-denied' | 'not-found' | etc.
// message: "Human readable message"
```

---

## 🔐 Error Codes

| Code | Meaning |
|------|---------|
| `unauthenticated` | Not logged in |
| `permission-denied` | Insufficient permissions |
| `not-found` | Resource not found |
| `invalid-argument` | Bad request data |
| `already-exists` | Duplicate resource |
| `failed-precondition` | Business rule violation |
| `internal` | Server error |

---

## 📂 Functions File Structure

```
functions/src/
├── index.ts              # All exports
├── config/
│   └── constants.ts      # Business rules + REGION = 'asia-south1'
├── types/
│   └── index.ts          # TypeScript interfaces
├── utils/
│   ├── helpers.ts        # Common utilities
│   └── validators.ts     # Request validation
└── features/
    ├── admin/index.ts    # Admin operations (13 functions)
    ├── audit/index.ts    # Audit logging (internal)
    ├── auth/index.ts     # Auth triggers + verify/subscribe
    ├── invite-codes/index.ts  # Internal invite code functions
    ├── network/index.ts  # Internal network functions
    ├── permissions/index.ts  # RBAC functions (5 functions)
    ├── rewards/index.ts  # Reward point functions (4 functions)
    ├── users/index.ts    # User CRUD functions (4 functions)
    └── wallet/index.ts   # Wallet functions (3 functions)
```

---

## 🔄 Function Categories

### User-Facing Functions (Main App) - 17 functions
- `createUser`, `completeGoogleSignIn`, `checkAuthStatus`
- `getUserProfile`, `updateUserProfile`
- `verifyUserProfile`, `subscribeUser`
- `recordAdView`, `convertRewardPoints`, `getStreakInfo`, `getMyRewardTransactions`
- `getMyWalletTransactions`, `getMyWithdrawalRequests`, `requestWithdrawal`
- `getMyPermissions`

### Admin-Only Functions (Admin Panel) - 15 functions
- `suspendUser`, `banUser`, `unbanUser`, `setUserRiskLevel`
- `adminCreditWallet`, `adminCreditRewardPoints`
- `adminLockWallet`, `adminUnlockWallet`
- `getPendingWithdrawals`, `approveWithdrawal`, `rejectWithdrawal`
- `getAdminUserDetails`, `searchUsers`
- `getUserPermissions`, `grantUserPermissions`, `revokeUserPermissions`, `changeUserRole`
