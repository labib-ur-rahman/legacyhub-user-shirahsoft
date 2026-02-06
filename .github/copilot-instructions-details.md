# 🤖 LegacyHub AI Agent - Complete Development Guide

> **App:** LegacyHub - Business & Community Super App  
> **Stack:** Flutter + GetX + Firebase (Firestore + Realtime Database + Cloud Functions)  
> **Pattern:** MVC + Repository  
> **Languages:** English (default) + Bangla (bn)

---

## 📑 Table of Contents

1. [Critical Rules (Must Follow)](#-critical-rules-must-follow)
2. [Project Architecture](#-project-architecture)
3. [Firebase Data Structure](#-firebase-data-structure)
4. [Core Components Reference](#-core-components-reference)
5. [LegacyHub Business Logic](#-legacyhub-business-logic)
6. [Development Standards](#-development-standards)
7. [Common Patterns & Anti-Patterns](#-common-patterns--anti-patterns)
8. [Quick Reference Guide](#-quick-reference-guide)

---

## 🚨 Critical Rules (Must Follow)

These rules are **NON-NEGOTIABLE** and must be applied in ALL generated code.

### 1. Package Imports (Never Relative)
```dart
// ✅ ALWAYS use package imports
import 'package:legacyhub/core/utils/constants/colors.dart';
import 'package:legacyhub/features/wallet/controllers/wallet_controller.dart';

// ❌ NEVER use relative imports
import '../../constants/colors.dart';
import '../controllers/wallet_controller.dart';
```

### 2. Controller Access Pattern
```dart
// ✅ ALWAYS use instance pattern
final controller = WalletController.instance;
final authController = AuthController.instance;

// ❌ NEVER use Get.find directly
final controller = Get.find<WalletController>();
final controller = Get.put(WalletController());

// ✅ MANDATORY: Every controller MUST have this
class WalletController extends GetxController {
  static WalletController get instance => Get.find();
  
  // Controller code...
}
```

### 3. Multi-Language Support (Critical)
```dart
// ✅ ALWAYS use AppStrings
Text(AppStrings.walletBalance)
EasyLoading.show(status: AppStrings.loading);
AppSnackBar.successSnackBar(title: AppStrings.success, message: AppStrings.rechargeComplete);

// ❌ NEVER hardcode text
Text('Wallet Balance')
EasyLoading.show(status: 'Loading...');
Text('আপনার ব্যালেন্স')
```

### 4. Icons (Iconsax Only)
```dart
// ✅ ALWAYS use Iconsax
import 'package:iconsax/iconsax.dart';
Icon(Iconsax.wallet)
Icon(Iconsax.home)
Icon(Iconsax.user)

// ✅ For custom SVG icons
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';
SvgIconHelper.buildIcon(
  assetPath: AppSvgPath.bkash,
  width: 24.w,
  height: 24.h,
)

// ❌ NEVER use Material Icons
Icon(Icons.wallet)
Icon(Icons.home)
```

### 5. Loading States
```dart
// ✅ Global blocking loading ONLY
EasyLoading.show(status: AppStrings.loading);
EasyLoading.showProgress(0.5, status: AppStrings.uploading);
EasyLoading.dismiss();

// ❌ NEVER use EasyLoading for user feedback
EasyLoading.showSuccess('Done!');  // Use AppSnackBar instead
EasyLoading.showError('Failed');   // Use AppSnackBar instead
```

### 6. User Feedback (AppSnackBar)
```dart
// ✅ ALWAYS use AppSnackBar for messages
import 'package:legacyhub/core/common/widgets/popups/custom_snackbar.dart';

AppSnackBar.successSnackBar(title: AppStrings.success, message: AppStrings.rechargeComplete);
AppSnackBar.errorSnackBar(title: AppStrings.error, message: AppStrings.insufficientBalance);
AppSnackBar.warningSnackBar(title: AppStrings.warning, message: AppStrings.lowBalance);
AppSnackBar.showInfoSnackBar(title: AppStrings.info, message: AppStrings.rewardPointsEarned);
AppSnackBar.customToast(message: AppStrings.copied);

// ❌ NEVER use Get.snackbar or Flutter SnackBar
Get.snackbar('Error', 'Something went wrong');
```

### 7. Data Formatting (AppFormatter)
```dart
// ✅ ALWAYS use AppFormatter
import 'package:legacyhub/core/utils/formatters/formatters.dart';

AppFormatter.formatCurrency(1234.56, symbol: '৳');           // ৳1,234.56
AppFormatter.formatRewardPoints(50000);                       // 50,000 pts
AppFormatter.formatPhoneNumber('01712345678');               // 017-1234-5678
AppFormatter.formatDate(DateTime.now(), format: 'dd MMM yyyy');
AppFormatter.formatInviteCode('SA7K9Q2L');                   // SA7K-9Q2L

// ❌ NEVER create custom formatters
String formatMoney(double amount) { ... }  // Don't do this
```

### 8. Form Validation (AppValidator)
```dart
// ✅ ALWAYS use AppValidator
import 'package:legacyhub/core/utils/validators/app_validator.dart';

CustomTextField(
  validator: AppValidator.validatePhone,        // Bangladesh phone
  validator: AppValidator.validateEmail,
  validator: AppValidator.validateInviteCode,   // LegacyHub invite code
  validator: AppValidator.validateAmount,       // Wallet amount
)

// ❌ NEVER inline validation logic
validator: (value) => value!.length == 11 ? null : 'Invalid';
```

### 9. Logging (LoggerService)
```dart
// ✅ ALWAYS use LoggerService
import 'package:legacyhub/core/services/logger_service.dart';

LoggerService.info('User logged in: ${user.uid}');
LoggerService.error('Firebase error', exception);
LoggerService.debug('Wallet balance: $balance');
LoggerService.warning('Low balance warning');

// ❌ NEVER use print or debugPrint
print('Debug message');
debugPrint('Something happened');
```

### 10. Color Usage
```dart
// ✅ Use withValues for opacity
AppColors.primary.withValues(alpha: 0.5)
AppColors.success.withValues(alpha: 0.1)

// ❌ NEVER use deprecated withOpacity
AppColors.primary.withOpacity(0.5)
```

### 11. Responsive Sizing
```dart
// ✅ ALWAYS use ScreenUtil extensions
Container(
  width: 200.w,
  height: 100.h,
  padding: EdgeInsets.all(16.r),
  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
)

// ❌ NEVER use raw numbers (except 0)
Container(width: 200, height: 100)
```

### 12. Font Size (NO .sp)
```dart
// ✅ Use text style helpers (they handle scaling)
Text(
  AppStrings.walletBalance,
  style: getTextStyle(fontSize: 14),
);

Text(
  '৳5,000',
  style: getBoldTextStyle(fontSize: 24, color: AppColors.success),
);

// ❌ NEVER use .sp directly
Text('Balance', style: TextStyle(fontSize: 14.sp));
```

---

## 🏗 Project Architecture

### MVC + Repository Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                         VIEW                                 │
│            (StatelessWidget - UI only)                       │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                      CONTROLLER                              │
│         (GetxController - State + Business Logic)            │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                      REPOSITORY                              │
│               (Firebase / API calls)                         │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                        MODEL                                 │
│              (Data classes with JSON mapping)                │
└─────────────────────────────────────────────────────────────┘
```

### Complete Directory Structure

```
lib/
├── main.dart                           # App entry point
├── app.dart                            # Root GetMaterialApp widget
│
├── core/                               # Shared utilities & services
│   ├── bindings/
│   │   └── initial_binding.dart        # Register ALL controllers
│   │
│   ├── common/
│   │   ├── styles/
│   │   │   ├── global_text_style.dart
│   │   │   ├── shadows.dart
│   │   │   └── spacing_styles.dart
│   │   │
│   │   └── widgets/
│   │       ├── buttons/
│   │       │   └── custom_button.dart
│   │       ├── cards/
│   │       │   ├── wallet_card.dart
│   │       │   └── reward_card.dart
│   │       ├── images/
│   │       │   └── custom_circular_image.dart
│   │       ├── loaders/
│   │       │   ├── animation_loader.dart
│   │       │   └── circular_loader.dart
│   │       ├── popups/
│   │       │   ├── custom_snackbar.dart
│   │       │   └── bottom_sheets.dart
│   │       ├── shimmers/
│   │       │   ├── shimmer.dart
│   │       │   ├── list_shimmer.dart
│   │       │   └── card_shimmer.dart
│   │       ├── states/
│   │       │   ├── empty_state_widget.dart
│   │       │   ├── error_display_widget.dart
│   │       │   └── no_internet_widget.dart
│   │       └── text_fields/
│   │           └── custom_text_field.dart
│   │
│   ├── config/
│   │   ├── keys.dart
│   │   ├── keys.example.dart
│   │   └── firebase_config.dart
│   │
│   ├── localization/
│   │   ├── app_string_localizations.dart
│   │   ├── language_controller.dart
│   │   ├── languages.dart
│   │   └── languages/
│   │       ├── en_us.dart
│   │       └── bn_bd.dart
│   │
│   ├── services/
│   │   ├── local_storage_service.dart
│   │   ├── logger_service.dart
│   │   ├── firebase_service.dart
│   │   ├── notification_service.dart
│   │   └── connectivity_service.dart
│   │
│   └── utils/
│       ├── constants/
│       │   ├── api_endpoints.dart
│       │   ├── app_constants.dart
│       │   ├── colors.dart
│       │   ├── enums.dart
│       │   ├── firebase_paths.dart
│       │   ├── icon_path.dart
│       │   ├── image_path.dart
│       │   ├── lottie_path.dart
│       │   ├── sizes.dart
│       │   └── svg_path.dart
│       │
│       ├── device/
│       │   └── device_utility.dart
│       │
│       ├── exceptions/
│       │   ├── firebase_auth_exceptions.dart
│       │   ├── firebase_exceptions.dart
│       │   ├── format_exceptions.dart
│       │   └── platform_exceptions.dart
│       │
│       ├── formatters/
│       │   └── formatters.dart
│       │
│       ├── helpers/
│       │   ├── app_helper.dart
│       │   ├── svg_icon_helper.dart
│       │   ├── firebase_helper.dart
│       │   └── invite_code_helper.dart
│       │
│       ├── http/
│       │   └── http_client.dart
│       │
│       ├── local_storage/
│       │   └── storage_utility.dart
│       │
│       ├── manager/
│       │   ├── dialog_manager.dart
│       │   └── network_manager.dart
│       │
│       ├── theme/
│       │   ├── theme.dart
│       │   └── custom_themes/
│       │
│       └── validators/
│           └── app_validator.dart
│
├── data/
│   ├── models/
│   │   ├── user/
│   │   │   ├── user_model.dart
│   │   │   ├── user_identity_model.dart
│   │   │   ├── user_codes_model.dart
│   │   │   ├── user_status_model.dart
│   │   │   ├── user_wallet_model.dart
│   │   │   ├── user_permissions_model.dart
│   │   │   └── user_flags_model.dart
│   │   │
│   │   ├── wallet/
│   │   │   ├── wallet_model.dart
│   │   │   ├── transaction_model.dart
│   │   │   └── withdrawal_model.dart
│   │   │
│   │   ├── reward/
│   │   │   ├── reward_points_model.dart
│   │   │   ├── reward_transaction_model.dart
│   │   │   └── streak_model.dart
│   │   │
│   │   ├── community/
│   │   │   ├── post_model.dart
│   │   │   ├── comment_model.dart
│   │   │   └── marketplace_item_model.dart
│   │   │
│   │   ├── services/
│   │   │   ├── recharge_model.dart
│   │   │   ├── telecom_offer_model.dart
│   │   │   └── micro_job_model.dart
│   │   │
│   │   └── common/
│   │       ├── api_response_model.dart
│   │       └── pagination_model.dart
│   │
│   └── repositories/
│       ├── authentication/
│       │   └── authentication_repository.dart
│       ├── user/
│       │   └── user_repository.dart
│       ├── wallet/
│       │   └── wallet_repository.dart
│       ├── reward/
│       │   └── reward_repository.dart
│       ├── community/
│       │   ├── post_repository.dart
│       │   └── marketplace_repository.dart
│       └── services/
│           ├── recharge_repository.dart
│           ├── telecom_repository.dart
│           └── micro_job_repository.dart
│
├── features/
│   ├── authentication/
│   │   ├── controllers/
│   │   │   ├── auth_controller.dart
│   │   │   ├── login_controller.dart
│   │   │   ├── signup_controller.dart
│   │   │   └── forgot_password_controller.dart
│   │   └── views/
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── signup_screen.dart
│   │       │   ├── phone_verification_screen.dart
│   │       │   └── invite_code_screen.dart
│   │       └── widgets/
│   │
│   ├── splash/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── onboarding/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── main/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── home/
│   │   ├── controllers/
│   │   └── views/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── wallet/
│   │   ├── controllers/
│   │   │   ├── wallet_controller.dart
│   │   │   ├── deposit_controller.dart
│   │   │   └── withdraw_controller.dart
│   │   └── views/
│   │       ├── screens/
│   │       │   ├── wallet_screen.dart
│   │       │   ├── deposit_screen.dart
│   │       │   ├── withdraw_screen.dart
│   │       │   └── transaction_history_screen.dart
│   │       └── widgets/
│   │
│   ├── rewards/
│   │   ├── controllers/
│   │   │   ├── reward_controller.dart
│   │   │   ├── ads_controller.dart
│   │   │   └── streak_controller.dart
│   │   └── views/
│   │       ├── screens/
│   │       │   ├── rewards_screen.dart
│   │       │   ├── watch_ads_screen.dart
│   │       │   ├── convert_points_screen.dart
│   │       │   └── vouchers_screen.dart
│   │       └── widgets/
│   │
│   ├── recharge/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── offers/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── micro_jobs/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── reselling/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── community/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── profile/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── notifications/
│   │   ├── controllers/
│   │   └── views/
│   │
│   └── settings/
│       ├── controllers/
│       └── views/
│
└── routes/
    ├── app_routes.dart
    └── app_pages.dart
```

---

## 🔥 Firebase Data Structure

### Firestore Collections

#### `users/{uid}` - Core User Document
```json
{
  "uid": "uid_abc123",
  
  "identity": {
    "fullName": "Rahim Khan",
    "phone": "01712345678",
    "email": "rahim@email.com",
    "avatarUrl": "https://...",
    "nidVerified": false
  },
  
  "codes": {
    "inviteCode": "SA7K9Q2L",
    "referralCode": "uid_abc123"
  },
  
  "network": {
    "parentUid": "uid_parent",
    "joinedAt": "timestamp"
  },
  
  "status": {
    "accountState": "active",
    "isVerified": false,
    "isSubscribed": false,
    "riskLevel": "normal"
  },
  
  "wallet": {
    "balance": 500.00,
    "rewardPoints": 15000
  },
  
  "permissions": {
    "canWithdraw": true,
    "canPost": false,
    "canRecharge": true,
    "canViewAds": true
  },
  
  "flags": {
    "isAdmin": false,
    "isModerator": false,
    "isTestUser": false
  },
  
  "limits": {
    "dailyWithdrawLimit": 5000,
    "dailyRechargeLimit": 10000,
    "dailyAdsLimit": 20,
    "dailyConversionLimit": 2
  },
  
  "meta": {
    "createdAt": "timestamp",
    "lastActiveAt": "timestamp",
    "lastLoginAt": "timestamp",
    "totalEarnings": 2500.00
  }
}
```

#### `invite_codes/{inviteCode}` - Unique Index
```json
{
  "uid": "uid_abc123",
  "referralCode": "uid_abc123",
  "createdAt": "timestamp"
}
```

#### `wallets/{uid}` - Wallet Details
```json
{
  "uid": "uid_abc123",
  "balance": 500.00,
  "rewardPoints": 15000,
  "totalDeposits": 5000.00,
  "totalWithdrawals": 2000.00,
  "lastUpdated": "timestamp"
}
```

#### `transactions/{transactionId}` - Transaction History
```json
{
  "id": "txn_123",
  "uid": "uid_abc123",
  "type": "deposit|withdraw|recharge|reward|conversion",
  "amount": 100.00,
  "rewardPoints": 0,
  "status": "pending|completed|failed|cancelled",
  "description": "Mobile Recharge - 01712345678",
  "createdAt": "timestamp"
}
```

#### `streaks/{uid}` - User Streak Data
```json
{
  "uid": "uid_abc123",
  "currentStreak": 7,
  "longestStreak": 15,
  "lastActiveDate": "2024-01-15",
  "multiplier": 1.5,
  "totalAdsToday": 20
}
```

### Firebase Paths Constants
```dart
// lib/core/utils/constants/firebase_paths.dart
class FirebasePaths {
  FirebasePaths._();
  
  // Collections
  static const String users = 'users';
  static const String inviteCodes = 'invite_codes';
  static const String wallets = 'wallets';
  static const String transactions = 'transactions';
  static const String rewardLogs = 'reward_logs';
  static const String streaks = 'streaks';
  static const String posts = 'posts';
  static const String marketplace = 'marketplace';
  static const String microJobs = 'micro_jobs';
  static const String notifications = 'notifications';
  
  // Document references
  static String user(String uid) => 'users/$uid';
  static String wallet(String uid) => 'wallets/$uid';
  static String streak(String uid) => 'streaks/$uid';
}
```

---

## 🔧 Core Components Reference

### Reusable Widgets

#### CustomButton
```dart
import 'package:legacyhub/core/common/widgets/buttons/custom_button.dart';

CustomButton(
  text: AppStrings.recharge,
  onPressed: controller.performRecharge,
  type: ButtonType.primary,
  isLoading: controller.isLoading.value,
  icon: Iconsax.mobile,
)
```

#### CustomTextField
```dart
import 'package:legacyhub/core/common/widgets/text_fields/custom_text_field.dart';

CustomTextField(
  labelText: AppStrings.phoneNumber,
  hintText: AppStrings.enterPhoneNumber,
  controller: controller.phoneController,
  keyboardType: TextInputType.phone,
  validator: AppValidator.validatePhone,
  prefixIcon: Iconsax.call,
)
```

### Services

#### Firebase Service
```dart
// lib/core/services/firebase_service.dart
class FirebaseService {
  static FirebaseService get instance => Get.find();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  CollectionReference get usersRef => _firestore.collection(FirebasePaths.users);
  CollectionReference get walletsRef => _firestore.collection(FirebasePaths.wallets);
  
  User? get currentUser => _auth.currentUser;
  String? get currentUid => _auth.currentUser?.uid;
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
```

### Utilities

#### InviteCodeHelper
```dart
// lib/core/utils/helpers/invite_code_helper.dart
class InviteCodeHelper {
  static const String _charset = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  static const String _prefix = 'S';
  static const String _suffix = 'L';
  
  /// Generate unique invite code: S + 6_CHARS + L
  static String generate() {
    final random = Random.secure();
    final code = List.generate(6, (_) => _charset[random.nextInt(_charset.length)]).join();
    return '$_prefix$code$_suffix';
  }
  
  /// Validate invite code format
  static bool isValid(String code) {
    if (code.length != 8) return false;
    if (!code.startsWith(_prefix) || !code.endsWith(_suffix)) return false;
    final middle = code.substring(1, 7);
    return middle.split('').every((c) => _charset.contains(c));
  }
  
  /// Format for display: SA7K9Q2L → SA7K-9Q2L
  static String format(String code) {
    if (code.length != 8) return code;
    return '${code.substring(0, 4)}-${code.substring(4)}';
  }
}
```

---

## 💰 LegacyHub Business Logic

### Wallet System

#### Two Wallet Types
| Type | Purpose | Withdrawable |
|------|---------|--------------|
| **Wallet Balance (BDT)** | Real money | ✅ Yes |
| **Reward Points** | Engagement | ❌ No (convert first) |

#### Conversion Rule
```
100 Reward Points = 1 BDT
```

### Reward Points System

#### Ad Viewing Rewards
| Day | Multiplier | Points (20 ads × 30pts) |
|-----|------------|-------------------------|
| 1 | 1.0x | 600 |
| 7 | 1.5x | 900 |
| 14 | 2.0x | 1,200 |
| 21 | 2.5x | 1,500 |
| 30+ | 3.0x | 1,800 |

### User States

#### Account States
| State | Description |
|-------|-------------|
| `active` | Normal user |
| `suspended` | Temporary restriction |
| `banned` | Permanent ban |
| `deleted` | Account removed |

---

## 📐 Development Standards

### Controller Template
```dart
import 'package:get/get.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/common/widgets/popups/custom_snackbar.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FeatureController extends GetxController {
  // ✅ MANDATORY: Static instance getter
  static FeatureController get instance => Get.find();
  
  // Repository
  final FeatureRepository _repository = FeatureRepository();
  
  // Observable state
  final RxList<Item> items = <Item>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final data = await _repository.fetchData();
      items.assignAll(data);
      
    } catch (e) {
      hasError.value = true;
      LoggerService.error('Load failed', e);
      AppSnackBar.errorSnackBar(
        title: AppStrings.error,
        message: AppStrings.loadFailed,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Repository Template (Firebase)
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legacyhub/core/utils/constants/firebase_paths.dart';

class FeatureRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  Future<Model?> getById(String id) async {
    final doc = await _db.collection(FirebasePaths.collection).doc(id).get();
    if (!doc.exists) return null;
    return Model.fromFirestore(doc);
  }
  
  Future<List<Model>> getAll({int limit = 20}) async {
    final snapshot = await _db
        .collection(FirebasePaths.collection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Model.fromFirestore(doc)).toList();
  }
  
  Future<String> create(Model model) async {
    final docRef = await _db.collection(FirebasePaths.collection).add(
      model.toFirestore(),
    );
    return docRef.id;
  }
}
```

### Model Template (Firestore)
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  final String id;
  final String name;
  final DateTime createdAt;
  
  const Model({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  
  factory Model.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Model(
      id: doc.id,
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
```

### Screen Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/common/widgets/shimmers/shimmer.dart';
import 'package:legacyhub/core/common/widgets/states/empty_state_widget.dart';
import 'package:legacyhub/core/common/widgets/states/error_display_widget.dart';
import 'package:iconsax/iconsax.dart';

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FeatureController.instance;
    
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.featureTitle)),
      body: Obx(() => _buildBody(controller)),
    );
  }
  
  Widget _buildBody(FeatureController controller) {
    if (controller.isLoading.value && controller.items.isEmpty) {
      return _buildShimmer();
    }
    
    if (controller.hasError.value && controller.items.isEmpty) {
      return ErrorDisplayWidget(
        icon: Iconsax.warning_2,
        title: AppStrings.error,
        message: AppStrings.loadFailed,
        actionText: AppStrings.retry,
        onActionPressed: controller.loadData,
      );
    }
    
    if (controller.items.isEmpty) {
      return EmptyStateWidget(
        icon: Iconsax.box,
        title: AppStrings.noData,
        subtitle: AppStrings.noDataDescription,
      );
    }
    
    return RefreshIndicator(
      onRefresh: controller.loadData,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return FeatureItemWidget(item: controller.items[index]);
        },
      ),
    );
  }
  
  Widget _buildShimmer() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: AppShimmerEffect(
          width: double.infinity,
          height: 100.h,
          radius: 12,
        ),
      ),
    );
  }
}
```

---

## 🎯 Common Patterns & Anti-Patterns

### ✅ CORRECT Patterns

#### Progressive Firebase Loading
```dart
class PostController extends GetxController {
  static PostController get instance => Get.find();
  
  final RxList<Post> posts = <Post>[].obs;
  final RxMap<String, User> userCache = <String, User>{}.obs;
  
  Future<void> loadPosts() async {
    // 1. Load posts first (parent)
    final postList = await _repository.getPosts();
    posts.assignAll(postList);
    
    // 2. Load user data in parallel (children)
    final userIds = postList.map((p) => p.userId).toSet();
    for (final uid in userIds) {
      _loadUserData(uid);  // Don't await
    }
  }
  
  Future<void> _loadUserData(String uid) async {
    if (userCache.containsKey(uid)) return;
    final user = await _userRepository.getUser(uid);
    if (user != null) {
      userCache[uid] = user;
    }
  }
}
```

### ❌ ANTI-PATTERNS

#### 1. Blocking for Child Data
```dart
// ❌ WRONG
Future<void> loadPosts() async {
  final posts = await _repository.getPosts();
  for (final post in posts) {
    final user = await _userRepository.getUser(post.userId);  // BLOCKING!
    post.user = user;
  }
  this.posts.assignAll(posts);
}
```

#### 2. Firebase in UI
```dart
// ❌ WRONG
Widget build(BuildContext context) {
  return FutureBuilder(
    future: FirebaseFirestore.instance.collection('users').get(),
    builder: (context, snapshot) { ... },
  );
}
```

---

## 🚀 Quick Reference Guide

### Creating a New Feature

1. **Create folder**: `lib/features/[feature_name]/`
2. **Create controller**: With `static instance` getter
3. **Register in binding**: `lib/core/bindings/initial_binding.dart`
4. **Create repository**: For Firebase operations
5. **Create models**: With `fromFirestore()` and `toFirestore()`
6. **Create screens**: Use existing widgets
7. **Create widgets**: Extract UI blocks
8. **Add routes**: In `app_routes.dart` and `app_pages.dart`
9. **Add strings**: To `en_us.dart` and `bn_bd.dart`
10. **Add to AppStrings**: In `app_string_localizations.dart`

### Import Quick Reference

```dart
// Controller pattern
final controller = FeatureController.instance;

// Core widgets
import 'package:legacyhub/core/common/widgets/buttons/custom_button.dart';
import 'package:legacyhub/core/common/widgets/text_fields/custom_text_field.dart';
import 'package:legacyhub/core/common/widgets/shimmers/shimmer.dart';
import 'package:legacyhub/core/common/widgets/states/empty_state_widget.dart';
import 'package:legacyhub/core/common/widgets/popups/custom_snackbar.dart';

// Services
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';

// Utilities
import 'package:legacyhub/core/utils/constants/colors.dart';
import 'package:legacyhub/core/utils/constants/firebase_paths.dart';
import 'package:legacyhub/core/utils/formatters/formatters.dart';
import 'package:legacyhub/core/utils/validators/app_validator.dart';

// Localization
import 'package:legacyhub/core/localization/app_string_localizations.dart';

// External packages
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
```

---

## 🏁 Final Checklist

**When your code is ready, verify:**

- [ ] Uses package imports (not relative)
- [ ] Controller has `static instance` getter
- [ ] No hardcoded text (uses AppStrings)
- [ ] No hardcoded colors (uses AppColors)
- [ ] Uses Iconsax icons
- [ ] Uses ScreenUtil (.w, .h, .r)
- [ ] Loading states handled
- [ ] Error states handled
- [ ] Empty states handled
- [ ] Firebase calls in Repository only
- [ ] User feedback via AppSnackBar
- [ ] Logged errors via LoggerService

---

**End of LegacyHub AI Agent Instructions**
