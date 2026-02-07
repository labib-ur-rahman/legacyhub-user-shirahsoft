# 📦 LegacyHub – Complete Firestore Database Structure (Single Source of Truth)

> **Document Type:** Technical Reference – Firestore Schema  
> **Version:** 1.1  
> **Last Updated:** February 6, 2026  
> **Synced With:** Cloud Functions (`functions/src/`) & Architecture Documents (`documents/`)  
> **Purpose:** One single file to understand every Firestore collection, document, field, data type, and enum value used in the entire LegacyHub system.

---

## 📋 Collections Overview (15 Total)

| # | Collection | Document ID | Purpose |
|---|-----------|-------------|---------|
| 1 | `users` | `{uid}` | Core user profile, status, wallet snapshot, permissions |
| 2 | `invite_codes` | `{inviteCode}` | Invite code uniqueness index (manual unique constraint) |
| 3 | `user_uplines` | `{uid}` | Fast upline chain lookup (1–15 levels) |
| 4 | `user_relations` | `{autoId}` | Full graph edges for audit & analytics |
| 5 | `user_network_stats` | `{uid}` | Aggregated downline counters per level |
| 6 | `wallet_transactions` | `{autoId}` | BDT wallet transaction ledger |
| 7 | `reward_transactions` | `{autoId}` | Reward point transaction ledger |
| 8 | `withdrawal_requests` | `{autoId}` | Withdrawal request queue |
| 9 | `streak_data` | `{uid}` | Daily ad view streak tracking |
| 10 | `ad_view_logs` | `{autoId}` | Individual ad view records |
| 11 | `permissions` | `{permissionId}` | Master permission registry (static) |
| 12 | `admin_permissions` | `{adminUid}` | Admin permission assignments |
| 13 | `permission_templates` | `{templateId}` | Permission template presets |
| 14 | `audit_logs` | `{autoId}` | System-wide audit trail |
| 15 | `configurations` | `app_settings` | Dynamic business configuration (all runtime constants) |

---

## 1️⃣ `users` Collection — Core User Profile

> **THE most important collection.** Every user has exactly one document here.  
> Document must stay small, stable, and authoritative.

```
users (Collection)
└── {uid} (Document)                     # Firebase Auth UID
    ├── uid : String                     # Same as document ID (Firebase Auth UID)
    ├── role : String                    # User's role in the system
    │                                    # ENUM: "superAdmin" | "admin" | "moderator" | "support" | "user"
    │
    ├── identity : Map                   # Personal & authentication info
    │   ├── firstName : String           # User first name (min 2 chars)
    │   ├── lastName : String            # User last name (min 2 chars)
    │   ├── email : String               # Email address (unique via Firebase Auth)
    │   ├── phone : String               # Phone number (Bangladesh: 01XXXXXXXXX)
    │   ├── authProvider : String        # How user signed up
    │   │                                # ENUM: "password" | "google" | "phone"
    │   ├── photoURL : String            # Profile photo URL (empty string if none)
    │   └── coverURL : String            # Cover photo URL (empty string if none)
    │
    ├── codes : Map                      # Invite & referral codes
    │   ├── inviteCode : String          # User's unique 8-char invite code (format: S + 6 random + L)
    │   │                                # Example: "SA7K9Q2L"
    │   │                                # Charset: ABCDEFGHJKMNPQRSTUVWXYZ23456789 (excluded: O, I, l, 0, 1)
    │   └── referralCode : String        # Backend-only referral identity (always = uid)
    │
    ├── network : Map                    # Direct parent relationship
    │   ├── parentUid : String | null    # UID of parent user (null for super admin / root users)
    │   └── joinedVia : String           # How user joined the network
    │                                    # ENUM: "invite" | "direct" | "manual"
    │                                    # "invite" = used invite code, "direct" = Google sign-in, "manual" = super admin script
    │
    ├── status : Map                     # Account lifecycle & risk control
    │   ├── accountState : String        # Current account state
    │   │                                # ENUM: "active" | "suspended" | "under_review" | "banned" | "deleted"
    │   │                                # active     → normal operation (login ✅, earn ✅, withdraw ✅)
    │   │                                # suspended  → temporary restriction (login ✅, earn ❌, withdraw ❌)
    │   │                                # under_review → fraud investigation (login ✅, earn ❌, withdraw ❌)
    │   │                                # banned     → permanent block (login ❌, earn ❌, withdraw ❌)
    │   │                                # deleted    → soft delete (login ❌, earn ❌, withdraw ❌)
    │   ├── verified : Boolean           # Profile verification status (requires 250৳ payment)
    │   ├── subscription : String        # Subscription status
    │   │                                # ENUM: "none" | "active" | "expired"
    │   └── riskLevel : String           # Risk classification for anti-abuse
    │                                    # ENUM: "normal" | "watch" | "high" | "fraud"
    │
    ├── wallet : Map                     # Wallet snapshot (real ledger in wallet_transactions)
    │   ├── balanceBDT : Number          # Current BDT balance (real money, withdrawable)
    │   ├── rewardPoints : Number        # Current reward points (non-cash, convertible)
    │   └── locked : Boolean             # Whether wallet is locked (blocks all transactions)
    │
    ├── permissions : Map                # Feature-level access control (for regular users)
    │   ├── canPost : Boolean            # Can create community posts (true after verification)
    │   ├── canWithdraw : Boolean        # Can request withdrawals (true after verification)
    │   └── canViewCommunity : Boolean   # Can view community content (default: true)
    │
    ├── flags : Map                      # Special behavior flags
    │   └── isTestUser : Boolean         # If true: fake wallet, simulated payments, no real API calls
    │                                    # Used for QA, demo, Play Store review
    │
    ├── limits : Map                     # Daily anti-abuse rate limiting
    │   ├── dailyAdsViewed : Number      # Ads watched today (max: 20/day)
    │   ├── dailyRewardConverted : Number # Reward conversions today (max: 2/day)
    │   └── lastLimitReset : String      # ISO date of last reset "YYYY-MM-DD"
    │
    ├── meta : Map                       # Timestamps for analytics & activity tracking
    │   ├── createdAt : Timestamp        # Account creation time
    │   ├── updatedAt : Timestamp        # Last document update
    │   ├── lastLoginAt : Timestamp|null # Last login time (null if never logged in)
    │   └── lastActiveAt : Timestamp|null # Last activity time (null if never active)
    │
    └── system : Map                     # Admin-controlled system fields
        ├── banReason : String | null    # Reason for ban (null if not banned)
        ├── suspendUntil : Timestamp|null # Suspension expiry (null if not suspended)
        └── notes : String              # Admin notes about this user
```

### Role Hierarchy (Higher inherits lower)

```
superAdmin (level 5)  → System owner/founder, bypasses all permission checks
    └── admin (level 4)  → Operations & finance managers
        └── moderator (level 3)  → Community moderation
            └── support (level 2)  → Customer support
                └── user (level 1)  → Normal app user
```

---

## 2️⃣ `invite_codes` Collection — Uniqueness Index

> **Manual unique constraint.** Firestore has no native unique fields, so this collection acts as a unique index on invite codes.  
> ⚠️ Flutter MUST NEVER read this collection directly.

```
invite_codes (Collection)
└── {inviteCode} (Document)              # The invite code itself (e.g., "SA7K9Q2L")
    ├── uid : String                     # Firebase Auth UID of code owner
    ├── email : String                   # Email of code owner (for quick lookup)
    └── createdAt : Timestamp            # When the code was generated
```

### Invite Code Format

```
Format:  S + [6 random chars] + L
Charset: ABCDEFGHJKMNPQRSTUVWXYZ23456789  (32 chars, excluded: O, I, l, 0, 1)
Total:   32^6 ≈ 1,073,741,824 unique codes
Example: "SA7K9Q2L", "SADMIN01" (super admin special)
```

---

## 3️⃣ `user_uplines` Collection — Upline Chain Snapshot

> **One read = all 15 upline levels.** Used for commission calculation, reward distribution, and permission checks.  
> Only Cloud Functions can write. Flutter reads only.

```
user_uplines (Collection)
└── {uid} (Document)                     # Firebase Auth UID of the user
    ├── u1 : String | null               # Direct parent (level 1 upline)
    ├── u2 : String | null               # Level 2 upline (parent's parent)
    ├── u3 : String | null               # Level 3 upline
    ├── u4 : String | null               # Level 4 upline
    ├── u5 : String | null               # Level 5 upline
    ├── u6 : String | null               # Level 6 upline
    ├── u7 : String | null               # Level 7 upline
    ├── u8 : String | null               # Level 8 upline
    ├── u9 : String | null               # Level 9 upline
    ├── u10 : String | null              # Level 10 upline
    ├── u11 : String | null              # Level 11 upline
    ├── u12 : String | null              # Level 12 upline
    ├── u13 : String | null              # Level 13 upline
    ├── u14 : String | null              # Level 14 upline
    ├── u15 : String | null              # Level 15 upline (maximum depth)
    ├── maxDepth : Number                # Always 15 (constant)
    └── createdAt : Timestamp            # When upline chain was created
```

### Upline Chain Build Logic (on signup)

```
new_user.u1 = parentUid
new_user.u2 = parent.u1
new_user.u3 = parent.u2
...
new_user.u15 = parent.u14
```

### Super Admin Special Case

```
All u1–u15 = null (no parent)
```

---

## 4️⃣ `user_relations` Collection — Graph Truth Layer

> **One document = one graph edge.** Each relation connects an ancestor to a descendant at a specific level.  
> Used for auditing, analytics, rebuilding stats, and admin deep inspection.  
> ⚠️ Flutter should NOT query directly (use `user_network_stats` instead).

```
user_relations (Collection)
└── {autoId} (Document)                  # Auto-generated document ID
    ├── ancestorUid : String             # UID of the ancestor (upline user)
    ├── descendantUid : String           # UID of the descendant (downline user)
    ├── level : Number                   # Relationship depth (1–15)
    │                                    # 1 = direct parent-child, 15 = most distant
    ├── descendantVerified : Boolean     # Whether descendant is verified
    ├── descendantSubscribed : Boolean   # Whether descendant has active subscription
    └── createdAt : Timestamp            # When relation was created
```

### Example Relations (User D joins via User C, who joined via User B, who joined via User A)

```
{ ancestorUid: "A", descendantUid: "D", level: 3 }
{ ancestorUid: "B", descendantUid: "D", level: 2 }
{ ancestorUid: "C", descendantUid: "D", level: 1 }
```

### Useful Queries

```
WHERE ancestorUid == "X" AND level == 2 AND descendantVerified == true
→ "How many verified users does X have at level 2?"
```

---

## 5️⃣ `user_network_stats` Collection — Aggregated Counters

> **Pre-computed stats for Flutter UI.** No heavy queries needed — single document read.  
> Used for: "My Network" screen, feature unlock rules, progress tracking.

```
user_network_stats (Collection)
└── {uid} (Document)                     # Firebase Auth UID of the user
    ├── level1 : Map                     # Stats for direct downlines
    │   ├── total : Number               # Total downlines at this level
    │   ├── verified : Number            # Verified downlines at this level
    │   └── subscribed : Number          # Subscribed downlines at this level
    ├── level2 : Map                     # Stats for level 2 downlines
    │   ├── total : Number
    │   ├── verified : Number
    │   └── subscribed : Number
    ├── level3 : Map                     # (same structure)
    ├── level4 : Map
    ├── level5 : Map
    ├── level6 : Map
    ├── level7 : Map
    ├── level8 : Map
    ├── level9 : Map
    ├── level10 : Map
    ├── level11 : Map
    ├── level12 : Map
    ├── level13 : Map
    ├── level14 : Map
    ├── level15 : Map                    # (same structure as level1)
    └── updatedAt : Timestamp            # Last time stats were updated
```

### When Stats Are Updated

| Event | Fields Incremented |
|-------|-------------------|
| New user joins | `level{N}.total` for each upline at level N |
| User gets verified | `level{N}.verified` for each upline |
| User subscribes | `level{N}.subscribed` for each upline |

---

## 6️⃣ `wallet_transactions` Collection — BDT Wallet Ledger

> **Every BDT wallet credit/debit is logged here.** Immutable transaction records for audit.

```
wallet_transactions (Collection)
└── {autoId} (Document)                  # Auto-generated document ID
    ├── id : String                      # Transaction ID (format: "WTX_{timestamp}_{random}")
    ├── uid : String                     # User who owns this transaction
    ├── type : String                    # Transaction direction
    │                                    # ENUM: "credit" | "debit"
    ├── source : String                  # What caused this transaction
    │                                    # ENUM: "subscription_commission" | "verification_commission"
    │                                    #       "reward_conversion" | "withdrawal"
    │                                    #       "recharge_cashback" | "product_sale"
    │                                    #       "micro_job" | "admin_credit" | "admin_debit"
    ├── amount : Number                  # Transaction amount in BDT
    ├── balanceBefore : Number           # Wallet balance before transaction
    ├── balanceAfter : Number            # Wallet balance after transaction
    ├── description : String             # Human-readable description
    ├── reference : String | null        # Related ID (withdrawal ID, admin UID, etc.)
    └── createdAt : Timestamp            # When transaction occurred
```

---

## 7️⃣ `reward_transactions` Collection — Reward Point Ledger

> **Every reward point credit/debit is logged here.** Separate from wallet for clear separation.

```
reward_transactions (Collection)
└── {autoId} (Document)                  # Auto-generated document ID
    ├── id : String                      # Transaction ID (format: "RPT_{timestamp}_{random}")
    ├── uid : String                     # User who owns this transaction
    ├── type : String                    # Transaction direction
    │                                    # ENUM: "credit" | "debit"
    ├── source : String                  # What caused this transaction
    │                                    # ENUM: "ad_reward" | "subscription_commission"
    │                                    #       "verification_commission" | "reward_conversion"
    │                                    #       "admin_credit" | "admin_debit"
    ├── points : Number                  # Number of reward points
    ├── pointsBefore : Number            # Points balance before transaction
    ├── pointsAfter : Number             # Points balance after transaction
    ├── description : String             # Human-readable description
    ├── reference : String | null        # Related ID (ad log ID, admin UID, etc.)
    └── createdAt : Timestamp            # When transaction occurred
```

### Reward Points Business Rules

```
Conversion Rate:   100 points = 1৳ BDT
Min Conversion:    1,000 points (= 10৳)
Max Daily:         2 conversions/day
Max Weekly:        7 conversions/week
System Fee:        5% on conversion
```

---

## 8️⃣ `withdrawal_requests` Collection — Withdrawal Queue

> **Admin-reviewed withdrawal pipeline.** Created by user, processed by admin.

```
withdrawal_requests (Collection)
└── {autoId} (Document)                  # Auto-generated document ID
    ├── id : String                      # Withdrawal ID (format: "WDR_{timestamp}_{random}")
    ├── uid : String                     # User requesting withdrawal
    ├── amount : Number                  # Requested amount in BDT
    ├── fee : Number                     # Withdrawal fee (20৳ per 1,000৳)
    ├── netAmount : Number               # Amount after fee (amount - fee)
    ├── paymentMethod : String           # Payment method (e.g., "bKash", "Nagad", "bank")
    ├── paymentDetails : Map             # Payment-specific details
    │   └── {key} : String              # e.g., { "accountNumber": "017XXXXXXXX" }
    ├── status : String                  # Current withdrawal status
    │                                    # ENUM: "pending" | "approved" | "rejected" | "processing" | "completed"
    ├── adminUid : String | null         # UID of admin who processed (null if pending)
    ├── adminNote : String | null        # Admin's note/reason
    ├── createdAt : Timestamp            # When request was created
    └── processedAt : Timestamp | null   # When admin processed (null if pending)
```

### Withdrawal Business Rules

```
Min Amount:   100৳
Fee:          20৳ per 1,000৳ (ceil)
Example:      Withdraw 1,500৳ → fee = 40৳ → net = 1,460৳
Review:       Manual admin review (24–48h)
Payout:       Mobile banking (bKash, Nagad, etc.)
```

---

## 9️⃣ `streak_data` Collection — Daily Streak Tracking

> **Tracks daily ad viewing streaks for multiplier bonuses.** One document per user.

```
streak_data (Collection)
└── {uid} (Document)                     # Firebase Auth UID
    ├── uid : String                     # Same as document ID
    ├── currentStreak : Number           # Current consecutive days (resets on miss)
    ├── lastActiveDate : String          # Last active date "YYYY-MM-DD" (ISO)
    ├── highestStreak : Number           # All-time highest streak achieved
    └── updatedAt : Timestamp            # Last update time
```

### Streak Multiplier Table (30-Day)

```
Day 1–2:   1.0x (600 pts/day)      Day 16–17: 2.1x (1,260 pts/day)
Day 3–4:   1.1x (660 pts/day)      Day 18–19: 2.2x (1,320 pts/day)
Day 5–6:   1.2x (720 pts/day)      Day 20–21: 2.5x (1,500 pts/day)
Day 7–9:   1.5x (900 pts/day)      Day 22–23: 2.6x (1,560 pts/day)
Day 10–11: 1.6x (960 pts/day)      Day 24–25: 2.7x (1,620 pts/day)
Day 12–13: 1.7x (1,020 pts/day)    Day 26–27: 2.8x (1,680 pts/day)
Day 14–15: 2.0x (1,200 pts/day)    Day 28–30+: 3.0x (1,800 pts/day) MAX

Miss 1 day → streak resets to Day 1
Base: 20 ads/day × 30 pts/ad = 600 pts/day
```

---

## 🔟 `ad_view_logs` Collection — Ad View Records

> **Individual ad view audit trail.** Used for anti-abuse, analytics, and reward verification.

```
ad_view_logs (Collection)
└── {autoId} (Document)                  # Auto-generated document ID
    ├── id : String                      # Same as document ID
    ├── uid : String                     # User who viewed the ad
    ├── adType : String                  # Type of ad (e.g., "rewarded", "interstitial")
    ├── pointsEarned : Number            # Reward points earned from this view
    ├── multiplier : Number              # Streak multiplier applied (1.0–3.0)
    ├── deviceId : String                # SHA-256 hash of device ID (first 16 chars)
    ├── ipHash : String                  # Hashed IP address (for abuse detection)
    └── createdAt : Timestamp            # When ad was viewed
```

### Ad Business Rules

```
Max Ads/Day:       20
Points/Ad:         30 (base, before multiplier)
Base Daily Total:  600 points (20 × 30)
Max Daily Total:   1,800 points (with 3.0x multiplier)
```

---

## 1️⃣1️⃣ `permissions` Collection — Master Permission Registry

> **Static registry of all possible permissions.** Created only by SuperAdmin. Rarely changes.  
> Used for: UI rendering, permission validation, audit context.

```
permissions (Collection)
└── {permissionId} (Document)            # Permission ID (e.g., "withdraw.approve")
    ├── id : String                      # Same as document ID
    ├── group : String                   # Permission group (e.g., "wallet", "user", "reward")
    ├── description : String             # Human-readable description
    └── dangerLevel : String             # Risk classification
                                         # ENUM: "low" | "medium" | "high" | "critical"
```

### Known Permission IDs

```
# User Management
user.view          → View user details
user.suspend       → Suspend user account
user.ban           → Ban user account
user.unban         → Unban user account
user.risk          → Set user risk level
user.search        → Search users

# Wallet
wallet.credit      → Credit BDT to wallet
wallet.lock        → Lock user wallet
wallet.unlock      → Unlock user wallet

# Withdrawals
withdraw.review    → View pending withdrawals
withdraw.approve   → Approve withdrawal
withdraw.reject    → Reject withdrawal

# Rewards
reward.credit      → Credit reward points

# Permissions
permission.grant   → Grant permissions to users
permission.revoke  → Revoke permissions from users

# Roles
role.change        → Change user roles
```

---

## 1️⃣2️⃣ `admin_permissions` Collection — Permission Assignments

> **Per-admin permission map.** O(1) permission check using boolean map.  
> ⚠️ Admin permissions NEVER live inside the `users` document.

```
admin_permissions (Collection)
└── {adminUid} (Document)                # Firebase Auth UID of the admin
    ├── uid : String                     # Same as document ID
    ├── permissions : Map                # Boolean map of granted permissions
    │   └── {permissionId} : Boolean     # e.g., "withdraw.approve": true
    │                                    # Only `true` entries exist (false = deleted)
    ├── assignedBy : String              # UID of admin who last modified
    └── updatedAt : Timestamp            # Last modification time
```

### Access Check Logic

```
if (user.role === "superAdmin") → ALL permissions granted (bypass check)
else → check admin_permissions/{uid}.permissions[permissionId] === true
```

---

## 1️⃣3️⃣ `permission_templates` Collection — Fast Onboarding Presets

> **Optional templates for quick permission assignment.** Used when onboarding new admins.

```
permission_templates (Collection)
└── {templateId} (Document)              # Template ID (e.g., "finance_manager")
    ├── id : String                      # Same as document ID
    ├── name : String                    # Display name (e.g., "Finance Manager")
    ├── description : String             # What this template is for
    ├── permissions : Array<String>      # List of permission IDs
    │                                    # e.g., ["withdraw.review", "withdraw.approve", "wallet.credit"]
    ├── createdBy : String               # UID of creator (superAdmin)
    └── createdAt : Timestamp            # When template was created
```

---

## 1️⃣4️⃣ `audit_logs` Collection — System Audit Trail

> **Every sensitive action is logged here.** Mandatory for production.  
> No audit = no production approval.

```
audit_logs (Collection)
└── {autoId} (Document)                  # Auto-generated document ID
    ├── id : String                      # Same as document ID
    ├── actorUid : String                # Who performed the action
    ├── actorRole : String               # Role at time of action
    ├── action : String                  # What action was performed
    │                                    # ENUM: see Audit Action Types below
    ├── targetUid : String | null        # Who was affected (null for self-actions)
    ├── targetCollection : String | null # Target Firestore collection (if applicable)
    ├── targetDocId : String | null      # Target document ID (if applicable)
    ├── before : Map | null              # State before change (for updates)
    ├── after : Map | null               # State after change (for updates)
    ├── metadata : Map                   # Additional context (always present, may be empty)
    ├── ipHash : String | null           # Hashed IP address
    ├── device : String | null           # Device info (e.g., "web_admin")
    └── timestamp : Timestamp            # When action occurred
```

### Audit Action Types

```
# User Lifecycle
user.create         → New user account created
user.verify         → Profile verified (250৳ payment)
user.subscribe      → Subscription activated (400৳ payment)
user.suspend        → Account suspended by admin
user.ban            → Account banned by admin
user.unban          → Account unbanned by admin
user.delete         → Account soft-deleted (Firebase Auth trigger)

# Wallet
wallet.credit       → BDT credited by admin
wallet.debit        → BDT debited
wallet.lock         → Wallet locked by admin
wallet.unlock       → Wallet unlocked by admin
withdrawal.request  → User requested withdrawal
withdrawal.approve  → Admin approved withdrawal
withdrawal.reject   → Admin rejected withdrawal

# Rewards
reward.credit       → Reward points credited by admin
reward.convert      → User converted reward points to BDT

# Permissions & Roles
permission.grant    → Permissions granted to user
permission.revoke   → Permissions revoked from user
role.change         → User role changed

# Admin
admin.login         → Admin logged in
admin.action        → Generic admin action
```

---

## 1️⃣5️⃣ `configurations` Collection — Dynamic Business Configuration

> **Single document holding ALL runtime business constants.**  
> Changes take effect within 30 seconds (cache TTL). No redeployment needed.  
> Managed via `seedConfigurations`, `updateAppConfig`, `getAppConfigAdmin` Cloud Functions.

```
configurations (Collection)
└── app_settings (Document)              # Single config document (fixed ID)
    │
    ├── network : Map                    # Network/MLM depth settings
    │   ├── maxDepth : Number            # Maximum upline levels (default: 15)
    │   └── verificationDepth : Number   # Levels for verification rewards (default: 5)
    │
    ├── inviteCode : Map                 # Invite code generation rules
    │   ├── prefix : String              # Code prefix (default: "S")
    │   ├── suffix : String              # Code suffix (default: "L")
    │   ├── randomLength : Number        # Random chars count (default: 6)
    │   ├── charset : String             # Allowed characters (default: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    │   └── totalLength : Number         # Total code length (default: 8)
    │
    ├── rewardPoints : Map               # Reward points conversion rules
    │   ├── conversionRate : Number      # Points per 1৳ (default: 100)
    │   ├── minConversion : Number       # Min points to convert (default: 1000)
    │   ├── maxDailyConversions : Number # Max daily conversions (default: 2)
    │   ├── maxWeeklyConversions : Number# Max weekly conversions (default: 10)
    │   └── conversionFeePercent : Number# Fee percentage (default: 5)
    │
    ├── ads : Map                        # Ad viewing rules
    │   ├── maxDailyAds : Number         # Max ads per day (default: 20)
    │   ├── pointsPerAd : Number         # Points earned per ad (default: 30)
    │   └── baseDailyPoints : Number     # Base daily points (default: 600)
    │
    ├── streak : Map                     # Streak multiplier configuration
    │   ├── multipliers : Map            # Day-range → multiplier mapping
    │   │   ├── "1" : Number             # Day 1: 1.0x
    │   │   ├── "3" : Number             # Day 3: 1.2x
    │   │   ├── "7" : Number             # Day 7: 1.5x
    │   │   ├── "14" : Number            # Day 14: 2.0x
    │   │   ├── "21" : Number            # Day 21: 2.5x
    │   │   └── "28" : Number            # Day 28: 3.0x
    │   └── maxMultiplier : Number       # Cap multiplier (default: 3.0)
    │
    ├── subscription : Map               # Subscription payment & distribution
    │   ├── priceBDT : Number            # Subscription price (default: 400)
    │   ├── rewardDistributedBDT : Number# Amount distributed to uplines (default: 240)
    │   ├── totalRewardPoints : Number   # Reward points given to subscriber (default: 24000)
    │   └── levelDistribution : Array<Map> # Per-level distribution configuration (15 levels)
    │       ├── [0] : Map                # Level 1 configuration
    │       │   ├── level : Number       # Level index (1)
    │       │   ├── percent : Number     # Percentage share (25 = 25%, whole number 0-100)
    │       │   └── points : Number      # Reward points to distribute (6000)
    │       ├── [1] : Map                # Level 2 (percent: 15, points: 3600)
    │       ├── [2] : Map                # Level 3 (percent: 10, points: 2400)
    │       ├── [3] : Map                # Level 4 (percent: 8, points: 1920)
    │       ├── [4] : Map                # Level 5 (percent: 7, points: 1680)
    │       ├── [5] : Map                # Level 6 (percent: 6, points: 1440)
    │       ├── [6] : Map                # Level 7 (percent: 5, points: 1200)
    │       ├── [7] : Map                # Level 8 (percent: 4, points: 960)
    │       ├── [8] : Map                # Level 9 (percent: 4, points: 960)
    │       ├── [9] : Map                # Level 10 (percent: 3, points: 720)
    │       ├── [10] : Map               # Level 11 (percent: 3, points: 720)
    │       ├── [11] : Map               # Level 12 (percent: 2, points: 480)
    │       ├── [12] : Map               # Level 13 (percent: 2, points: 480)
    │       ├── [13] : Map               # Level 14 (percent: 1.5, points: 360)
    │       └── [14] : Map               # Level 15 (percent: 1.5, points: 360)
    │
    ├── verification : Map               # Verification payment & distribution
    │   ├── priceBDT : Number            # Verification price (default: 250)
    │   ├── rewardDistributedBDT : Number# Amount distributed to uplines (default: 125)
    │   ├── totalRewardPoints : Number   # Reward points given to verifier (default: 12500)
    │   └── levelDistribution : Array<Map> # Per-level distribution configuration (5 levels)
    │       ├── [0] : Map                # Level 1 configuration
    │       │   ├── level : Number       # Level index (1)
    │       │   ├── percent : Number     # Percentage share (40 = 40%, whole number 0-100)
    │       │   └── points : Number      # Reward points to distribute (5000)
    │       ├── [1] : Map                # Level 2 (percent: 25, points: 3125)
    │       ├── [2] : Map                # Level 3 (percent: 15, points: 1875)
    │       ├── [3] : Map                # Level 4 (percent: 10, points: 1250)
    │       └── [4] : Map                # Level 5 (percent: 10, points: 1250)
    │
    ├── wallet : Map                     # Wallet & withdrawal rules
    │   ├── minWithdrawalBDT : Number    # Minimum withdrawal (default: 100)
    │   └── withdrawalFeePer1000 : Number# Fee per 1000৳ withdrawn (default: 20)
    │
    └── _meta : Map                      # Metadata (auto-managed)
        ├── createdAt : Timestamp        # First seed timestamp
        ├── createdBy : String           # UID of seeder
        ├── updatedAt : Timestamp        # Last update timestamp
        ├── updatedBy : String           # UID of last updater
        └── version : Number             # Schema version (default: 1)
```

### Configuration Read Pattern

```
Every Cloud Function that needs business constants:
    │
    ├── Calls getAppConfig()
    │   ├── Cache valid (< 30s)?  → Return cached config
    │   └── Cache expired?        → Read configurations/app_settings
    │                               ├── Document exists → Merge with defaults, cache, return
    │                               └── Document missing → Return DEFAULT_CONFIG
    │
    └── Uses config values for business logic
```

### Configuration Management Functions

| Function | Role Required | Purpose |
|----------|--------------|---------|
| `seedConfigurations` | SuperAdmin | Write DEFAULT_CONFIG to Firestore (first-time setup) |
| `updateAppConfig` | SuperAdmin | Partial merge update (dot-notation for nested fields) |
| `getAppConfigAdmin` | Admin | Read current live configuration |

### Important Notes

- **Cache TTL:** 30 seconds — changes propagate within 30s without redeployment
- **Merge with Defaults:** Missing fields in Firestore are filled from `DEFAULT_CONFIG`, so partial updates are safe
- **Array Fields:** `levelDistribution` arrays must always be replaced in full (not partially updated)
- **No Retroactive Effect:** Changed values apply only to **future** operations, not past transactions

---

## 📊 Data Flow Summary

### Signup Flow (What Gets Created)

```
User signs up with invite code
    │
    ├── 1. Firebase Auth user created
    ├── 2. users/{uid}                    → Full user document
    ├── 3. invite_codes/{newCode}         → New invite code for this user
    ├── 4. user_uplines/{uid}             → Upline chain (shifted from parent)
    ├── 5. user_relations/{autoId} × N    → One edge per upline level
    ├── 6. user_network_stats/{uid}       → Empty stats initialized
    ├── 7. user_network_stats/{uplineUid} → total++ for each upline
    └── 8. audit_logs/{autoId}            → user.create audit entry
```

### Verification Flow

```
User verifies profile (250৳)
    │
    ├── 1. users/{uid}.status.verified = true
    ├── 2. users/{uid}.permissions.canPost = true
    ├── 3. users/{uid}.permissions.canWithdraw = true
    ├── 4. user_network_stats/{uplineUid}.level{N}.verified++ for each upline
    ├── 5. user_relations → descendantVerified = true (batch update)
    ├── 6. reward_transactions/{autoId} × 5  → Verification rewards to 5 upline levels
    │      Level 1: 5,000 pts (40%)
    │      Level 2: 3,125 pts (25%)
    │      Level 3: 1,875 pts (15%)
    │      Level 4: 1,250 pts (10%)
    │      Level 5: 1,250 pts (10%)
    │      Total distributed: 12,500 pts (= 125৳)
    └── 7. audit_logs/{autoId} → user.verify
```

### Subscription Flow

```
User subscribes (400৳)
    │
    ├── 1. users/{uid}.status.subscription = "active"
    ├── 2. users/{uid}.status.verified = true (auto-verify)
    ├── 3. user_network_stats/{uplineUid} → subscribed++ (and verified++ if new)
    ├── 4. user_relations → descendantSubscribed = true
    ├── 5. reward_transactions/{autoId} × 15 → Subscription rewards to 15 upline levels
    │      Level 1:  6,000 pts (25%)    Level 9:   960 pts (4%)
    │      Level 2:  3,600 pts (15%)    Level 10:  720 pts (3%)
    │      Level 3:  2,400 pts (10%)    Level 11:  720 pts (3%)
    │      Level 4:  1,920 pts (8%)     Level 12:  480 pts (2%)
    │      Level 5:  1,680 pts (7%)     Level 13:  480 pts (2%)
    │      Level 6:  1,440 pts (6%)     Level 14:  360 pts (1.5%)
    │      Level 7:  1,200 pts (5%)     Level 15:  360 pts (1.5%)
    │      Level 8:    960 pts (4%)     Total: 24,000 pts (= 240৳)
    └── 6. audit_logs/{autoId} → user.subscribe
```

### Ad View Flow

```
User watches rewarded ad
    │
    ├── 1. streak_data/{uid} → streak updated
    ├── 2. users/{uid}.wallet.rewardPoints += (30 × multiplier)
    ├── 3. users/{uid}.limits.dailyAdsViewed++
    ├── 4. ad_view_logs/{autoId} → ad view record
    └── 5. reward_transactions/{autoId} → reward credit
```

### Withdrawal Flow

```
User requests withdrawal
    │
    ├── 1. users/{uid}.wallet.balanceBDT -= amount
    ├── 2. withdrawal_requests/{autoId} → status: "pending"
    ├── 3. wallet_transactions/{autoId} → debit record
    └── 4. audit_logs/{autoId} → withdrawal.request
    
Admin approves
    │
    ├── 1. withdrawal_requests → status: "approved"
    └── 2. audit_logs/{autoId} → withdrawal.approve

Admin rejects
    │
    ├── 1. users/{uid}.wallet.balanceBDT += amount (refund)
    ├── 2. withdrawal_requests → status: "rejected"
    └── 3. audit_logs/{autoId} → withdrawal.reject
```

---

## 🔗 Collection Relationships Diagram

```
                    ┌─────────────────┐
                    │  Firebase Auth   │
                    │  (UID source)    │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
    ┌─────────────┐  ┌──────────────┐  ┌──────────────┐
    │    users     │  │ invite_codes │  │ user_uplines │
    │   {uid}      │  │ {inviteCode} │  │    {uid}     │
    │              │  │              │  │  u1...u15    │
    │  identity    │  │  uid ◄───────┤  │              │
    │  codes ──────┤──► inviteCode   │  └──────┬───────┘
    │  network     │  │              │         │
    │  status      │  └──────────────┘         │
    │  wallet ─────┤                           ▼
    │  permissions │              ┌──────────────────┐
    │  flags       │              │  user_relations   │
    │  limits      │              │    {autoId}       │
    │  meta        │              │  ancestorUid      │
    │  system      │              │  descendantUid    │
    └──────┬───────┘              │  level            │
           │                      └──────────────────┘
           │                               │
    ┌──────┼────────┐                      ▼
    │      │        │          ┌─────────────────────┐
    ▼      ▼        ▼          │ user_network_stats   │
┌────────┐┌────────┐┌────────┐│       {uid}          │
│wallet_ ││reward_ ││withdrawa│ │  level1...level15   │
│transact││transact││l_request│ │  {total,verified,   │
│ions    ││ions    ││s       │ │   subscribed}        │
└────────┘└────────┘└────────┘└─────────────────────┘

    ┌───────────────┐  ┌──────────────────┐  ┌──────────────┐
    │  streak_data   │  │  ad_view_logs    │  │  audit_logs  │
    │    {uid}       │  │    {autoId}      │  │   {autoId}   │
    │  currentStreak │  │  uid, adType     │  │  actorUid    │
    │  lastActiveDate│  │  pointsEarned    │  │  action      │
    └───────────────┘  └──────────────────┘  │  targetUid   │
                                              └──────────────┘

    ┌────────────────┐  ┌────────────────────┐  ┌────────────────────┐
    │  permissions    │  │ admin_permissions   │  │ permission_templates│
    │ {permissionId}  │  │   {adminUid}        │  │   {templateId}      │
    │  group          │  │  permissions: Map   │  │  permissions: []   │
    │  dangerLevel    │  │  assignedBy         │  │  createdBy         │
    └────────────────┘  └────────────────────┘  └────────────────────┘
```

---

## ⚙️ Cloud Functions → Collection Mapping

> **Note:** All business functions also **read** `configurations/app_settings` at runtime for dynamic constants (cached 30s).

| Cloud Function | Collections Written |
|----------------|-------------------|
| `createUser` | `users`, `invite_codes`, `user_uplines`, `user_relations`, `user_network_stats`, `audit_logs` |
| `completeGoogleSignIn` | `users`, `invite_codes`, `user_uplines`, `user_relations`, `user_network_stats`, `audit_logs` |
| `verifyUserProfile` | `users`, `user_network_stats`, `user_relations`, `reward_transactions`, `audit_logs` |
| `subscribeUser` | `users`, `user_network_stats`, `user_relations`, `reward_transactions`, `audit_logs` |
| `recordAdView` | `users`, `streak_data`, `ad_view_logs`, `reward_transactions` |
| `convertRewardPoints` | `users`, `reward_transactions`, `wallet_transactions`, `audit_logs` |
| `requestWithdrawal` | `users`, `withdrawal_requests`, `wallet_transactions`, `audit_logs` |
| `approveWithdrawal` | `withdrawal_requests`, `audit_logs` |
| `rejectWithdrawal` | `users`, `withdrawal_requests`, `audit_logs` |
| `suspendUser` | `users`, `audit_logs` |
| `banUser` | `users`, `audit_logs` |
| `unbanUser` | `users`, `audit_logs` |
| `adminCreditWallet` | `users`, `wallet_transactions`, `audit_logs` |
| `adminCreditRewardPoints` | `users`, `reward_transactions`, `audit_logs` |
| `adminLockWallet` | `users`, `audit_logs` |
| `adminUnlockWallet` | `users`, `audit_logs` |
| `setUserRiskLevel` | `users`, `audit_logs` |
| `grantUserPermissions` | `admin_permissions`, `audit_logs` |
| `revokeUserPermissions` | `admin_permissions`, `audit_logs` |
| `changeUserRole` | `users`, `audit_logs` |
| `onUserDeleted` | `users`, `audit_logs` |
| `onUserLogin` | `users` |
| `seedConfigurations` | `configurations`, `audit_logs` |
| `updateAppConfig` | `configurations`, `audit_logs` |
| `getAppConfigAdmin` | `configurations` (read-only) |

---

## 🔒 Security Rules Summary

### Flutter CAN Read

| Collection | Condition |
|-----------|-----------|
| `users/{uid}` | Own document only |
| `user_network_stats/{uid}` | Own document only |
| `streak_data/{uid}` | Own document only |
| `wallet_transactions` | Own UID filter |
| `reward_transactions` | Own UID filter |
| `withdrawal_requests` | Own UID filter |

### Flutter CANNOT Read

| Collection | Reason |
|-----------|--------|
| `invite_codes` | Security — uniqueness index only |
| `user_relations` | Performance — use network_stats instead |
| `user_uplines` | Security — backend use only |
| `admin_permissions` | Security — admin only |
| `audit_logs` | Security — admin only |
| `ad_view_logs` | Anti-abuse — backend only |
| `permissions` | Admin panel only |
| `permission_templates` | Admin panel only |

---

## 📌 Constants Quick Reference

> **⚡ All values below are now DYNAMIC** — stored in `configurations/app_settings`.  
> Change via `updateAppConfig` function. Takes effect within 30 seconds.

```
REGION:              "asia-south1" (Mumbai, closest to Bangladesh)  [STATIC — code only]
MAX_NETWORK_DEPTH:   15 levels                                     [DYNAMIC → network.maxDepth]
VERIFICATION_DEPTH:  5 levels (for verification rewards)           [DYNAMIC → network.verificationDepth]
INVITE_CODE_LENGTH:  8 characters (S + 6 random + L)               [DYNAMIC → inviteCode.*]
POINTS_PER_AD:       30                                            [DYNAMIC → ads.pointsPerAd]
MAX_ADS_PER_DAY:     20                                            [DYNAMIC → ads.maxDailyAds]
CONVERSION_RATE:     100 points = 1৳                               [DYNAMIC → rewardPoints.conversionRate]
MIN_CONVERSION:      1,000 points                                  [DYNAMIC → rewardPoints.minConversion]
MAX_DAILY_CONVERT:   2 times                                       [DYNAMIC → rewardPoints.maxDailyConversions]
CONVERSION_FEE:      5%                                            [DYNAMIC → rewardPoints.conversionFeePercent]
MIN_WITHDRAWAL:      100৳                                          [DYNAMIC → wallet.minWithdrawalBDT]
WITHDRAWAL_FEE:      20৳ per 1,000৳                                [DYNAMIC → wallet.withdrawalFeePer1000]
VERIFICATION_PRICE:  250৳                                          [DYNAMIC → verification.priceBDT]
SUBSCRIPTION_PRICE:  400৳                                          [DYNAMIC → subscription.priceBDT]
MAX_STREAK_MULTI:    3.0x (at Day 28+)                             [DYNAMIC → streak.maxMultiplier]
```

---

**END OF FIRESTORE STRUCTURE DOCUMENT**
