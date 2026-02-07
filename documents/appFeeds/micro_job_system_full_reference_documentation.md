# Micro Job System – Production Reference Documentation

> **Purpose**: This document explains the complete **Micro Job / Job Post system** architecture using **Firebase Firestore, Cloud Functions, and Flutter UI**, fully aligned with the existing `users`, `wallet_transactions`, `reward_transactions`, and `audit_logs` collections.
>
> This is a **long-term reference** meant to be readable **1 year later**, understandable by **developers, admins, and product owners**, and directly usable to implement **Firebase Cloud Functions** safely.

---

## 1️⃣ What is a Micro Job?

A **Micro Job** is a prepaid, admin-reviewed task created by a user (Job Author) where:
- Multiple users (Workers) can complete a small task
- Each worker earns a fixed reward (BDT + reward points)
- Proof is submitted and manually reviewed

Examples:
- Facebook Page Like + Comment
- YouTube Video Like
- App Install & Screenshot

---

## 2️⃣ Core Principles (Why this architecture)

1. **Money Safety** – Wallet debit/credit is server-only
2. **Abuse Prevention** – One user can submit once per job
3. **Scalability** – Heavy data separated into collections
4. **Auditability** – Every sensitive action is logged
5. **Play Store Safe** – No misleading earning promises, prepaid model

---

## 3️⃣ Job Status ENUMs

```ts
JobStatus = {
  PENDING,    // Created, waiting for admin approval
  APPROVED,   // Visible to users
  REJECTED,   // Rejected by admin with note
  PAUSED,     // Temporarily hidden by admin
  COMPLETED   // Limit reached or manually closed
}
```

---

## 4️⃣ Job Type ENUMs

```ts
JobType = {
  FACEBOOK_LIKE_COMMENT,
  FACEBOOK_PAGE_LIKE,
  YOUTUBE_LIKE,
  APP_INSTALL,
  WEBSITE_VISIT
}
```

---

## 5️⃣ Firestore Collections Overview

```
/jobs
/job_submissions
/users
/wallet_transactions
/reward_transactions
/audit_logs
```

---

## 6️⃣ `/jobs/{jobId}` — Micro Job Document

### Why this collection exists
- Needed for fast listing (first load)
- Contains only **lightweight, queryable fields**

### Structure
```json
{
  "jobId": "job_abc123",
  "authorId": "uid_1",
  "authorName": "Labib",

  "title": "Facebook Page Like + Comment",
  "details": "Step-by-step instructions in text",
  "coverImage": "https://storage/...",
  "jobLink": "https://facebook.com/...",

  "jobType": "FACEBOOK_LIKE_COMMENT",

  "limit": 500,
  "perUserPrice": 1,
  "totalPrice": 500,

  "submittedCount": 401,
  "approvedCount": 380,

  "status": "APPROVED",
  "rejectionNote": null,

  "createdAt": "timestamp",
  "approvedAt": "timestamp"
}
```

### Field Explanations
| Field | Reason |
|------|-------|
| `limit` | Max workers allowed |
| `submittedCount` | Enforces limit without aggregation |
| `approvedCount` | Analytics + payout tracking |
| `status` | Controls visibility |

---

## 7️⃣ Job Creation Flow (Cloud Function)

### Function: `createMicroJob()`

**Why Cloud Function?**
- Prevent fake balance usage
- Prevent client manipulation

### Steps
1. Read user wallet from `/users/{uid}.wallet`
2. Check `balanceBDT >= totalPrice`
3. If insufficient → reject
4. If sufficient:
   - Debit wallet
   - Create job with `status = PENDING`
   - Log `wallet_transactions`
   - Log `audit_logs`

---

## 8️⃣ Admin Review Flow

### Admin Actions
- Approve Job
- Reject Job (note required)
- Pause Job

### Example: Approve Job

```ts
approveJob(jobId)
```

Actions:
- Update status → APPROVED
- Set `approvedAt`
- Write audit log

---

## 9️⃣ Job Visibility Logic (Flutter)

A job is visible to workers only if:

```text
status == APPROVED
AND status != PAUSED
AND submittedCount < limit
```

Firestore query:
```dart
FirebaseFirestore.instance
  .collection('jobs')
  .where('status', isEqualTo: 'APPROVED')
  .limit(20);
```

---

## 🔟 `/job_submissions/{submissionId}` — Proof Submission

### Why separate collection?
- Can grow to millions
- Easier pagination
- Prevent job document bloat

### Structure
```json
{
  "jobId": "job_abc123",
  "jobAuthorId": "uid_1",

  "workerId": "uid_2",
  "workerName": "User X",

  "proofImages": ["url1", "url2"],
  "proofText": "I completed the task",

  "status": "PENDING",

  "createdAt": "timestamp",
  "reviewedAt": null
}
```

---

## 1️⃣1️⃣ Proof Submission Rules

- One submission per user per job
- Enforced in Cloud Function
- Atomic increment of `submittedCount`

---

## 1️⃣2️⃣ Proof Review & Reward Flow

### Approve Submission

Cloud Function:
1. Validate submission = PENDING
2. Update status → APPROVED
3. Increment `approvedCount`
4. Credit worker wallet (+BDT)
5. Credit reward points (+5)
6. Write wallet + reward transactions
7. Write audit log

### Reject Submission
- Update status → REJECTED
- Decrement `submittedCount`
- Store rejection note

---

## 1️⃣3️⃣ Wallet & Reward Integration

### Wallet debit/credit
- Uses `/wallet_transactions`
- Snapshot reflected in `/users.wallet`

### Reward points
- Uses `/reward_transactions`

---

## 1️⃣4️⃣ Image Storage Strategy

- All proof & cover images → **Firebase Storage**
- Firestore stores only URLs
- Folder structure:
```
/jobs/{jobId}/cover.jpg
/job_proofs/{jobId}/{uid}/img1.jpg
```

---

## 1️⃣5️⃣ Admin & Author Permissions

| Action | Admin | Author | User |
|------|------|-------|------|
| Create Job | ❌ | ✅ | ❌ |
| Approve Job | ✅ | ❌ | ❌ |
| Review Proof | ✅ | ✅ | ❌ |
| Pause Job | ✅ | ❌ | ❌ |

---

## 1️⃣6️⃣ Audit Logging (Mandatory)

Every action writes to `/audit_logs`

Examples:
- job.create
- job.approve
- job.reject
- job_submission.approve

---

## 1️⃣7️⃣ Cost Optimization Summary

- No arrays inside job doc
- Counters instead of aggregation
- Pagination everywhere
- Storage for images
- No real-time listeners for admin

---

## 1️⃣8️⃣ Final Notes

This system is:
- ✔ Secure
- ✔ Scalable
- ✔ Play Store compliant
- ✔ Future-proof

**Never move wallet logic to client.**

---

> End of Document

