# Unified Home Feed System – Full Reference Documentation

> **Purpose**  
> This document defines the **complete Home Feed architecture** where multiple content types (Community Posts, Micro Jobs, and future feed items) are displayed in **one mixed, Facebook‑style feed**.
>
> This is a **long‑term reference document** meant to be readable **1 year later**, understandable by **developers, admins, and non‑technical stakeholders**, and directly usable to implement **Firebase Firestore + Cloud Functions + Flutter UI**.

---

## 1️⃣ What is the Home Feed?

The **Home Feed** is a **curated, ordered stream of heterogeneous content** shown on the app’s home page.

It is **NOT** a direct merge of posts, jobs, ads, etc.

> **Golden Rule:**  
> 🔥 *Home Feed is a product layer, not a data layer.*

---

## 2️⃣ Current vs Future Feed Item Types

### ✅ Running (Implemented Now)
- Community Post
- Micro Job

### 🟡 Upcoming (Future‑Ready)
- Reselling
- Drive Offer
- Suggested Following
- On‑Demand Post
- Buy & Sell Post
- Sponsored Content
- Ads View
- Announcement

The architecture already supports all of them.

---

## 3️⃣ Feed Item Type ENUM (Core)

```ts
FeedItemType = {
  COMMUNITY_POST,
  MICRO_JOB,

  // upcoming
  RESELLING,
  DRIVE_OFFER,
  SUGGESTED_FOLLOWING,
  ON_DEMAND_POST,
  BUY_SELL_POST,
  SPONSORED,
  ADS_VIEW,
  ANNOUNCEMENT
}
```

Why ENUM?
- Prevents invalid content types
- Simplifies Flutter rendering logic
- Enables feature‑flag rollout

---

## 4️⃣ Feed Visibility ENUM

```ts
FeedVisibility = {
  PUBLIC,
  FRIENDS,
  ONLY_ME
}
```

Rules:
- **Community Post** → PUBLIC / FRIENDS / ONLY_ME
- **Micro Job** → always PUBLIC
- Future items decide visibility per type

---

## 5️⃣ New Collection: `/home_feeds`

```
home_feeds (Collection)
└── {feedId} (Document)
```

### Why a separate collection?
| Reason | Explanation |
|------|------------|
| Scalability | Avoids union queries across many collections |
| Control | Feed order & visibility controlled centrally |
| Cost | Single paginated query |
| Flexibility | New feed types without refactor |

---

## 6️⃣ `/home_feeds/{feedId}` Document Structure

```json
{
  "feedId": "feed_001",

  "type": "COMMUNITY_POST",
  "refId": "post_abc123",

  "priority": 10,

  "status": "ACTIVE",
  "visibility": "PUBLIC",

  "createdAt": "timestamp",

  "meta": {
    "authorId": "uid_1",
    "adminPinned": false,
    "boosted": false
  }
}
```

### Field‑by‑Field Explanation

| Field | Why it exists |
|-----|--------------|
| `type` | Determines which UI card to render |
| `refId` | Points to real data (`posts` / `jobs`) |
| `priority` | Controls feed mixing (jobs > posts) |
| `status` | Admin moderation without deleting data |
| `visibility` | Privacy filtering at feed level |
| `meta` | Algorithm & admin control flags |

---

## 7️⃣ Feed Status ENUM

```ts
FeedStatus = {
  ACTIVE,   // visible in feed
  HIDDEN,   // admin hidden
  REMOVED   // policy violation
}
```

---

## 8️⃣ Feed Creation (Automated via Cloud Functions)

### Community Post Flow
```
Post created → Pending
Admin approves post
↓
Cloud Function triggers
↓
Create home_feeds document
(type = COMMUNITY_POST)
```

### Micro Job Flow
```
Job created → Pending
Admin approves job
↓
Cloud Function triggers
↓
Create home_feeds document
(type = MICRO_JOB, priority higher)
```

❌ Client never writes to `home_feeds`

---

## 9️⃣ Feed Mixing Algorithm (Facebook‑Style)

### Base Rule (v1)
- 1 Micro Job after every **4–5 Community Posts**

### Priority‑based Ordering

```text
priority DESC
createdAt DESC
```

Example priorities:
- Micro Job → 20
- Community Post → 10
- Sponsored → 30 (future)

---

## 🔟 Firestore Query (Flutter)

```dart
FirebaseFirestore.instance
  .collection('home_feeds')
  .where('status', isEqualTo: 'ACTIVE')
  .orderBy('priority', descending: true)
  .orderBy('createdAt', descending: true)
  .limit(20);
```

Why this works:
- Single query
- Cheap reads
- Infinite scroll ready

---

## 1️⃣1️⃣ Flutter Rendering Strategy

```dart
switch(feedItem.type) {
  case COMMUNITY_POST:
    return CommunityPostCard(postId: feedItem.refId);

  case MICRO_JOB:
    return MicroJobCard(jobId: feedItem.refId);

  default:
    return SizedBox();
}
```

Each card:
- Fetches its own data
- Handles its own interactions

---

## 1️⃣2️⃣ Privacy Enforcement Logic

### Community Post
| Visibility | Who sees |
|----------|---------|
| PUBLIC | Everyone |
| FRIENDS | Followers only |
| ONLY_ME | Author only |

### Micro Job
- Always PUBLIC
- Feed ignores visibility change

---

## 1️⃣3️⃣ Admin Controls (Manual Actions)

Admins can:
- Hide feed item
- Remove feed item
- Pin feed item
- Boost priority

All via:
```
/home_feeds/{feedId}
```

Original post/job remains unchanged.

---

## 1️⃣4️⃣ Automated vs Manual Responsibilities

### Automated (Cloud Functions)
- Feed item creation
- Feed item removal on delete
- Priority assignment
- Audit logging

### Manual (Admin)
- Approve content
- Hide or remove feed items
- Pin announcements

---

## 1️⃣5️⃣ Audit Logging (Mandatory)

Every feed‑related action logs to:
```
/audit_logs
```

Examples:
- feed.create
- feed.hide
- feed.remove
- feed.boost

---

## 1️⃣6️⃣ Cost & Scale Optimization

- No joins in Firestore
- No client‑side merging
- No real‑time listeners on feed
- Pagination everywhere
- Minimal feed document size

---

## 1️⃣7️⃣ Why Big Platforms Do This

Facebook / Instagram model:
- Content stored separately
- Feed is algorithm‑driven
- Feed rules evolve without refactor

This architecture follows the same philosophy.

---

## 1️⃣8️⃣ Final Notes

✔ This system supports **15+ feed item types**
✔ Easy to evolve ranking algorithm
✔ Safe for Google Play review
✔ Clean separation of concerns

> **Never render home feed directly from content collections.**

---

**End of Document**

