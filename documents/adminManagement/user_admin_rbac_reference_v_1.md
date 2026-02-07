# 📘 LegacyHub – User, Admin, Permission & Account Control System
**Single Source of Truth Documentation**

> **Document Type:** Long-term Technical & Business Reference  
> **Audience:** Founder, Backend Engineers, Flutter Developers, Admin Panel Developers  
> **Purpose:** Explain **WHY**, **HOW**, and **WHAT** behind LegacyHub’s user & admin control system  
> **Scope:** Users, Admins, Roles, Permissions, Status, Audit, Test Users

---

## 1. Core Philosophy (Read First)

LegacyHub follows **enterprise-grade access control**, inspired by:

* Fintech apps
* Marketplaces
* SaaS admin dashboards

### Fundamental Rule

> ❗ **Role ≠ Permission ≠ Status ≠ Flags**

Mixing them will break scaling, audit, and security.

---

## 2. Users Collection – Root of All Control

Everything starts from:

```
users/{uid}
```

This document is the **single source of truth**.

---

## 3. Role System (WHO you are)

### 3.1 Role Definition

Role represents **broad responsibility**, not power.

Stored in:

```
users/{uid}.role
```

### Allowed Roles

| Role        | Purpose                          |
|-------------|----------------------------------|
| superAdmin  | System owner / founder           |
| admin       | Operations & finance managers    |
| moderator   | Community moderation             |
| support     | Customer support                 |
| user        | Normal app user                  |

### Example

```json
"role": "user"
```

> ⚠️ Flutter never decides role power. Backend only.

---

## 4. Permission System (WHAT you can do)

Permissions are **atomic actions**.

### 4.1 Master Permission Registry (Static)

```
permissions/{permissionId}
```

Example:

```json
{
  "id": "withdraw.approve",
  "group": "wallet",
  "description": "Approve user withdrawal",
  "dangerLevel": "high"
}
```

Rules:
* Created only by SuperAdmin
* Rarely changes
* Used for audit, UI, validation

---

### 4.2 Admin Permission Assignment

```
admin_permissions/{adminUid}
```

```json
{
  "uid": "admin_123",
  "permissions": {
    "withdraw.review": true,
    "withdraw.approve": true,
    "user.suspend": true
  },
  "assignedBy": "superAdminUid",
  "updatedAt": "timestamp"
}
```

Why boolean map?
* O(1) check
* Easy revoke
* No array scan

---

### 4.3 Permission Templates (Optional)

```
permission_templates/{templateId}
```

Used for fast onboarding only.

---

## 5. Account Status System (CONDITION of account)

Status controls **lifecycle & restrictions**.

Stored in:

```
users/{uid}.status
```

### 5.1 Status Fields

```json
"status": {
  "accountState": "active",
  "verified": false,
  "subscription": "none",
  "riskLevel": "normal"
}
```

### 5.2 accountState Lifecycle

| State        | Meaning                          |
|--------------|----------------------------------|
| active       | Normal operation                 |
| suspended    | Temporary restriction            |
| under_review | Fraud / abuse investigation      |
| banned       | Permanent block                  |
| deleted      | Soft delete                      |

### 5.3 State → Behavior Mapping

| State        | Login | Earn | Withdraw |
|--------------|-------|------|----------|
| active       | ✅    | ✅   | ✅       |
| suspended    | ✅    | ❌   | ❌       |
| under_review | ✅    | ❌   | ❌       |
| banned       | ❌    | ❌   | ❌       |
| deleted      | ❌    | ❌   | ❌       |

---

## 6. Test User System (Mandatory for Safety)

Test users are **flags**, NOT roles.

```json
"flags": {
  "isTestUser": true
}
```

### Behavior

* Fake wallet balance
* Fake success responses
* Withdraw always blocked
* No real payment APIs hit

### Used For

* QA
* Demo
* Internal testing
* Play Store review safety

> Backend always checks `isTestUser` before money logic.

---

## 7. Wallet & Limits Control

Wallet stored under:

```json
"wallet": {
  "balanceBDT": 0,
  "rewardPoints": 0,
  "locked": false
}
```

If:
* `wallet.locked = true` → all transactions blocked
* Used during investigations

Limits:

```json
"limits": {
  "dailyAdsViewed": 0,
  "dailyRewardConverted": 0,
  "lastLimitReset": "2026-01-31"
}
```

---

## 8. Audit & Logging System (MANDATORY)

Every sensitive action must log.

### 8.1 Audit Collection

```
audit_logs/{logId}
```

### 8.2 Audit Log Structure

```json
{
  "actorUid": "admin_123",
  "actorRole": "admin",
  "action": "withdraw.approve",
  "targetUid": "user_456",
  "before": {},
  "after": {},
  "timestamp": "server_ts",
  "ipHash": "hashed_ip",
  "device": "web_admin"
}
```

### Mandatory For

* Withdraw approvals
* User bans / suspensions
* Role changes
* Permission changes

> No audit = no production approval.

---

## 9. How to Add Super Admin (One-Time Process)

### Rules

* Manual creation only
* Max 1–3 accounts
* 2FA mandatory

### Steps

1. Create user via Firebase Auth
2. Manually update Firestore:

```json
"role": "superAdmin"
```

3. Lock permissions (implicit full access)

---

## 10. How SuperAdmin Adds Other Admins

### Flow

1. SuperAdmin sets role:

```json
"role": "admin"
```

2. Assign permissions via:

```
admin_permissions/{uid}
```

3. Audit log created automatically

Same flow applies for:
* moderator
* support

---

## 11. Final `users` Collection (Clean & Scalable)

### Final Structure (Recommended)

```json
{
  "uid": "...",
  "identity": {},
  "role": "user",

  "codes": {},
  "network": {},

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

  "flags": {
    "isTestUser": false
  },

  "limits": {},
  "meta": {},
  "system": {}
}
```

> Admin permissions NEVER live inside users doc.

---

## 12. Role, Status & Permission Checks

### 12.1 Server Side (Cloud Functions)

Golden Rule:

> **Flutter requests → Server decides**

Example:

```ts
if (user.role !== 'admin') reject();
if (user.status.accountState !== 'active') reject();
if (!adminPerms['withdraw.approve']) reject();
```

### 12.2 Flutter Side (UX Only)

Flutter:
* Reads role & permissions
* Shows / hides UI
* Never enforces security

Example:

```dart
if (permissions['withdraw.approve']) {
  showApproveButton();
}
```

Backend still rechecks.

---

## 13. Anti-Patterns (Never Ever)

❌ Permission logic in Flutter  
❌ Storing admin permissions inside users doc  
❌ Hardcoded admin emails  
❌ Using flags instead of roles  
❌ Mixing status & role  

---

## 14. Final Mental Model

> **Identity** → Who logged in  
> **Role** → Responsibility  
> **Permission** → Action allowed  
> **Status** → Current condition  
> **Flags** → Special behavior  

If this separation stays clean, **LegacyHub will scale safely to millions**.

---

### ✅ End of Reference

