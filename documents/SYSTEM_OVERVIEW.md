# 🎯 LegacyHub Admin Panel - System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    LEGACYHUB ECOSYSTEM                          │
└─────────────────────────────────────────────────────────────────┘

┌────────────────────────┐         ┌────────────────────────┐
│  ADMIN PANEL APP       │         │  USER APP              │
│  (This Repository)     │         │  (Separate Repo)       │
├────────────────────────┤         ├────────────────────────┤
│ • System Management    │         │ • Earn Rewards         │
│ • User Management      │         │ • View Ads             │
│ • Permissions Control  │         │ • Withdraw Money       │
│ • Analytics Dashboard  │         │ • Community Feed       │
│                        │         │                        │
│ Users:                 │         │ Users:                 │
│ ✓ Super Admin (1-3)    │         │ ✓ Regular Users        │
│ ✓ Admins               │         │   (Unlimited)          │
│ ✓ Moderators           │         │                        │
│ ✓ Support Staff        │         │ Signup:                │
│                        │         │ • With invite code     │
│ Signup:                │         │ • Through this app     │
│ • Requires invite code │         │ • Cloud Functions      │
│ • Restricted access    │         │                        │
└────────────────────────┘         └────────────────────────┘
         │                                    │
         └────────────────┬───────────────────┘
                          │
                          ▼
         ┌─────────────────────────────────┐
         │   FIREBASE BACKEND               │
         ├─────────────────────────────────┤
         │ • Authentication                │
         │ • Firestore Database            │
         │ • Cloud Functions               │
         │ • Storage                       │
         └─────────────────────────────────┘
```

---

## 🔐 Admin Panel Signup Flow

```
START: User wants to join admin team
│
├─ 1. Super Admin creates account manually
│     ├─ Run: npm run create-super-admin
│     ├─ Creates Firebase Auth user
│     ├─ Creates Firestore documents
│     └─ Generates invite code: SSHIRAHL
│
├─ 2. Super Admin shares invite code
│     └─ Gives SSHIRAHL to trusted team member
│
├─ 3. Team member opens admin panel
│     ├─ Clicks "Sign Up"
│     ├─ Enters info + SSHIRAHL
│     └─ Submits form
│
├─ 4. Cloud Functions validate
│     ├─ Checks invite code exists
│     ├─ Finds parent UID (Super Admin)
│     ├─ Creates Firebase Auth user
│     └─ Builds documents
│
└─ 5. Account created
      ├─ User can login
      ├─ Network graph built
      └─ Role: "user" (can be promoted)
```

---

## 📊 Firestore Collections Structure

```
legacyhub-shirahsoft (Firebase Project)
│
├─ users/{uid}
│  ├─ uid: string
│  ├─ role: "superAdmin" | "admin" | "moderator" | "support" | "user"
│  ├─ identity: { firstName, lastName, email, phone, ... }
│  ├─ codes: { inviteCode, referralCode }
│  ├─ network: { parentUid, joinedVia }
│  ├─ status: { accountState, verified, subscription, ... }
│  ├─ wallet: { balanceBDT, rewardPoints, locked }
│  ├─ permissions: { canPost, canWithdraw, ... }
│  ├─ flags: { isTestUser }
│  ├─ limits: { dailyAdsViewed, ... }
│  ├─ meta: { createdAt, updatedAt, ... }
│  └─ system: { banReason, suspendUntil, ... }
│
├─ invite_codes/{inviteCode}
│  ├─ uid: string (owner's UID)
│  ├─ email: string
│  └─ createdAt: timestamp
│
├─ user_uplines/{uid}
│  ├─ u1: uid | null (direct parent)
│  ├─ u2: uid | null (grandparent)
│  ├─ u3: uid | null
│  ├─ ... (up to u15)
│  ├─ maxDepth: 15
│  └─ createdAt: timestamp
│
├─ user_relations/{autoId}
│  ├─ ancestorUid: string
│  ├─ descendantUid: string
│  ├─ level: number
│  ├─ descendantVerified: boolean
│  ├─ descendantSubscribed: boolean
│  └─ createdAt: timestamp
│
└─ user_network_stats/{uid}
   ├─ level1: { total, verified, subscribed }
   ├─ level2: { total, verified, subscribed }
   ├─ ... (up to level15)
   └─ updatedAt: timestamp
```

---

## 🔑 Super Admin Document Example

```json
{
  "uid": "abc123xyz",
  "role": "superAdmin",
  
  "identity": {
    "firstName": "Super",
    "lastName": "Admin",
    "email": "contact.labibur@gmail.com",
    "phone": "+8801700000000",
    "authProvider": "password",
    "photoURL": "",
    "coverURL": ""
  },
  
  "codes": {
    "inviteCode": "SSHIRAHL",
    "referralCode": "abc123xyz"
  },
  
  "network": {
    "parentUid": null,           ← No parent for super admin
    "joinedVia": "manual"
  },
  
  "status": {
    "accountState": "active",
    "verified": true,
    "subscription": "active",
    "riskLevel": "normal"
  },
  
  "wallet": {
    "balanceBDT": 0,
    "rewardPoints": 0,
    "locked": false
  },
  
  "permissions": {
    "canPost": true,
    "canWithdraw": true,
    "canViewCommunity": true
  },
  
  "flags": {
    "isTestUser": false
  }
}
```

---

## 👥 Role Hierarchy

```
┌──────────────────────┐
│    Super Admin       │  ← Manually created (1-3 people)
│    (Owner/Founder)   │     Full system access
└──────────────────────┘
          │
          ├─────────────────────────────┐
          │                             │
┌──────────────────┐         ┌──────────────────┐
│     Admin        │         │    Moderator     │
│  (Operations)    │         │   (Community)    │
└──────────────────┘         └──────────────────┘
          │                             │
          └──────────────┬──────────────┘
                         │
              ┌──────────────────┐
              │     Support      │
              │  (Help Desk)     │
              └──────────────────┘
                         │
              ┌──────────────────┐
              │      User        │
              │  (Team Member)   │
              └──────────────────┘
```

---

## 🚦 Account States

```
┌─────────────┐
│   ACTIVE    │ ← Can login, use all features
└─────────────┘
      │
      ├─ Warning issued
      ▼
┌─────────────┐
│  SUSPENDED  │ ← Can login, limited features
└─────────────┘
      │
      ├─ Violation confirmed
      ▼
┌─────────────┐
│   BANNED    │ ← Cannot login
└─────────────┘
      │
      ├─ Request deletion
      ▼
┌─────────────┐
│  DELETED    │ ← Soft delete, data retained
└─────────────┘
```

---

## 📋 Verification Checklist

After running `npm run create-super-admin`:

```
Firebase Authentication
└─ ✅ User exists with email: contact.labibur@gmail.com

Firestore Database
├─ ✅ users/abc123xyz
│   └─ role = "superAdmin"
│
├─ ✅ invite_codes/SSHIRAHL
│   └─ uid = "abc123xyz"
│
├─ ✅ user_uplines/abc123xyz
│   └─ u1 to u15 = null
│
└─ ✅ user_network_stats/abc123xyz
    └─ level1 to level15 = { total: 0, verified: 0, subscribed: 0 }
```

---

## 🎯 Quick Commands

```bash
# Create super admin
cd functions && npm run create-super-admin

# Deploy Cloud Functions
firebase deploy --only functions

# Test locally
firebase emulators:start

# View logs
firebase functions:log

# Build functions
cd functions && npm run build

# Lint functions
cd functions && npm run lint
```

---

## 📞 Common Issues & Solutions

### ❌ "Invite code not found"
**Solution**: Run `npm run create-super-admin` first

### ❌ "Permission denied"
**Solution**: `firebase login` then try again

### ❌ "Module not found"
**Solution**: `cd functions && npm install && npm run build`

### ❌ Localization errors
**Solution**: Already fixed! Just rebuild Flutter app

### ❌ "User already exists"
**Solution**: Super admin already created, check Firebase Console

---

**Last Updated**: February 5, 2026  
**Version**: 1.0  
**Status**: ✅ Production Ready
