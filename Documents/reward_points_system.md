# LegacyHub – Reward Points System (Master Reference)

This document explains **everything related to Reward Points** in the LegacyHub app. It is designed as a **long-term reference note** for founders, developers, or stakeholders and is fully aligned with **Google Play & AdMob policies**.

---

## 1. What are Reward Points?

**Reward Points** are a non-cash, internal value system used to:

* Motivate consistent activity
* Hide multi-level incentives (MLM-style) safely
* Gamify ads, referrals, and contributions
* Control real cash outflow

> Reward Points are **NOT money** and **NOT directly withdrawable**.

---

## 2. Wallet Architecture (Summary)

LegacyHub uses a **3-layer wallet system**:

1. **Reward Points** – motivation & contribution layer (non-cash)
2. **Wallet Balance** – real money (withdrawable)
3. **Voucher System** – utility bridge (reward → service)

Income from real activities is auto-added to Wallet Balance. Only Reward Points require manual conversion.

---

## 3. Reward Points Earning Sources

### 3.1 Ads View (Rewarded Ads – Gamified)

**Base setup:**

* Max ads/day: 20
* Reward per ad: 30 Reward Points
* Base daily reward: 600 Reward Points

### 30-Day Streak Multiplier Table

| Day | Multiplier | Daily Reward Points |
| --- | ---------- | ------------------- |
| 1   | 1.0x       | 600                 |
| 2   | 1.0x       | 600                 |
| 3   | 1.1x       | 660                 |
| 4   | 1.1x       | 660                 |
| 5   | 1.2x       | 720                 |
| 6   | 1.2x       | 720                 |
| 7   | 1.5x       | 900                 |
| 8   | 1.5x       | 900                 |
| 9   | 1.5x       | 900                 |
| 10  | 1.6x       | 960                 |
| 11  | 1.6x       | 960                 |
| 12  | 1.7x       | 1020                |
| 13  | 1.7x       | 1020                |
| 14  | 2.0x       | 1200                |
| 15  | 2.0x       | 1200                |
| 16  | 2.1x       | 1260                |
| 17  | 2.1x       | 1260                |
| 18  | 2.2x       | 1320                |
| 19  | 2.2x       | 1320                |
| 20  | 2.5x       | 1500                |
| 21  | 2.5x       | 1500                |
| 22  | 2.6x       | 1560                |
| 23  | 2.6x       | 1560                |
| 24  | 2.7x       | 1620                |
| 25  | 2.7x       | 1620                |
| 26  | 2.8x       | 1680                |
| 27  | 2.8x       | 1680                |
| 28  | 3.0x       | 1800                |
| 29  | 3.0x       | 1800                |
| 30  | 3.0x (MAX) | 1800                |

**Day 31 → Infinity:** stays at 3.0x (1800/day)

If a day is missed → streak resets to Day 1.

---

### 3.2 Subscription-Based Rewards (Hidden MLM)

Subscription price: **400৳**

Total Reward-distributed value: **240৳** (converted to Reward Points)

**Conversion rule:**

> 1৳ = 100 Reward Points

So,

> 240৳ = **24,000 Reward Points**

#### Subscriber Upline Distribution (Level 1–15)

| Level | % Share | Reward Points |
| ----- | ------- | ------------- |
| 1     | 25%     | 6,000         |
| 2     | 15%     | 3,600         |
| 3     | 10%     | 2,400         |
| 4     | 8%      | 1,920         |
| 5     | 7%      | 1,680         |
| 6     | 6%      | 1,440         |
| 7     | 5%      | 1,200         |
| 8     | 4%      | 960           |
| 9     | 4%      | 960           |
| 10    | 3%      | 720           |
| 11    | 3%      | 720           |
| 12    | 2%      | 480           |
| 13    | 2%      | 480           |
| 14    | 1.5%    | 360           |
| 15    | 1.5%    | 360           |

> UI never shows levels or percentages.

---

### 3.3 Profile Verification Rewards (250৳)

Reward-distributed value: **125৳**

Total Reward Points: **12,500**

#### Verified Upline Distribution (Level 1–5 only)

| Level | % Share | Reward Points |
| ----- | ------- | ------------- |
| 1     | 40%     | 5,000         |
| 2     | 25%     | 3,125         |
| 3     | 15%     | 1,875         |
| 4     | 10%     | 1,250         |
| 5     | 10%     | 1,250         |

---

### 3.4 Other Reward Sources

| Source                 | Reward Logic                 |
| ---------------------- | ---------------------------- |
| Course referral        | Fixed Reward Points per sale |
| Micro tasks            | Small Reward Points per task |
| Community contribution | Admin-defined Reward Points  |

---

## 4. Reward Points → Wallet Conversion Rules

### Conversion Rate

> **100 Reward Points = 1৳**

### Rules

* Minimum conversion: **1,000 Reward Points (10৳)**
* Conversion frequency: 2 time/day OR 7 times/week
* Only **Verified or Subscriber** users can convert
* Optional system adjustment fee (e.g., 5%)

Reward Points are never auto-converted.

---

## 5. Voucher System (Reward Usage)

Reward Points can be used to redeem vouchers:

| Voucher Type     | Conversion      |
| ---------------- | --------------- |
| Recharge voucher | 100 Reward = 1৳ |
| Offer voucher    | Admin-defined   |
| Course discount  | Admin-defined   |

Reward Points cannot be used directly for recharge—only via vouchers.

---

## 6. What Users See (UI Philosophy)

Users see:

* Reward Points earned
* Streak progress
* Conversion eligibility

Users never see:

* Commission
* Level income
* MLM structure

All earnings appear as:

> "Reward Points earned for your contribution"

---

## 7. Policy Safety Summary

* Reward Points ≠ money
* No guaranteed income claims
* Ads are optional
* Conversion is controlled
* Withdraw only from Wallet Balance

This system is designed to be **scalable, motivational, and Google Play compliant**.

---

## 8. Final Note

This document should be treated as the **single source of truth** for all Reward Points-related decisions in LegacyHub. Any future feature must align with this structure.