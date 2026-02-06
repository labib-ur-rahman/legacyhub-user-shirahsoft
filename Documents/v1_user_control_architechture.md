# LegacyHub – Invite Code, Referral System & User Control Architecture (v1.0)

> **Document Type:** Long-term Technical & Business Reference (.md)
> **Audience:** Founder, Backend Engineers, Flutter Developers, Admin Panel Developers
> **Purpose:** One single source of truth so that even after **1 year**, anyone can fully understand **why**, **how**, and **what** was implemented.

---

## 1. Core Philosophy (Read First)

LegacyHub is **NOT** an MLM app from UI or policy perspective.

However, internally it uses a **multi-level network graph** strictly for:

* commission eligibility
* feature unlock rules
* growth analytics

⚠️ **Critical Rule**

* Flutter = UI only
* Cloud Functions = All logic
* Firestore = Data storage
* No MLM terms, trees, or income graphs in UI

---

## 2. Invite Code vs Referral Code (Very Important Distinction)

| Item      | Invite Code  | Referral Code    |
| --------- | ------------ | ---------------- |
| Used In   | Flutter UI   | Backend only     |
| Purpose   | Human entry  | Network identity |
| Length    | 8 chars      | Long / UID-based |
| Guessable | No           | Never exposed    |
| Storage   | invite_codes | users            |

---

## 3. Invite Code Design (UI Safe)

### 3.1 Format

```
S + 6 RANDOM + L
Example: SA7K9Q2L
```

### 3.2 Character Set

```
ABCDEFGHJKMNPQRSTUVWXYZ
23456789
```

❌ Excluded: O, I, l, 0, 1

### 3.3 Total Possibilities

```
32^6 ≈ 1,073,741,824 unique codes
```

➡️ Safe for millions of users

---

## 3.5 `users/{uid}` — Complete User Core Root Structure

> **This is the MOST IMPORTANT document structure in LegacyHub**
>
> Rule: This document must stay **small, stable, and authoritative**.

### Full JSON Structure

```json
{
  "uid": "uid_abc123",

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
    "inviteCode": "SA7K9Q2L",
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
    "isAdmin": false,
    "isModerator": false,
    "isTestUser": false
  },

  "limits": {
    "dailyAdsViewed": 0,
    "dailyRewardConverted": 0,
    "lastLimitReset": "2026-01-31"
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

### Section-by-Section Purpose

| Section     | Why It Exists                                  |
| ----------- | ---------------------------------------------- |
| identity    | Display name, profile, community UI            |
| codes       | Invite lookup + backend-only referral identity |
| network     | Only direct parent (graph handled elsewhere)   |
| status      | Verification, subscription, risk control       |
| wallet      | Snapshot only (real ledger elsewhere)          |
| permissions | Feature-level access control                   |
| flags       | Admin, moderator, test user handling           |
| limits      | Anti-abuse & rate limiting                     |
| meta        | Analytics, activity tracking                   |
| system      | Ban / suspend / admin notes                    |

---

## 4. Invite Code Storage (Uniqueness Guarantee)

### Collection

```
invite_codes/{inviteCode}
```

### Document Structure

```json
{
  "uid": "uid_abc123",
  "email": "user@email.com",
  "createdAt": "timestamp"
}
```

### Why This Exists

* Firestore has no unique constraint
* This collection works as a **manual unique index**
* Prevents duplicate invite codes forever

⚠️ Flutter MUST NEVER read this collection

---

## 5. Referral Code (Backend Secure Identity)

### Final Decision

```
referralCode = Firebase UID
```

### Why UID Is Best

* Already unique
* Already indexed
* Impossible to brute force
* No extra generation logic

Stored in:

```json
"codes": {
  "inviteCode": "SA7K9Q2L",
  "referralCode": "uid_abc123"
}
```

---

## 6. Signup Flow (Backend Controlled)

### Email / Password Signup

1. Flutter collects info
2. Sends Invite Code
3. Cloud Function validates invite code
4. Creates Firebase Auth user
5. Generates Invite Code
6. Builds network graph

### Google Sign-in

1. Firebase Auth creates user
2. Flutter shows Invite Code dialog
3. Cloud Function attaches network

⚠️ Invite Code is mandatory in both cases

---

## 7. User Roles & Flags

### Stored in `users/{uid}.flags`

```json
{
  "isAdmin": false,
  "isModerator": false,
  "isTestUser": false
}
```

| Role      | Purpose             |
| --------- | ------------------- |
| Admin     | Full system access  |
| Moderator | Content moderation  |
| Test User | Dummy wallet & APIs |

Flutter reads flags → UI only
Logic always verified by backend

---

## 8. User Account States

### Stored in `users/{uid}.status`

```json
{
  "accountState": "active",
  "verified": false,
  "subscription": "none",
  "riskLevel": "normal"
}
```

### accountState Values

* active
* suspended
* banned
* deleted

### riskLevel Values

* normal
* watch
* high
* fraud

Used for:

* withdrawal blocking
* ad limits
* reward conversion control

---

## 9. Ban / Suspend System

### Stored in `users/{uid}.system`

```json
{
  "banReason": null,
  "suspendUntil": null,
  "notes": ""
}
```

### Examples

* Temporary suspend → `suspendUntil`
* Permanent ban → `banReason`

Cloud Functions enforce all checks
Flutter only displays message

---

## 10. Test User Behavior (Extremely Important)

### Purpose

* QA testing
* Demo accounts
* No real API calls

### Rules

If `isTestUser = true`:

* Wallet balance is **dummy**
* Recharge shows success UI
* NO external API called
* Withdraw shows success but no payout

### Example

```json
"flags": { "isTestUser": true }
```

Cloud Functions:

```text
IF isTestUser
→ simulate response
→ skip payment gateway
```

---

## 11. Wallet Snapshot (Root Only)

```json
"wallet": {
  "balanceBDT": 1200,
  "rewardPoints": 45000,
  "locked": false
}
```

⚠️ No transaction history here

---

## 12. Wallet Ledger (Separate Collection)

```
wallet_transactions/{txnId}
```

```json
{
  "uid": "uid_abc123",
  "type": "credit",
  "source": "subscription_commission",
  "amount": 50,
  "createdAt": "timestamp"
}
```

Used for:

* audit
* admin review
* analytics

---

## 13. Active Status Tracking (Firestore-safe)

### Why NOT Realtime Database

* Higher cost
* Not needed

### Firestore Strategy

In `users/{uid}.meta`:

```json
{
  "lastActiveAt": "timestamp",
  "lastLoginAt": "timestamp"
}
```

Updated:

* On app open
* On critical actions

Admin can classify:

* Active (last 24h)
* Dormant (7 days)
* Inactive (30+ days)

---

## 14. Flutter Rules (DO & DON’T)

### Flutter CAN

* Show invite code
* Show wallet balance
* Show reward points
* Show community stats

### Flutter CANNOT

* Calculate commission
* Know level numbers
* Know referral graph
* Handle payments

Flutter = View only

---

## 15. Cloud Functions Responsibilities

* Invite code generation
* Network graph creation
* Commission calculation
* Wallet update
* Feature unlock check
* Ban / suspend enforcement
* Test user simulation

All sensitive logic stays here

---

## 16. Play Store Policy Safety Checklist

✔ No MLM UI
✔ No guaranteed income
✔ Ads ≠ money
✔ Backend-only commission
✔ Manual withdrawal review

---

## 17. Final Founder Note

This architecture was designed so that:

* system scales to millions
* rules remain enforceable
* Play Store approval remains safe
* new developers can onboard fast

> **If something looks complex here, it is intentional.**

---

**END OF DOCUMENT – VERSION 1.0**