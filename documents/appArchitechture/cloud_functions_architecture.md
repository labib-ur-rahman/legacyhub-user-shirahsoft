# Cloud Functions Architecture

## 🌏 Server Region

**Region:** `asia-south1` (Mumbai, India)  
**Reason:** Optimized for Bangladesh users (90% of audience)

---

## 📁 File Structure

```
functions/
├── src/
│   ├── index.ts                        # Main entry - exports all functions (ONLY index.ts)
│   ├── config/
│   │   └── constants.ts                # Business rules & region config
│   ├── types/
│   │   └── index.ts                    # TypeScript interfaces (types barrel)
│   ├── utils/
│   │   ├── helpers.ts                  # Common helper utilities
│   │   └── validators.ts              # Request validation functions
│   └── features/
│       ├── admin/                      # Admin panel functions
│       │   ├── admin-operations.ts     # 13 admin callable functions
│       │   └── create-super-admin.ts   # Super admin creation script
│       ├── audit/                      # Audit logging
│       │   └── audit-logging.ts        # Audit log creation & queries
│       ├── auth/                       # Auth triggers & verification
│       │   └── auth-and-verification.ts # 5 auth functions
│       ├── invite-codes/               # Invite code operations
│       │   └── invite-code-operations.ts # Code generation & validation
│       ├── network/                    # MLM network operations
│       │   └── network-graph-operations.ts # Upline/downline graph
│       ├── permissions/                # RBAC functions
│       │   └── rbac-and-permissions.ts # 5 permission functions
│       ├── rewards/                    # Reward points system
│       │   └── reward-and-streak.ts    # 4 reward functions
│       ├── users/                      # User CRUD
│       │   └── user-management.ts      # 4 user functions
│       └── wallet/                     # Wallet & withdrawals
│           └── wallet-and-withdrawal.ts # 3 wallet functions
├── package.json
└── tsconfig.json
```

---

## 📊 All Functions Summary

### Total: 34 Functions

| Category | Count | Type |
|----------|-------|------|
| Admin | 13 | Callable (v2) |
| Auth | 5 | 2 Triggers (v1) + 3 Callable (v2) |
| Network | 4 | Internal (not client-callable) |
| Permissions | 5 | Callable (v2) |
| Rewards | 4 | Callable (v2) |
| Users | 4 | Callable (v2) |
| Wallet | 3 | Callable (v2) |

---

## 🔐 Function Types

### 1. Auth Triggers (v1)
Firebase Auth triggers that run automatically on auth events.

| Function | Trigger |
|----------|---------|
| `onUserLogin` | `beforeSignIn` - Validates user state before login |
| `onUserDeleted` | `onDelete` - Cleans up data when user is deleted |

### 2. Callable Functions (v2)
HTTPS callable functions invoked from Flutter client.

**User Functions:**
- `createUser` - Register new user
- `completeGoogleSignIn` - Complete Google OAuth signup
- `getUserProfile` - Get user's own profile
- `updateUserProfile` - Update profile fields

**Auth Functions:**
- `verifyUserProfile` - Complete profile verification
- `subscribeUser` - Subscribe/unsubscribe from topics
- `checkAuthStatus` - Check user's auth state

**Wallet Functions:**
- `requestWithdrawal` - Request wallet withdrawal
- `getMyWalletTransactions` - Get transaction history
- `getMyWithdrawalRequests` - Get withdrawal requests

**Reward Functions:**
- `recordAdView` - Record ad watch for points
- `convertRewardPoints` - Convert points to BDT
- `getStreakInfo` - Get daily streak info
- `getMyRewardTransactions` - Get reward history

**Permission Functions:**
- `getMyPermissions` - Get own permissions
- `getUserPermissions` - Get another user's permissions
- `grantUserPermissions` - Grant permissions
- `revokeUserPermissions` - Revoke permissions
- `changeUserRole` - Change user role

**Admin Functions:**
- `suspendUser` - Suspend user account
- `banUser` - Ban user account
- `unbanUser` - Unban user account
- `setUserRiskLevel` - Set risk level
- `getAdminUserDetails` - Get full user details
- `searchUsers` - Search users
- `adminCreditWallet` - Credit BDT to wallet
- `adminCreditRewardPoints` - Credit reward points
- `adminLockWallet` - Lock wallet
- `adminUnlockWallet` - Unlock wallet
- `getPendingWithdrawals` - Get pending requests
- `approveWithdrawal` - Approve withdrawal
- `rejectWithdrawal` - Reject withdrawal

### 3. Internal Functions
Helper functions called by other functions, not exposed to client.

| Function | Purpose |
|----------|---------|
| `processReferralReward` | Credit referrer on new user signup |
| `creditDownlineCommission` | Credit 5-tier upline commissions |
| `updateNetworkCounts` | Update upline's downline counts |
| `getFullUplineChain` | Get 5-tier upline chain |

---

## 🔒 Role Hierarchy

```
superAdmin (level 5)
    └── admin (level 4)
        └── moderator (level 3)
            └── support (level 2)
                └── user (level 1)
```

**Access Rules:**
- Higher roles inherit lower role permissions
- Cannot target users with equal or higher role
- superAdmin bypasses all permission checks

---

## 💰 Business Constants (from `config/constants.ts`)

```typescript
// Region
REGION = "asia-south1"            // Mumbai, closest to Bangladesh

// Invite Code
INVITE_CODE.CHARSET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789"  // 32 chars
INVITE_CODE.TOTAL_LENGTH = 8     // S + 6 random + L

// Network
NETWORK.MAX_DEPTH = 15           // Maximum upline levels
NETWORK.VERIFICATION_DEPTH = 5   // Levels for verification rewards

// Ads
ADS.MAX_DAILY_ADS = 20           // Max rewarded ads per day
ADS.POINTS_PER_AD = 30           // Points per ad (before multiplier)
ADS.BASE_DAILY_POINTS = 600      // 20 × 30

// Reward Conversion
REWARD_POINTS.CONVERSION_RATE = 100     // 100 pts = 1৳
REWARD_POINTS.MIN_CONVERSION = 1000     // Min 1000 pts (10৳)
REWARD_POINTS.MAX_DAILY_CONVERSIONS = 2
REWARD_POINTS.CONVERSION_FEE_PERCENT = 5  // 5% system fee

// Subscription (400৳ price, 240৳ distributed as 24,000 pts across 15 levels)
// Verification (250৳ price, 125৳ distributed as 12,500 pts across 5 levels)

// Withdrawal
WALLET.MIN_WITHDRAWAL_BDT = 100  // Min 100৳
WALLET.WITHDRAWAL_FEE_PER_1000 = 20  // 20৳ per 1000৳
```

---

## 📦 Firestore Collections (14 Total)

| Collection | Purpose |
|------------|--------|
| `users` | User profiles, status, wallet snapshot, permissions |
| `invite_codes` | Invite code uniqueness index |
| `user_uplines` | Fast upline chain lookup (1–15 levels) |
| `user_relations` | Full graph edges for audit & analytics |
| `user_network_stats` | Aggregated downline counters per level |
| `wallet_transactions` | BDT wallet transaction ledger |
| `reward_transactions` | Reward point transaction ledger |
| `withdrawal_requests` | Withdrawal request queue |
| `streak_data` | Daily ad view streak tracking |
| `ad_view_logs` | Individual ad view records |
| `permissions` | Master permission registry (static) |
| `admin_permissions` | Admin permission assignments |
| `permission_templates` | Permission template presets |
| `audit_logs` | System-wide audit trail |

> Full schema: see `documents/firestore_database_structure.md`

---

## 🌐 Flutter Integration

### Setup
```dart
import 'package:cloud_functions/cloud_functions.dart';

final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
```

### Calling Functions
```dart
final callable = functions.httpsCallable('functionName');
final result = await callable.call({'param': 'value'});
final data = Map<String, dynamic>.from(result.data);
```

### Response Format
```dart
// Success:
{
  "success": true,
  "message": "Operation successful",
  "data": { /* optional data */ }
}

// Error:
{
  "success": false,
  "message": "Error description"
}
```

### Error Handling
```dart
try {
  final result = await callable.call(data);
} on FirebaseFunctionsException catch (e) {
  // e.code: 'unauthenticated', 'permission-denied', etc.
  // e.message: Error description
}
```

---

## 🚀 Deployment

```bash
# Navigate to functions directory
cd functions

# Install dependencies
npm install

# Build TypeScript
npm run build

# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:functionName
```

---

## 📝 Notes Documentation

| File | Content |
|------|---------|
| `quick_reference.md` | Overview & Flutter setup |
| `user_auth_functions.md` | User & auth functions |
| `wallet_reward_functions.md` | Wallet & reward functions |
| `admin_rbac_functions.md` | Admin & permission functions |
| `cloud_functions_architecture.md` | This file - architecture overview |
