# 📘 LegacyHub – Upline–Downline System Architecture (Firestore + Cloud Functions + Flutter)

> **Purpose**: This document is a long‑term reference note. You can open it after **1 year** and still clearly understand **why**, **how**, and **where** each part of the upline–downline system works.  
> Target readers: **Developers, Tech Leads, Product Owners, Admins, Future Hires, AI Agents**.

---

## 1. Core Philosophy (Read This First)

### What this system is
A **graph‑based referral hierarchy** where:
- Each user can have **1 parent (upline)**
- Each user can have **unlimited children (downlines)**
- Depth is limited (example: **15 levels**)

### What this system is NOT
- Not a tree stored inside a single document
- Not array‑based hierarchy
- Not calculated in Flutter

### Golden Rules
- **Firestore stores data**
- **Cloud Functions calculate relationships**
- **Flutter only reads prepared results**

If Flutter understands the graph → system will break at scale.

---

## 2. Conceptual Model (Mental Map)

```
User joins → Uses Invite Code
          → Parent resolved
          → Upline chain generated (1–15)
          → Relations stored
          → Stats aggregated
```

We separate the system into **4 layers**:

| Layer | Responsibility |
|------|---------------|
| users | Identity & status |
| user_uplines | Fast parent chain lookup |
| user_relations | Full graph truth |
| user_network_stats | Aggregated numbers for UI & rules |

---

## 3. Collections Overview (What Exists & Why)

### 3.1 users (Identity Layer)

```
users/{uid}
```

Stores **who the user is**, not who they are connected to.

Used by:
- Flutter (profile, status)
- Admin panels
- Permission checks

**Never** store downlines here.

---

### 3.2 user_uplines (Snapshot Layer)

```
user_uplines/{uid}
```

```json
{
  "u1": "uid_parent",
  "u2": "uid_level2",
  "u3": "uid_level3",
  "u4": null,
  "maxDepth": 15,
  "createdAt": "timestamp"
}
```

#### Why this exists
- One read → all uplines
- Used in commission, rewards, permissions

#### Rules
- Max 15 keys
- Order never changes
- Only Cloud Functions can write

Flutter: **READ ONLY**

---

### 3.3 user_relations (Graph Truth Layer)

```
user_relations/{autoId}
```

```json
{
  "ancestorUid": "uid_A",
  "descendantUid": "uid_D",
  "level": 3,
  "descendantVerified": true,
  "descendantSubscribed": false,
  "createdAt": "timestamp"
}
```

#### What this represents
One **edge** in the graph.

```
A → D (level 3)
```

#### Why this exists
- Auditing
- Analytics
- Rebuilding stats
- Admin deep inspection

Flutter **should not** query this directly.

---

### 3.4 user_network_stats (Aggregation Layer)

```
user_network_stats/{uid}
```

```json
{
  "level1": { "total": 50, "verified": 30, "subscribed": 10 },
  "level2": { "total": 120, "verified": 60, "subscribed": 20 },
  "level3": { "total": 300, "verified": 80, "subscribed": 25 },
  "updatedAt": "timestamp"
}
```

#### Why this exists
- Flutter UI
- Feature unlock rules
- Progress tracking

No heavy queries needed.

---

## 4. Signup Flow (Cloud Function Theory)

### Trigger
- User signs up using **Invite Code**

### Steps

1. Resolve parent UID from invite code
2. Read `user_uplines` of parent
3. Build new upline chain:

```
new.u1 = parent
new.u2 = parent.u1
new.u3 = parent.u2
...
```

4. Save:
- users/{uid}
- user_uplines/{uid}

5. For each upline (1–15):
- Create `user_relations` doc
- Increment `user_network_stats`

All inside **transaction / batch**.

---

## 5. Downline Counting Logic

### Question
> "How many verified users do I have at level 3?"

### Answer
Never calculate live.

Use:
```
user_network_stats/{uid}.level3.verified
```

This value is:
- Updated on signup
- Updated on verify
- Updated on subscription

---

## 6. Commission & Reward Theory

### Trigger events
- User verified
- User subscribed

### Flow

1. Read `user_uplines/{uid}`
2. Loop level by level
3. Eligibility checks:
   - Is upline active?
   - Not banned?
   - Required rank met?

4. Credit wallet
5. Log ledger

Flutter never touches commission math.

---

## 7. Flutter App Usage Guide

### Flutter SHOULD do
- Read `users/{uid}`
- Read `user_network_stats/{uid}`
- Display charts, progress, locked features

### Flutter SHOULD NOT do
- Traverse graph
- Query user_relations
- Calculate commissions

### Recommended UI

| Screen | Data Source |
|------|------------|
| My Network | user_network_stats |
| Progress | user_network_stats |
| Rewards | wallet summary |
| Admin | Cloud Function APIs |

---

## 8. Query Design (Efficiency)

### Backend Queries

```
WHERE ancestorUid == X
AND level == 2
AND descendantVerified == true
```

Used by:
- Admin panels
- Analytics

### Flutter Queries

Single document reads only.

No collection scans.

---

## 9. Roles & Access Understanding

### Developer
- Understands graph layers
- Writes Cloud Functions only

### Owner
- Sees stats, growth, analytics

### Admin
- Audits relations
- Flags abuse

### General User
- Sees numbers only

### AI Agent
- Consumes aggregated stats
- Never raw relations

---

## 10. Scaling & Future Safety

### Why this scales
- Fixed depth
- Write‑heavy, read‑light
- No recursive queries

### When rebuilding needed
- Corrupted stats
- New rules

Solution:
Rebuild stats from `user_relations`.

---

## 11. Final Summary (Remember This)

> **Relations build the truth**  
> **Snapshots make it fast**  
> **Flutter stays dumb**  
> **Cloud Functions stay smart**

If you follow this:
- System scales
- Google Play stays safe
- New developers understand fast

---

_End of reference document_

