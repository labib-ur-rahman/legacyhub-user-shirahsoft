# Community Post, Reaction & Comment System

> **Final Production Reference Documentation**  
> Platform: Flutter + Firebase (Firestore, Cloud Functions)  
> Audience: Developers, Admins, Product Owners, Future Maintainers  
> Goal: Zero ambiguity, readable after years, implementation-ready

---

## 1. Why This Document Exists

This document is the **single source of truth** for the Community Post system.

Anyone reading this should be able to:
- Understand the **full A → Z flow** without asking questions
- Know **why** each collection and field exists
- Implement **Flutter UI**, **Firestore**, and **Cloud Functions** correctly
- Maintain, scale, or refactor the system in the future

---

## 2. High-Level System Overview

### Core Features
- Post creation with admin review
- Post reactions (Like, Love, Haha, Sad, Angry)
- Comments on posts
- Replies on comments (**max level = 1**)
- Reactions on comments
- Privacy control (Public / Friends / Only Me)

### Key Constraints
- Replies **do not support reactions**
- Replies **cannot have nested replies**
- All counters are **server-managed**

---

## 3. ENUM DEFINITIONS (MANDATORY)

Enums must be identical across Flutter, Firestore, and Cloud Functions.

### 3.1 PostStatus

```ts
PENDING    // Post created, waiting for admin review
APPROVED   // Post approved and visible
REJECTED   // Post rejected with admin note
```

**Why:** Required for moderation and Google Play UGC compliance.

---

### 3.2 PostPrivacy

```ts
PUBLIC     // Visible to everyone
FRIENDS   // Visible only to followers
ONLY_ME   // Visible only to author
```

**Why:** User data control and privacy compliance.

---

### 3.3 ReactionType

```ts
LIKE
LOVE
HAHA
SAD
ANGRY
```

**Why enums:** Prevent invalid data and allow deterministic counters.

---

## 4. Post Lifecycle (End-to-End)

```
User creates post
   ↓
Post saved with status = PENDING
   ↓
Admin reviews post
   ↓
APPROVED → Visible by privacy rules
REJECTED → User notified with reason
```

---

## 5. Firestore DATA MODEL (FINAL & CONFIRMED)

This section defines the **exact structure** you must follow.

---

### 5.1 Posts (Main Feed Collection)

**Path**
```
/posts/{postId}
```

```json
{
  "postId": "auto_id",

  "author": {
    "uid": "uid_123",            // Post owner
    "name": "Labib",             // Cached for fast feed rendering
    "photo": "url"
  },

  "content": {
    "text": "Post text here",
    "images": ["url1", "url2"]
  },

  "privacy": "PUBLIC",           // PostPrivacy enum
  "status": "APPROVED",          // PostStatus enum

  "reactionSummary": {
    "total": 10,
    "like": 5,
    "love": 3,
    "haha": 2,
    "sad": 0,
    "angry": 0
  },

  "commentCount": 4,              // Includes comments only (not replies)

  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Why this exists:**
- This is the **only collection loaded on feed**
- Must stay small and cheap

---

### 5.2 Post Reactions

**Path**
```
/posts/{postId}/reactions/{userId}
```

```json
{
  "userId": "uid_456",
  "reaction": "LIKE",           // ReactionType enum
  "createdAt": "timestamp"
}
```

**Why subcollection:**
- Loaded only when reaction list screen opens
- One user = one reaction per post

---

### 5.3 Comments (Top-Level Collection)

**Path**
```
/comments/{commentId}
```

```json
{
  "commentId": "auto_id",
  "postId": "post_123",          // Parent post reference

  "author": {
    "uid": "uid_789",
    "name": "Ahmed",
    "photo": "url"
  },

  "text": "Nice post!",

  "reactionSummary": {
    "total": 2,
    "like": 1,
    "love": 1,
    "haha": 0,
    "sad": 0,
    "angry": 0
  },

  "replyCount": 1,
  "createdAt": "timestamp"
}
```

**Why top-level:**
- Fast pagination
- Avoid deep nesting
- Scales to high volume

---

### 5.4 Comment Reactions (MISSING PART – NOW ADDED)

**Path**
```
/comments/{commentId}/reactions/{userId}
```

```json
{
  "userId": "uid_456",
  "reaction": "LOVE",           // ReactionType enum
  "createdAt": "timestamp"
}
```

**Rules:**
- One reaction per user per comment
- Managed by Cloud Functions

---

### 5.5 Replies (Level-1 Only, No Reactions)

**Path**
```
/replies/{replyId}
```

```json
{
  "replyId": "auto_id",
  "postId": "post_123",
  "commentId": "comment_456",

  "author": {
    "uid": "uid_999",            // Can be post author OR any user
    "name": "User Name",
    "photo": "url"
  },

  "text": "Thanks for your comment!",
  "createdAt": "timestamp"
}
```

**Important rules:**
- Replies have **NO reactions**
- Replies cannot have replies

---

## 6. Loading Strategy (Cost-Optimized)

### 6.1 Feed Screen

Load ONLY from `/posts`:
- content
- reactionSummary
- commentCount

No comments, no reaction lists.

---

### 6.2 Reaction List Screen

Triggered only when user taps reaction count.

```
/posts/{postId}/reactions
limit 50
```

---

### 6.3 Comment Screen

**Step 1 – Load comments**
```
/comments
where postId == X
orderBy createdAt
limit 20
```

**Step 2 – Load replies on demand**
```
/replies
where commentId == Y
orderBy createdAt
limit 10
```

---

## 7. Cloud Functions (SERVER AUTHORITY)

### Why Cloud Functions are mandatory
- Prevent fake counts
- Avoid race conditions
- Enforce business rules

---

### 7.1 Post Reaction Handling

```text
onCreate / onUpdate post reaction
→ transaction updates posts.reactionSummary
```

---

### 7.2 Comment Creation

```text
onCreate comment
→ posts.commentCount +1
```

---

### 7.3 Reply Creation

```text
onCreate reply
→ comments.replyCount +1
```

---

### 7.4 Comment Reaction Handling

```text
onCreate / onUpdate comment reaction
→ update comments.reactionSummary
```

---

## 8. Admin Review & Control

### 8.1 Admin Review Queue

```
/posts where status == PENDING
```

Admin can:
- Approve post
- Reject post with reason
- Remove links and add note

---

### 8.2 Privacy Enforcement

| Privacy | Visibility |
|------|------------|
| PUBLIC | Everyone |
| FRIENDS | Followers only |
| ONLY_ME | Author only |

**Enforced via Firestore Security Rules**

---

## 9. Flutter UI GUIDELINES

### Feed Screen
- Paginated list
- Minimal data

### Comment Screen
- Add comment input
- Lazy load comments
- Expand replies manually

### Reaction UX
- Tap = Like
- Long press = picker

---

## 10. Scalability & Cost Control

| Strategy | Benefit |
|--------|--------|
| Lazy loading | Low read cost |
| Counters | No aggregation queries |
| Flat collections | Infinite scale |

---

## 11. Final One-Line Summary

> **This system loads fast, scales safely, costs less, and stays compliant—without sacrificing features or control.**

---

**END OF FINAL DOCUMENTATION**

