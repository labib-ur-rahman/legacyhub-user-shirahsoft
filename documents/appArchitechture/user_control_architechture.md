# LegacyHub - Invite Code, Referral System & User Control Architecture (v1.1)

> Document Type: Long-term Technical & Business Reference (.md)
> Audience: Founder, Backend Engineers, Flutter Developers, Admin Panel Developers
> Purpose: A single source of truth so that even after 1 year, anyone can understand why, how, and what was implemented.
> Last Updated: February 7, 2026
> Synced With: documents/appArchitechture/cloud_functions_architecture.md, documents/appArchitechture/firestore_database_structure.md

---

## 1. Core Philosophy (Read First)

LegacyHub is NOT an MLM app from UI or policy perspective.

Internally, it uses a multi-level network graph strictly for:

- commission eligibility
- feature unlock rules
- growth analytics

WARNING:
- Flutter = UI only
- Cloud Functions = all business logic
- Firestore = data storage
- No MLM terms, trees, or income graphs in UI

---

## 2. Invite Code vs Referral Code (Very Important Distinction)

| Item | Invite Code | Referral Code |
| --- | --- | --- |
| Used In | Flutter UI | Backend only |
| Purpose | Human entry | Network identity |
| Length | 8 chars | UID-based |
| Guessable | No | Never exposed |
| Storage | invite_codes + users.codes.inviteCode | users.codes.referralCode |

Referral code is always the Firebase Auth UID.

---

## 3. Invite Code Design (UI Safe)

### 3.1 Format

```
S + 6 RANDOM + L
Example: SA7K9Q2L
```

### 3.2 Character Set

```
ABCDEFGHJKMNPQRSTUVWXYZ23456789
```

Excluded: O, I, l, 0, 1

### 3.3 Total Possibilities

```
32^6 ~= 1,073,741,824 unique codes
```

Safe for millions of users.

---

## 4. users/{uid} - Core User Document

This is the most important document structure in LegacyHub.

Rule: This document must stay small, stable, and authoritative.

### Full JSON Structure

```json
{
  "uid": "uid_abc123",
  "role": "user",

  "identity": {
    "firstName": "Labib",
    "lastName": "Ahmed",
    "email": "labib@gmail.com",
    "phone": "017XXXXXXXX",
    "authProvider": "password",
    "photoURL": "",
    "coverURL": ""
  },

  "codes": {
    "inviteCode": "SSHIRAHL",
    "referralCode": "uid_abc123"
  },

  "network": {
    "parentUid": "uid_parent",
    "joinedVia": "invite"
  },

  "status": {
    "accountState": "active",
    "verified": false,
    "subscription": "none",
    "riskLevel": "normal"
  },

  "wallet": {
    "balanceBDT": 0,
    "rewardPoints": 0,
    "locked": false
  },

  "permissions": {
    "canPost": false,
    "canWithdraw": false,
    "canViewCommunity": true
  },

  "flags": {
    "isTestUser": false
  },

  "limits": {
    "dailyAdsViewed": 0,
    "dailyRewardConverted": 0,
    "lastLimitReset": "2026-02-07"
  },

  "meta": {
    "createdAt": "timestamp",
    "updatedAt": "timestamp",
    "lastLoginAt": "timestamp",
    "lastActiveAt": "timestamp"
  },

  "system": {
    "banReason": null,
    "suspendUntil": null,
    "notes": ""
  }
}
```

### Section Purpose

| Section | Why It Exists |
| --- | --- |
| role | Role-based access control at system level |
| identity | Display name, profile, and login data |
| codes | Invite lookup + backend-only referral identity |
| network | Direct parent only (full graph elsewhere) |
| status | Verification, subscription, and risk control |
| wallet | Snapshot only (real ledger elsewhere) |
| permissions | Feature-level access control for regular users |
| flags | Special behavior toggles (test users) |
| limits | Anti-abuse and rate limiting |
| meta | Analytics and activity tracking |
| system | Ban, suspend, and admin notes |

---

## 5. Invite Code Storage (Uniqueness Guarantee)

Collection:
```
invite_codes/{inviteCode}
```

Document structure:
```json
{
  "uid": "uid_abc123",
  "email": "user@email.com",
  "createdAt": "timestamp"
}
```

Why this exists:
- Firestore has no unique constraint
- This collection acts as a manual unique index
- Flutter must never read this collection

---

## 6. Referral Code (Backend Secure Identity)

Final decision:
```
referralCode = Firebase UID
```

Why UID is best:
- already unique
- already indexed
- never exposed to users

Stored in:
```json
"codes": {
  "inviteCode": "SA7K9Q2L",
  "referralCode": "uid_abc123"
}
```

---

## 7. Network Graph Storage

The full network graph is stored outside the user document:

- user_uplines/{uid} for fast 1-15 level upline chain lookup
- user_relations/{autoId} for full graph edges (audit and analytics)
- user_network_stats/{uid} for aggregated counters used by Flutter UI

Flutter reads only user_network_stats for performance and security.

---

## 8. Signup Flow (Backend Controlled)

Email or password signup:
1. Flutter collects user info and invite code
2. Cloud Function validates the invite code
3. Firebase Auth user is created
4. users/{uid} is created
5. invite_codes/{newCode} is created
6. user_uplines/{uid} is built
7. user_relations edges are created
8. user_network_stats is initialized and incremented for uplines
9. audit_logs entry is written

Google sign-in:
1. Firebase Auth creates user
2. Flutter shows invite code dialog
3. Cloud Function attaches network and creates data (same as above)

Invite code is mandatory in both flows.

---

## 9. Roles, Permissions, and Admin Access

### 9.1 Role Hierarchy (users.role)

```
superAdmin (level 5)
  -> admin (level 4)
    -> moderator (level 3)
      -> support (level 2)
        -> user (level 1)
```

Rules:
- higher roles inherit lower role permissions
- a role cannot target a user with equal or higher role
- superAdmin bypasses all permission checks

### 9.2 Admin Permissions (admin_permissions)

Admin permissions are stored in a separate collection:
```
admin_permissions/{adminUid}
```

Access check logic:
- superAdmin always allowed
- otherwise check admin_permissions/{uid}.permissions[permissionId] == true

Permission templates (permission_templates) are optional presets for onboarding admins.

### 9.3 Feature Permissions (users.permissions)

Regular user feature access lives in the user document:
- canPost
- canWithdraw
- canViewCommunity

---

## 10. User Account States

Stored in users/{uid}.status:
```json
{
  "accountState": "active",
  "verified": false,
  "subscription": "none",
  "riskLevel": "normal"
}
```

accountState values:
- active
- suspended
- under_review
- banned
- deleted

subscription values:
- none
- active
- expired

riskLevel values:
- normal
- watch
- high
- fraud

---

## 11. Ban and Suspend System

Stored in users/{uid}.system:
```json
{
  "banReason": null,
  "suspendUntil": null,
  "notes": ""
}
```

Examples:
- temporary suspend uses suspendUntil
- permanent ban uses banReason

Cloud Functions enforce all checks. Flutter only displays status.

---

## 12. Test User Behavior (Important)

Purpose:
- QA testing
- demo accounts
- no real API calls

If flags.isTestUser == true:
- wallet balances are simulated
- recharge shows success UI
- no external payment API is called
- withdraw shows success but no payout

---

## 13. Wallet Snapshot and Ledgers

User document only stores snapshot:
```json
"wallet": {
  "balanceBDT": 1200,
  "rewardPoints": 45000,
  "locked": false
}
```

BDT wallet ledger is stored in wallet_transactions:
```json
{
  "id": "WTX_...",
  "uid": "uid_abc123",
  "type": "credit",
  "source": "subscription_commission",
  "amount": 50,
  "balanceBefore": 1150,
  "balanceAfter": 1200,
  "description": "Subscription commission",
  "reference": "uid_admin",
  "createdAt": "timestamp"
}
```

Reward points ledger is stored in reward_transactions.
Withdrawal requests are stored in withdrawal_requests.

---

## 14. Active Status Tracking (Firestore Safe)

We do not use Realtime Database for presence.

In users/{uid}.meta:
```json
{
  "lastActiveAt": "timestamp",
  "lastLoginAt": "timestamp"
}
```

Updated on app open and critical actions.

---

## 15. Dynamic Configuration (configurations/app_settings)

All business constants are read from:
```
configurations/app_settings
```

Examples of dynamic settings:
- network.maxDepth, network.verificationDepth
- inviteCode.*
- rewardPoints.*
- ads.*
- subscription.* and verification.*
- wallet.minWithdrawalBDT and wallet.withdrawalFeePer1000

Cloud Functions cache config for 30 seconds.
Region remains static: asia-south1.

---

## 16. Flutter Rules (Do and Do Not)

Flutter can:
- read users/{uid} for its own profile
- read user_network_stats/{uid} for network stats
- read wallet_transactions, reward_transactions, withdrawal_requests filtered by own uid
- show invite code, wallet balance, reward points

Flutter cannot:
- calculate commission or level depth
- access user_uplines, user_relations, invite_codes
- access admin_permissions, audit_logs, ad_view_logs
- handle payments or approvals

Flutter is view-only. All logic stays on Cloud Functions.

---

## 17. Cloud Functions Responsibilities

Major responsibilities:
- invite code generation and validation
- network graph creation and updates
- commission and reward distribution
- wallet updates and withdrawal pipeline
- feature unlock checks
- admin actions (ban, suspend, role change, permission grants)
- audit logging for sensitive actions
- config reads from configurations/app_settings

---

## 18. Play Store Policy Safety Checklist

- no MLM UI
- no guaranteed income
- ads are not shown as money
- commission logic is backend-only
- withdrawals are admin-reviewed

---

## 19. Final Founder Note

This architecture was designed so that:
- the system scales to millions
- rules remain enforceable
- Play Store approval remains safe
- new developers can onboard fast

If something looks complex here, it is intentional.

---

END OF DOCUMENT - VERSION 1.1
