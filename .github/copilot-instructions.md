# 🚀 LegacyHub AI Agent Instructions

> **App Name:** LegacyHub  
> **Stack:** Flutter + GetX + Firebase (Firestore + Realtime Database + Cloud Functions)  
> **Pattern:** MVC + Repository  
> **Design:** Figma MCP → Flutter

---

## 🎯 IDENTITY

You are an AI coding agent for **LegacyHub** — a Business & Community Super App for Bangladesh.

**LegacyHub Features:**
- Digital services (recharge, telecom offers)
- Product reselling (no inventory)
- Micro jobs platform
- Reward points system
- Community posts & marketplace
- Wallet system (BDT + Reward Points)

**⚠️ CRITICAL:** LegacyHub is NOT an MLM app. Internal multi-level logic is backend-only.

---

## 🧠 THINK BEFORE CODING

**Order of thinking:**
1. **Design** → Figma MCP mindset
2. **Data** → Firebase collection hierarchy
3. **Architecture** → MVC + Repository separation
4. **UX** → Progressive loading, offline states
5. **i18n** → English + Bangla support

---

## 📁 ARCHITECTURE

```
View (UI only)
    ↓
Controller (state + logic)
    ↓
Repository (Firebase calls)
    ↓
Model (data mapping)
```

**Rules:**
- Controllers MUST have `static get instance => Get.find();`
- Register controllers in `InitialBinding`
- Access via `ControllerName.instance`
- NO business logic in UI

---

## 🎨 FIGMA → FLUTTER RULES

| Rule | Description |
|------|-------------|
| ❌ | Never put all UI in one screen file |
| ❌ | Never use private widgets in screens |
| ✅ | Extract UI blocks to `views/widgets/` |
| ✅ | Extract widgets > 50 lines |
| ✅ | Screens = layout + state binding |
| ✅ | Widgets = pure UI blocks |

---

## 🔥 FIREBASE DATA LOADING

**Progressive Loading Pattern:**
```
1. Load parent collection
2. Render parent list immediately
3. Load child data per-item (by ID)
4. Show shimmer until child arrives
5. Never block screen for child data
```

**Rules:**
- Parent controls screen loading
- Child loads independently in parallel
- Use shimmer for partial data
- Use `CachedNetworkImage` for images

---

## ⏳ LOADING STATES

| Type | Handler |
|------|---------|
| Global screen | `EasyLoading.show()` |
| List loading | Shimmer widgets |
| Item loading | Per-item placeholder |
| Image loading | `CachedNetworkImage` |

**Never:**
- Use `FutureBuilder`/`StreamBuilder` in UI
- Call Firebase from UI
- Call async in `build()`

---

## 🌍 LOCALIZATION

| Setting | Value |
|---------|-------|
| Default | English |
| Secondary | Bangla (bn) |

**Rules:**
- ❌ Never hardcode text
- ✅ Use `AppStrings.xxx` always
- ✅ Design for long Bangla text
- ✅ Use flexible button widths

---

## 🎨 THEMING

| Setting | Value |
|---------|-------|
| Default | Light Mode |
| Dark | User-controlled |
| System | Never auto-switch |

**Rules:**
- ❌ No hardcoded colors
- ✅ Use `AppColors` only
- ✅ Design for both themes

---

## 📦 IMPORTS & PATTERNS

```dart
// ✅ Package imports
import 'package:legacyhub/...';

// ✅ Controller access
final controller = MyController.instance;

// ✅ Icons
Icon(Iconsax.home)

// ✅ Text
Text(AppStrings.welcome)

// ✅ Sizing
Container(width: 200.w, height: 100.h)

// ✅ Colors
color: AppColors.primary

// ❌ Never
import '../../../...';
Get.find<Controller>();
Icon(Icons.home);
Text('Welcome');
Container(width: 200);
Color(0xFF4B68FF);
```

---

## 📋 NEW FEATURE CHECKLIST

When creating a feature, ALWAYS create:

- [ ] Feature folder in `lib/features/`
- [ ] Controller with `static instance`
- [ ] Repository (Firebase logic)
- [ ] Model (fromJson/toJson)
- [ ] Screen (StatelessWidget)
- [ ] Widgets folder
- [ ] Loading & empty states
- [ ] AppStrings entries (EN + BN)
- [ ] Register in `InitialBinding`
- [ ] Add routes

---

## 💰 LEGACYHUB-SPECIFIC RULES

### Wallet System
- Two wallets: **Wallet Balance (BDT)** + **Reward Points**
- Wallet Balance = withdrawable
- Reward Points = not directly withdrawable
- Conversion: 100 Reward Points = 1 BDT

### User Document Structure
```
users/{uid}
├── identity (name, phone, avatar)
├── codes (inviteCode, referralCode)
├── network (parentUid)
├── status (accountState, verified, subscribed)
├── wallet (balance, rewardPoints)
├── permissions
├── flags (isAdmin, isModerator, isTestUser)
├── limits
└── meta
```

### Invite Code Format
- Format: `S + 6_CHARS + L` (e.g., `SA7K9Q2L`)
- Charset: `ABCDEFGHJKMNPQRSTUVWXYZ23456789`
- No: O, I, l, 0, 1

---

## ❌ ANTI-PATTERNS

If your code:
- Lives in one file → ❌ Wrong
- Blocks UI for child data → ❌ Wrong
- Hardcodes text/color → ❌ Wrong
- Uses `Get.find()` directly → ❌ Wrong
- Uses Material Icons → ❌ Wrong
- Skips loading states → ❌ Wrong

---

## ✅ GOLDEN RULES

1. **Scalable** — Extract, modularize, reuse
2. **Progressive** — Never block UI
3. **Theme-aware** — Light + Dark
4. **Localized** — EN + BN
5. **Firebase-safe** — Repository layer only

---

> 📚 For detailed instructions, see `copilot-instructions-details.md`
