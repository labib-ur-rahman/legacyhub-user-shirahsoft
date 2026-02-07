# Configuration Change Impact Guide

> **Purpose**: Explains exactly what happens when each configuration value is changed in the `configurations/app_settings` Firestore document. Use this as a reference before modifying any setting in production.

---

## Table of Contents

1. [How Dynamic Configuration Works](#how-dynamic-configuration-works)
2. [Network Configuration](#network-configuration)
3. [Invite Code Configuration](#invite-code-configuration)
4. [Reward Points Configuration](#reward-points-configuration)
5. [Ads Configuration](#ads-configuration)
6. [Streak Configuration](#streak-configuration)
7. [Subscription Configuration](#subscription-configuration)
8. [Verification Configuration](#verification-configuration)
9. [Wallet Configuration](#wallet-configuration)
10. [How to Update Configuration](#how-to-update-configuration)
11. [Important Warnings](#important-warnings)

---

## How Dynamic Configuration Works

### Architecture

```
Firestore: configurations/app_settings
         ↓
  Cloud Function receives request
         ↓
  getAppConfig() called → checks in-memory cache (30s TTL)
         ↓
  Cache MISS → reads from Firestore → caches result
  Cache HIT  → returns cached config
         ↓
  Business logic uses LIVE config values
```

### Propagation Timeline

| Action | Effect |
|--------|--------|
| Admin updates config via `updateAppConfig()` | Firestore updated instantly |
| Cache cleared automatically | Next function call reads fresh data |
| **Maximum staleness** | **30 seconds** (cache TTL) |

### Key Guarantee

> **When you change a config value, the NEXT Cloud Function invocation (after cache expires) will use the NEW value.** There is no deployment required.

---

## Network Configuration

```json
"network": {
  "maxDepth": 15,
  "verificationDepth": 5
}
```

### `maxDepth` (Default: 15)

**What it controls:**
- Number of upline levels tracked per user (u1 through u15)
- Number of levels for network stats (level1 through level15)
- Loop boundaries in all network-related operations

**Impact of changing from 15 → 20:**

| What changes | Action required |
|---|---|
| New users get u1–u20 upline fields | ✅ Automatic |
| New users get level1–level20 network stats | ✅ Automatic |
| Existing users still have u1–u15 | ⚠️ Existing data NOT retroactively expanded |
| Subscription/verification must have matching level distribution entries | ⚠️ MUST add levels 16–20 to `subscription.levelDistribution` and `verification.levelDistribution` |
| `user_uplines` documents for existing users remain at u1–u15 | ⚠️ Migration script needed for existing users |

**Impact of changing from 15 → 10:**

| What changes | Action required |
|---|---|
| New users only get u1–u10 | ✅ Automatic |
| Existing users with u11–u15 data still exists | ⚠️ Orphan data (harmless but wastes space) |
| `subscription.levelDistribution` entries above level 10 are ignored | ✅ No harm, but wasted config |

**⚠️ WARNING**: Changing `maxDepth` does NOT retroactively update existing users' upline chains or network stats. Only new users and new operations use the new depth. You will likely need a migration script for existing data.

### `verificationDepth` (Default: 5)

**What it controls:**
- Currently informational; the actual depth is controlled by the length of `verification.levelDistribution`.

---

## Invite Code Configuration

```json
"inviteCode": {
  "prefix": "S",
  "suffix": "L",
  "randomLength": 6,
  "charset": "ABCDEFGHJKMNPQRSTUVWXYZ23456789",
  "totalLength": 8
}
```

### `prefix` / `suffix` (Default: "S" / "L")

**What it controls:**
- Every new invite code starts with `prefix` and ends with `suffix`
- Format validation checks these on incoming invite codes

**Impact of changing "S"/"L" → "X"/"Z":**

| What changes | Effect |
|---|---|
| New invite codes generated as X______Z | ✅ Automatic |
| Existing invite codes (S______L) still valid in database | ✅ Still works (lookup by document ID) |
| **Validation of old codes fails** | ⚠️ `isValidInviteCodeFormat()` checks current prefix/suffix — old-format codes will fail format validation |

**⚠️ WARNING**: If `validateCreateUserRequest` or `validateInviteCode` is called with an old-format code, it will be rejected. Existing codes in `invite_codes` collection still exist but fail format checks. **Only change prefix/suffix if no old codes are in circulation.**

### `randomLength` (Default: 6)

**Impact of changing 6 → 8:**
- New codes are 2 characters longer
- `totalLength` MUST also be updated to `prefix.length + 8 + suffix.length`
- Old codes with 6-char random part "../configurations"fail `totalLength` check

### `charset` (Default: "ABCDEFGHJKMNPQRSTUVWXYZ23456789")

**Impact:**
- Adding characters → larger keyspace, less collision risk
- Removing characters → smaller keyspace, more collision risk
- Existing codes with removed characters fail format validation

### `totalLength` (Default: 8)

**Must always equal**: `prefix.length + randomLength + suffix.length`

---

## Reward Points Configuration

```json
"rewardPoints": {
  "conversionRate": 100,
  "minConversion": 1000,
  "maxDailyConversions": 2,
  "maxWeeklyConversions": 7,
  "conversionFeePercent": 5
}
```

### `conversionRate` (Default: 100)

**What it controls:** How many points equal 1 BDT.

**Impact of changing 100 → 50:**
- Each point is now worth 2× more BDT
- User with 1000 points can convert to ৳20 instead of ৳10
- **Instant effect on next conversion**
- Existing unconverted points become more valuable immediately

### `minConversion` (Default: 1000)

**Impact of changing 1000 → 500:**
- Users can convert smaller amounts
- Instant effect on next conversion attempt

### `maxDailyConversions` (Default: 2)

**Impact of changing 2 → 5:**
- Users can convert up to 5 times per day
- Instant effect, no migration needed

### `conversionFeePercent` (Default: 5)

**What it controls:** System fee deducted from conversion.

**Impact of changing 5 → 10:**
- Fee doubles from 5% to 10%
- User converting 1000 points: was ৳9.50 net → now ৳9.00 net
- **Instant effect on next conversion**

---

## Ads Configuration

```json
"ads": {
  "maxDailyAds": 20,
  "pointsPerAd": 30,
  "baseDailyPoints": 600
}
```

### `maxDailyAds` (Default: 20)

**Impact of changing 20 → 30:**
- Users can watch 30 ads per day
- Users who already watched 20 today can watch 10 more
- `baseDailyPoints` should be updated to `30 × pointsPerAd` for consistency

### `pointsPerAd` (Default: 30)

**Impact of changing 30 → 50:**
- Each ad view earns 50 base points (before streak multiplier)
- **Instant effect on next ad view**
- Previous ad views are unaffected (already credited)

### `baseDailyPoints` (Default: 600)

**What it controls:** Used in streak info calculation (`dailyMaxPoints = baseDailyPoints × multiplier`).

**Keep in sync:** Should always equal `maxDailyAds × pointsPerAd`.

---

## Streak Configuration

```json
"streak": {
  "multipliers": {
    "1": 1.0, "2": 1.0, "3": 1.1, ... "30": 3.0
  },
  "maxMultiplier": 3.0
}
```

### `multipliers` (Default: day 1 = 1.0x ... day 30 = 3.0x)

**Impact of changing day 7 from 1.5 → 2.0:**
- User on day 7 streak earns 2.0× points per ad instead of 1.5×
- **Instant effect on next ad view**
- Previous rewards are not retroactively changed

**Impact of adding day 31–60 entries:**
- Users with 31+ day streaks get new multipliers instead of `maxMultiplier`
- The `getStreakMultiplier` function uses `maxMultiplier` for any day > 30

### `maxMultiplier` (Default: 3.0)

**Impact of changing 3.0 → 5.0:**
- Users with streaks > 30 days earn 5.0× instead of 3.0×
- **Instant effect**

---

## Subscription Configuration

```json
"subscription": {
  "priceBDT": 400,
  "rewardDistributedBDT": 240,
  "totalRewardPoints": 24000,
  "levelDistribution": [
    { "level": 1, "percent": 25, "points": 6000 },
    { "level": 2, "percent": 15, "points": 3600 },
    ...
    { "level": 15, "percent": 1.5, "points": 360 }
  ]
}
```

### `priceBDT` (Default: 400)

**What it controls:** Subscription price (informational — actual payment is handled externally).

### `levelDistribution` — THIS IS THE COMMISSION TABLE

**Impact of changing level 3 from 10% / 2400 points → 15% / 3600 points:**

| What happens | Detail |
|---|---|
| Next subscription event distributes 3600 points to level 3 upline | ✅ Instant |
| Previous subscription rewards remain unchanged | ✅ No retroactive change |
| **The level 3 upline immediately earns more** | ✅ This is what you wanted |

**Example scenario (your question):**
> "Currently level 3 commission = 40%. I change to 45%. Next operation should use 45%."

**Answer**: YES. The `distributeSubscriptionRewards()` function reads `config.subscription.levelDistribution` at runtime via `getAppConfig()`. The NEXT subscription event after config update will use the new percentages.

**Impact of adding level 16–20 entries:**
- Requires `network.maxDepth` to also be ≥ 20
- Existing users' upline chains only go to u15 — level 16+ uplines will be `null`
- Only new users (created after maxDepth change) will have u16+ filled

**⚠️ IMPORTANT**: `totalRewardPoints` and `rewardDistributedBDT` are informational. The actual points distributed are the SUM of `points` in `levelDistribution`. Keep them in sync manually.

### Consistency Rule

```
totalRewardPoints = SUM of all levelDistribution[].points
rewardDistributedBDT = totalRewardPoints / rewardPoints.conversionRate
percent values should sum to ≤ 100
```

---

## Verification Configuration

```json
"verification": {
  "priceBDT": 250,
  "rewardDistributedBDT": 125,
  "totalRewardPoints": 12500,
  "levelDistribution": [
    { "level": 1, "percent": 40, "points": 5000 },
    ...
    { "level": 5, "percent": 10, "points": 1250 }
  ]
}
```

Same rules as subscription. Changes take effect on the next verification event.

---

## Wallet Configuration

```json
"wallet": {
  "minWithdrawalBDT": 100,
  "withdrawalFeePer1000": 20
}
```

### `minWithdrawalBDT` (Default: 100)

**Impact of changing 100 → 200:**
- Users must withdraw at least ৳200
- **Instant effect on next withdrawal request**
- Pending withdrawals under ৳200 are NOT affected (already submitted)

### `withdrawalFeePer1000` (Default: 20)

**Impact of changing 20 → 30:**
- Fee increases from ৳20/1000 to ৳30/1000
- Withdrawal of ৳5000: was ৳100 fee → now ৳150 fee
- **Instant effect on next withdrawal request**
- Pending withdrawals already have fee calculated — NOT retroactively changed

---

## How to Update Configuration

### Option 1: Via Cloud Function (Recommended)

Call `updateAppConfig` as a superAdmin:

```javascript
// From Flutter admin panel
final result = await FirebaseFunctions.instance
    .httpsCallable('updateAppConfig')
    .call({
  'updates': {
    'wallet': {'minWithdrawalBDT': 200},
    'subscription': {
      'levelDistribution': [
        {'level': 1, 'percent': 30, 'points': 7200},
        {'level': 2, 'percent': 15, 'points': 3600},
        // ... all 15 levels
      ]
    }
  }
});
```

### Option 2: Direct Firestore Edit (Emergency)

Edit the document directly in Firebase Console:
- Collection: `configurations`
- Document: `app_settings`
- Edit the field and save

> **Note**: Direct edits won't clear the in-memory cache. Wait 30 seconds for cache to expire, or deploy a cache-clearing function.

### Option 3: Seed Defaults (First Time)

Call `seedConfigurations` as superAdmin to initialize with default values:

```javascript
await FirebaseFunctions.instance
    .httpsCallable('seedConfigurations')
    .call();
```

---

## Important Warnings

### 1. Consistency Between Sections

When changing `network.maxDepth`, you MUST also update:
- `subscription.levelDistribution` (add/remove entries)
- `verification.levelDistribution` (add/remove entries)

### 2. No Retroactive Changes

Config changes affect **future operations only**. They do NOT:
- Recalculate past commission distributions
- Adjust existing wallet balances
- Re-validate existing invite codes
- Update existing network stats structures

### 3. Cache Behavior

- Within a single Cloud Function invocation, config is consistent
- After `updateAppConfig()`, cache is cleared immediately
- Other running Cloud Function instances may use old config for up to 30 seconds
- If you need true zero-delay propagation, reduce `CACHE_TTL_MS` in `dynamic-config.ts` (trade-off: more Firestore reads)

### 4. Arrays vs Objects

When updating `levelDistribution` arrays, you must send the **complete array**. Partial array updates are not supported (Firestore replaces the entire array).

When updating scalar fields (like `minWithdrawalBDT`), you can send just that field.

### 5. Testing Changes

Always test config changes in staging before production:
1. Call `getAppConfigAdmin()` to see current config
2. Call `updateAppConfig()` with test values
3. Trigger the affected operation (e.g., a test ad view, withdrawal)
4. Verify the operation used new config values
5. Revert if needed by calling `updateAppConfig()` again

---

## Quick Reference: What Function Uses What Config

| Cloud Function | Config Section(s) Used |
|---|---|
| `createUser` | `inviteCode`, `network` |
| `completeGoogleSignIn` | `network` |
| `verifyUserProfile` | `network`, `verification` |
| `subscribeUser` | `network`, `subscription` |
| `recordAdView` | `ads`, `streak` |
| `convertRewardPoints` | `rewardPoints` |
| `getStreakInfo` | `ads`, `streak` |
| `requestWithdrawal` | `wallet` |
| `generateUniqueInviteCode` | `inviteCode` |
| All network operations | `network` |
| `seedConfigurations` | writes `DEFAULT_CONFIG` |
| `updateAppConfig` | writes partial updates |
| `getAppConfigAdmin` | reads full config |
