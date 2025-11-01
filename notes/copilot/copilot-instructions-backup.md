# 🤖 AI Agent Instructions for Flutter Development

## 🚨 Critical Rules (Must Follow)

These rules are non-negotiable and must be applied in all generated code.

### 1. Imports
- **✅ Use package imports** for all files within `lib/`:
  ```dart
  import 'package:project_template/core/utils/constants/app_colors.dart';
  import 'package:project_template/core/localization/language_controller.dart';
  ```
- **❌ Avoid relative imports**:
  ```dart
  import '../../constants/app_colors.dart';
  ```
- **Agent Action**: Always generate `package:project_template/` imports for files in `lib/`. Use relative imports only for files outside `lib/` (e.g., tests).

### 2. Color Methods
- **✅ Use `Color.withValues(alpha: ...)`** for opacity:
  ```dart
  Color.withValues(alpha: 0.5)
  ```
- **❌ Avoid deprecated `Color.withOpacity(...)`**:
  ```dart
  Color.withOpacity(0.5)
  ```
- **Agent Action**: Replace any `.withOpacity()` with `.withValues(alpha: ...)` in generated code.

### 3. GetX Controllers & Instance Pattern
- **✅ ALWAYS use instance pattern to access controllers**:
  ```dart
  final controller = MyController.instance;  // ✅ Correct
  ```
- **❌ NEVER use `Get.find<>()` directly**:
  ```dart
  final controller = Get.find<MyController>();  // ❌ Avoid
  ```
- **✅ MANDATORY: Every controller MUST have instance getter**:
  ```dart
  class MyController extends GetxController {
    static MyController get instance => Get.find();
    // Controller code...
  }
  ```
- **❌ Never use `Get.put()` in `build()` methods**:
  ```dart
  final controller = Get.put(MyController());  // ❌ Wrong
  ```
- **Agent Action**: 
  1. Always add `static ControllerName get instance => Get.find();` to every controller
  2. Use `ControllerName.instance` to access controllers everywhere
  3. Register controllers in `initial_binding.dart` only
  4. Never use `Get.find<>()` or `Get.put()` in widgets

### 4. Icons
- **✅ ALWAYS use `Iconsax` package for all icons**:
  ```dart
  import 'package:iconsax/iconsax.dart';
  
  Icon(Iconsax.home)              // ✅ Correct
  Icon(Iconsax.user)              // ✅ Correct
  Icon(Iconsax.search_normal)     // ✅ Correct
  ```
- **❌ NEVER use Flutter's default Material icons**:
  ```dart
  Icon(Icons.home)                // ❌ Wrong
  Icon(Icons.person)              // ❌ Wrong
  ```
- **✅ For SVG icons, use `SvgIconHelper`**:
  ```dart
  import 'package:project_template/core/utils/helpers/svg_icon_helper.dart';
  
  // Basic SVG icon
  SvgIconHelper.buildIcon(
    assetPath: 'assets/icons/custom_icon.svg',
    width: 24.w,
    height: 24.h,
    color: AppColors.primary,
  )
  
  // SVG icon with tap handler
  SvgIconHelper.buildIconWithTap(
    assetPath: 'assets/icons/menu.svg',
    onTap: () => controller.openMenu(),
    color: AppColors.textPrimary,
  )
  ```
- **Agent Action**: 
  1. Use `Iconsax` for all standard icons
  2. Use `SvgIconHelper` for custom SVG icons from assets
  3. Never use `Icons` from Material library
  4. Always import `iconsax` package

### Logging
- **✅ Use `LoggerService`** for all application logging. Import it with a package import:
  ```dart
  import 'package:project_template/core/services/logger_service.dart';
  ```
- **❌ Do NOT** use `print()`, `debugPrint()`, or instantiate `Logger()` directly in app code.
- **Usage Examples**:
  ```dart
  LoggerService.info('User logged in successfully');
  LoggerService.error('API call failed', error: exception);
  LoggerService.warning('⚠️ No internet connection');
  LoggerService.debug('🔍 Debug info: $data');
  ```
- **Agent Action**: Replace any direct `print`/`debugPrint` or local `Logger` usage with `LoggerService.debug/info/warning/error`.
- **If missing**: If `LoggerService` does not exist in the workspace, create a single global logger wrapper at `lib/core/services/logger_service.dart` and use it everywhere. Do NOT create multiple logger instances scattered across files.

### 5. EasyLoading - Loading Indicators ONLY
- **✅ ONLY use EasyLoading for loading states**:
  ```dart
  // Show loading spinner
  EasyLoading.show(status: 'loading...');
  
  // Show progress indicator
  EasyLoading.showProgress(0.3, status: 'downloading...');
  
  // Dismiss loading
  EasyLoading.dismiss();
  ```
- **❌ NEVER use EasyLoading for success/error/info messages**:
  ```dart
  EasyLoading.showSuccess('Great Success!');  // ❌ Wrong
  EasyLoading.showError('Failed with Error'); // ❌ Wrong
  EasyLoading.showInfo('Useful Information.'); // ❌ Wrong
  EasyLoading.showToast('Toast');             // ❌ Wrong
  ```
- **✅ For success/error/info messages, use `AppSnackBar`** (see Snackbar section)
- **Agent Action**: 
  1. Use `EasyLoading.show()` ONLY for loading indicators
  2. Use `EasyLoading.showProgress()` ONLY for progress bars
  3. Never use `showSuccess`, `showError`, `showInfo`, or `showToast`
  4. Use `AppSnackBar` for all user feedback messages

### 6. Snackbar - User Feedback Messages
- **✅ ALWAYS use `AppSnackBar` for user feedback**:
  ```dart
  import 'package:project_template/core/common/widgets/popups/custom_snackbar.dart';
  
  // Success message
  AppSnackBar.successSnackBar(
    title: AppStrings.success,
    message: AppStrings.operationSuccessful,
  );
  
  // Error message
  AppSnackBar.errorSnackBar(
    title: AppStrings.error,
    message: AppStrings.operationFailed,
  );
  
  // Warning message
  AppSnackBar.warningSnackBar(
    title: AppStrings.warning,
    message: AppStrings.checkYourInput,
  );
  
  // Info message
  AppSnackBar.showInfoSnackBar(
    title: AppStrings.info,
    message: AppStrings.importantInformation,
  );
  
  // Custom toast
  AppSnackBar.customToast(message: AppStrings.quickMessage);
  ```
- **❌ NEVER use `Get.snackbar()` or Flutter's `SnackBar`**:
  ```dart
  Get.snackbar('Title', 'Message');        // ❌ Wrong
  ScaffoldMessenger.of(context).showSnackBar(...); // ❌ Wrong
  ```
- **Available Methods**:
  - `successSnackBar()` - Green snackbar for success messages
  - `errorSnackBar()` - Red snackbar for error messages
  - `warningSnackBar()` - Orange snackbar for warnings
  - `showInfoSnackBar()` - Blue snackbar for information
  - `customToast()` - Gray toast for quick messages
  - `hideSnackBar()` - Hide current snackbar
- **Agent Action**: 
  1. Use `AppSnackBar` for ALL user feedback (success, error, warning, info)
  2. Always use translatable strings from `AppStrings`
  3. Never use `Get.snackbar()` or Flutter's default SnackBar
  4. Import from `lib/core/common/widgets/popups/custom_snackbar.dart`

### 7. Formatters
- **✅ ALWAYS use `AppFormatter` for data formatting**:
  ```dart
  import 'package:project_template/core/utils/formetters/formetters.dart';
  
  // Phone number formatting
  final formatted = AppFormatter.formatPhoneNumber('1234567890');
  
  // Date formatting
  final date = AppFormatter.formatDate(DateTime.now(), format: 'dd MMM yyyy');
  
  // Time formatting
  final time = AppFormatter.formatTime(DateTime.now(), format: 'HH:mm');
  
  // DateTime formatting
  final dateTime = AppFormatter.formatDateTime(DateTime.now());
  
  // String utilities
  final capitalized = AppFormatter.capitalize('hello world');
  final capitalizedWords = AppFormatter.capitalizeWords('hello world');
  final truncated = AppFormatter.truncateText(longText, 50);
  final cleaned = AppFormatter.removeWhitespace('hello world');
  
  // Validation
  final isEmail = AppFormatter.isValidEmail('test@example.com');
  final isPhone = AppFormatter.isValidPhone('+1234567890');
  final isUrl = AppFormatter.isValidUrl('https://example.com');
  
  // Number formatting
  final number = AppFormatter.formatNumber(1234567);
  final currency = AppFormatter.formatCurrency(1234.56, symbol: '\$');
  final percentage = AppFormatter.formatPercentage(0.75);
  final fileSize = AppFormatter.formatFileSize(1048576); // 1 MB
  ```
- **❌ NEVER create custom formatting functions**:
  ```dart
  String formatPhone(String phone) { ... }  // ❌ Wrong
  String formatDate(DateTime date) { ... }  // ❌ Wrong
  ```
- **Available Categories**:
  - **Date & Time**: `formatDate()`, `formatTime()`, `formatDateTime()`
  - **String Utils**: `capitalize()`, `capitalizeWords()`, `truncateText()`, `removeWhitespace()`
  - **Validation**: `isValidEmail()`, `isValidPhone()`, `isValidUrl()`
  - **Number Utils**: `formatNumber()`, `formatCurrency()`, `formatPercentage()`, `formatFileSize()`
- **Agent Action**: 
  1. Use `AppFormatter` for ALL data formatting needs
  2. Add new formatters to `lib/core/utils/formetters/formetters.dart` if needed
  3. Never duplicate formatting logic across files
  4. Always import from the central formatters file


### 8. Controller Bindings
- **✅ Use `initial_binding.dart` for all controller registrations**:
  ```dart
  // In initial_binding.dart
  Get.put<MyController>(MyController());
  ```
- **❌ Never add bindings directly in `app_pages.dart`**:
  ```dart
  // ❌ Avoid this in app_pages.dart
  binding: BindingsBuilder(() {
    Get.lazyPut<MyController>(() => MyController());
  }),
  ```
- **Agent Action**: Always register controllers in `initial_binding.dart`. Never add individual bindings to routes in `app_pages.dart`.

### 9. Multi-Language Support (Text Strings)
- **✅ ALWAYS use `AppStrings` for all text constants**:
  ```dart
  Text(AppStrings.welcomeMessage)     // ✅ Translatable
  Text(AppStrings.getStarted)         // ✅ Translatable
  AppBar(title: Text(AppStrings.home)) // ✅ Translatable
  ```
- **❌ NEVER use hardcoded strings**:
  ```dart
  Text('Welcome to the app')          // ❌ Not translatable
  Text('Get Started')                 // ❌ Not translatable
  ```
- **✅ Use GetX `.tr` extension for direct translations**:
  ```dart
  Text('app_name'.tr)                 // ✅ Alternative approach
  Text('welcome_text'.tr)             // ✅ Alternative approach
  ```
- **✅ EasyLoading messages must be translatable**:
  ```dart
  EasyLoading.show(status: AppStrings.loading);       // ✅ Correct
  EasyLoading.showProgress(0.5, status: AppStrings.downloading); // ✅ Correct
  EasyLoading.show(status: 'Loading...');             // ❌ Hardcoded
  ```
- **Agent Action**: 
  1. **NEVER generate hardcoded text strings** in any widget or controller
  2. **Always use `AppStrings.textKey`** for all user-facing text
  3. **If string missing**: Add to all language files in `lib/core/localization/languages/`
  4. **Check existing translations** before creating new ones
  5. **Use descriptive keys**: `loginButton` not `btn1`, `emailValidationError` not `error1`
  2. **Always use `AppStrings.textKey`** for all user-facing text
  3. **If string missing**: Add to all language files in `lib/core/localization/languages/`
  4. **Check existing translations** before creating new ones
  5. **Use descriptive keys**: `loginButton` not `btn1`, `emailValidationError` not `error1`

### Validation

- **✅ Use `AppValidator` for all form and input validation**. Implement common validators (email, phone, full name, required, password, etc.) in a single shared file at:
  ```
  lib/core/utils/validators/app_validator.dart
  ```
- **✅ Use package imports** when referencing the validator from any file in `lib/`:
  ```dart
  import 'package:project_template/core/utils/validators/app_validator.dart';
  ```
- **✅ Preferred usage**: In widgets and controllers always call `AppValidator` helpers (for example `AppValidator.validateEmail(value)`) instead of inlining regex or custom validation logic.
- **❌ Avoid** duplicating validation logic or inlining regex patterns across widgets/controllers.
- **Agent Action**: Before generating any validation code, check for the existence of `lib/core/utils/validators/app_validator.dart`:
  1. If it exists, use its helpers for all validation.
  2. If it does not exist, create a single, well-documented `AppValidator` at `lib/core/utils/validators/app_validator.dart` that contains common validators (email, phone, full name, required, password, confirm password). Use null-safe signatures and clear error messages.
  3. After creating the validator file, add a short note in the task/PR (or communicate to the user) that the shared validator was created and where to add/modify validators.

Example usage in a form field:
```dart
CustomTextField(
  label: 'Email Address',
  validator: (value) => AppValidator.validateEmail(value),
  controller: controller.emailController,
)
```

### 6. UI Structure
- **Business Logic**: Place in controllers only.
- **UI Widgets**: Use for presentation only, no logic.
- **Widget Extraction**: Extract reusable widgets immediately.
- **ListView Preference**: Use `ListView` or `ListView.builder` instead of `SingleChildScrollView` + `Column`:
  ```dart
  // ✅ Preferred
  ListView(children: [...])
  // ❌ Avoid
  SingleChildScrollView(child: Column(...))
  ```
- **Agent Action**: Ensure widgets are stateless unless state is required. Extract repeated UI patterns into reusable widgets in `lib/features/[feature]/views/widgets/`.

---

## 🎯 Development Philosophy

**Write for Junior Developers**:
- Prioritize **clarity** over cleverness.
- Use simple, readable solutions.
- Avoid complex abstractions unless necessary.
- Ensure code is maintainable and extendable.

**Core Principles**:
- One responsibility per file/class/method.
- Extract widgets early to avoid duplication.
- Comment business logic, not obvious code.
- Keep methods under 30 lines where possible.

**Agent Action**: Generate code that is simple, well-commented, and follows the single-responsibility principle. Suggest widget extraction 
when patterns repeat.

## Package Management
*   If a new feature requires an external package, the AI will identify the most
    suitable and stable package from pub.dev.
*   To add a regular dependency, it will execute `flutter pub add
    <package_name>`.
*   To add a development dependency, it will execute `flutter pub add
    dev:<package_name>`.

### Dependency selection and updates (always check online)

- Before adding or updating any package the agent MUST search pub.dev to locate the package and determine the latest stable, null-safe version that is compatible with the project's SDK constraint.
- Prefer the newest non-prerelease (no `-dev`/`-beta`) release that supports null-safety and the project's current Flutter/Dart SDK.
- Use `flutter pub add <package_name>` to add the dependency. After adding, run `flutter pub get` to fetch packages.
- If version solving fails (dependency conflict), the agent should not force an unsafe upgrade. Instead it must: 
  1. Report the conflict with a short explanation of the incompatible packages.
  2. Propose 1-2 viable version alternatives (for the new package or existing packages) that are likely to resolve the conflict.
  3. Apply the chosen, non-breaking change only after explicit confirmation from the user (or if the user previously authorized automatic resolution in scope of the request).
- To audit available updates, the agent may run `flutter pub outdated` and report upgrade candidates; however the agent must not automatically upgrade the whole dependency tree without user approval.
- When adding a package that also requires platform setup (Android/iOS), include a short platform integration note (e.g., manifest or podfile changes) in the patch or follow-up message.

---

## 🏗 Architecture: Enhanced MVC Pattern with Repository Layer

```
Model      → Data classes, API models, database entities
View       → UI widgets and screens (presentation only)
Controller → Business logic and state management ONLY
Repository → API calls, local storage, data transformations
```

### Architecture Responsibilities:

#### 🖥️ **View Layer (UI)**
- **Screen and Widgets directories manage the UI**
- **Presentation only, no logic**
- Consume data from controllers via reactive variables
- Handle user interactions by calling controller methods

#### 🎮 **Controller Layer (Business Logic)**
- **Business logic management ONLY**
- State management with GetX reactive variables
- UI state updates and user interaction handling
- Call repository methods for data operations
- **❌ NO direct API calls or storage operations**

#### 📊 **Repository Layer (Data Operations)**
- **API calls, Local Storage logic management**
- HTTP requests and response handling
- Local database operations (SQLite, Hive, etc.)
- Data transformations and validations
- Cache management and offline data handling
- **❌ NO business logic or UI state management**

### Implementation Examples:

#### Controller Example:
```dart
class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  
  // Repository instance
  final HomeRepository _repository = HomeRepository();
  
  // Reactive variables
  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;
  
  // Business logic method
  Future<void> loadUsers() async {
    isLoading.value = true;
    try {
      EasyLoading.show(status: AppStrings.loading);
      final userData = await _repository.fetchUsers(); // Call repository
      users.assignAll(userData); // Update UI state
      AppSnackBar.successSnackBar(
        title: AppStrings.success,
        message: AppStrings.usersLoadedSuccessfully,
      );
    } catch (error) {
      LoggerService.error('Load users failed', error: error);
      AppSnackBar.errorSnackBar(
        title: AppStrings.error,
        message: AppStrings.failedToLoadUsers,
      );
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
```

#### Repository Example:
```dart
class HomeRepository {
  final HttpService _httpService = HttpService();
  
  // API operations
  Future<List<User>> fetchUsers() async {
    try {
      final response = await _httpService.get('/users');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (error) {
      LoggerService.error('API call failed', error: error);
      throw Exception('Failed to fetch users');
    }
  }
  
  // Local storage operations
  Future<void> saveUsersToLocal(List<User> users) async {
    // Local storage implementation
  }
}
```

#### Repository Instance Pattern:
All repositories must implement the instance pattern for consistent access:
```dart
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  
  // Repository methods here...
}
```

- **Agent Action**: 
  1. **Controllers**: Place only business logic and state management
  2. **Repositories**: Handle all data operations (API, storage, transformations)
  3. **Views**: Keep UI pure with no logic
  4. **Always implement instance pattern** in repositories for consistent access
  5. **Always add `static ControllerName get instance => Get.find();`** to every controller
  6. **Use `ControllerName.instance`** to access controllers in views

---

## 🌍 Multi-Language Support System

The app implements professional multi-language support using GetX internationalization. **ALL text must be translatable.**

### Core Architecture
```
lib/core/localization/
├── languages.dart              # Main configuration & supported locales
├── language_controller.dart    # Language switching & persistence 
└── languages/
    ├── en_us.dart             # English translations
    └── bn_bd.dart             # Bengali translations
```

### Supported Languages
- **English (US)** - Default (`'en'`)
- **Bengali (Bangladesh)** - Secondary (`'bn'`)
- **Easily extensible** for more languages

### Language Usage Rules
- **✅ MANDATORY**: Use `AppStrings` for ALL user-facing text
- **✅ Controllers**: Access language controller with `Get.find<LanguageController>()`
- **✅ Persistence**: Language choice automatically saved and restored
- **✅ System Detection**: Falls back to device locale if supported
- **❌ FORBIDDEN**: Any hardcoded strings in widgets or controllers

### Implementation Examples
```dart
// ✅ Correct text usage
Text(AppStrings.welcomeText)
AppBar(title: Text(AppStrings.home))
EasyLoading.showSuccess(AppStrings.savedSuccessfully)

// ✅ Language switching
final languageController = Get.find<LanguageController>();
await languageController.changeLanguageByCode('bn'); // Bengali
await languageController.changeLanguageByCode('en'); // English

// ✅ Language selector in settings
LanguageSelector() // Professional UI component

// ✅ Current language info
String currentLang = languageController.currentLanguageCode;
String displayName = languageController.currentLanguageName;
bool isEnglish = languageController.isCurrentLanguageCode('en');
```

### Adding New Strings
When you need a new translatable string:
1. **Add to ALL language files** (en_us.dart, bn_bd.dart)
2. **Add getter to AppStrings** class
3. **Use consistent key naming**: `loginButton`, `emailValidationError`

Example:
```dart
// 1. Add to en_us.dart
'forgot_password_title': 'Reset Password',

// 2. Add to bn_bd.dart  
'forgot_password_title': 'পাসওয়ার্ড রিসেট করুন',

// 3. Add to AppStrings class
static String get forgotPasswordTitle => 'forgot_password_title'.tr;

// 4. Use in widgets
Text(AppStrings.forgotPasswordTitle)
```

### Adding New Languages
To add a new language (e.g., Spanish):
1. **Create** `lib/core/localization/languages/es_es.dart`
2. **Update** `lib/core/localization/languages.dart` with new locale
3. **Add translations** for all existing keys
4. **Test** language switching

### Agent Actions for Multi-Language
- **NEVER** generate any hardcoded text strings
- **ALWAYS** use AppStrings for text constants
- **CHECK** if translation key exists before using
- **SUGGEST** adding missing translations to language files
- **ENSURE** EasyLoading messages are translatable
- **VALIDATE** that new features work in both languages

---

## 📁 Project Structure

```
lib/
├── core/                       # Core functionality
│   ├── bindings/               # GetX dependency injection
│   │   └── initial_binding.dart # Controller registration
│   ├── common/                 # Shared components
│   │   ├── styles/             # Global styles (text, shadows, spacing)
│   │   └── widgets/            # Reusable UI components
│   ├── config/                 # Configuration files
│   │   └── keys.dart           # API keys and secrets
│   ├── localization/           # Multi-language system
│   │   ├── languages.dart      # Language configuration
│   │   ├── language_controller.dart # Language management
│   │   └── languages/
│   │       ├── en_us.dart      # English translations  
│   │       └── bn_bd.dart      # Bengali translations
│   ├── services/               # Core services
│   │   ├── local_storage_service.dart # Storage operations
│   │   └── logger_service.dart # Logging service
│   └── utils/                  # Utility functions
│       ├── constants/          # Constants (colors, strings, sizes)
│       ├── device/             # Device utilities
│       ├── formatters/         # Data formatters
│       ├── helpers/            # Helper functions
│       ├── http/               # HTTP client
│       ├── local_storage/      # Storage utilities
│       ├── logging/            # Logger utilities
│       ├── manager/            # Managers (dialog, network)
│       ├── theme/              # Theme configuration
│       └── validators/         # Form validators
├── data/                       # Data layer
│   ├── models/                 # Data models
│   └── repositories/           # Data repositories
│       ├── authentication/     # Auth-related data operations
│       └── user/               # User-related data operations
├── features/                   # Feature modules
│   └── [feature_name]/         # Individual feature
│       ├── controllers/        # Business logic (GetX controllers)
│       ├── models/             # Feature-specific models
│       └── views/              # UI layer
│           ├── screens/        # Full-screen widgets
│           └── widgets/        # Feature-specific widgets
└── routes/                     # Navigation
    ├── app_routes.dart         # Route constants
    └── app_pages.dart          # Route-to-page mapping
```

### Folder Responsibilities:

#### **Core Directory**
- `bindings/`: Controller dependency injection setup
- `services/`: Singleton services (storage, logging, HTTP)
- `utils/`: Shared utilities and constants
- `localization/`: Multi-language support system
- `theme/`: App theming and styling

#### **Data Directory** 
- `models/`: Data classes and API models
- `repositories/`: Data access layer (API calls, local storage)

#### **Features Directory**
- Each feature has its own folder with MVC structure
- `controllers/`: Business logic and state management
- `views/screens/`: Full-page UI components
- `views/widgets/`: Reusable feature-specific components

#### **Routes Directory**
- `app_routes.dart`: Centralized route name constants
- `app_pages.dart`: Route-to-page mapping configuration

- **Agent Action**: Place files in the correct folder based on their role. Use descriptive names (e.g., `UserProfileScreen`, `CustomButtonWidget`).

---

## 📋 Documentation Requirements

- **Location**: Place `.md` files in `notes/` folder for task notes.
- **Task Notes**: Create comprehensive notes in `notes/` folder using descriptive filename (e.g., `instagram_style_comment_system.md`).
- **Content**: Explain core concepts for new Flutter developers with:
  - Overview and learning objectives
  - Architecture explanation (MVC pattern)
  - Step-by-step implementation guide
  - Code examples with explanations
  - Common issues and solutions
  - Testing guidelines
  - Performance considerations
- **When to Document**: MANDATORY for complex features like:
  - Complete UI systems (comment systems, chat interfaces,etc)
  - State management implementations
  - Custom animations and interactions
  - API integrations
  - Multi-file feature implementations
- **Agent Action**: After completing any complex task involving multiple files or advanced concepts, ALWAYS create detailed documentation in `notes/` folder that a beginner developer can follow to understand and replicate the implementation.

---

## 📋 Documentation Requirements

- **Location**: Place `.md` files in `notes/` folder for task notes.
- **Task Notes**: Create comprehensive notes in `notes/` folder under make specific featuresName using descriptive filename (e.g., `instagram_style_comment_system.md`).
- **Content**: Explain core concepts for new Flutter developers with:
  - Overview and learning objectives
  - Architecture explanation (MVC pattern)
  - Step-by-step implementation guide
  - Code examples with explanations
  - Common issues and solutions
  - Testing guidelines
  - Performance considerations
- **When to Document**: MANDATORY for complex features like:
  - Complete UI systems (comment systems, chat interfaces,etc)
  - State management implementations
  - Custom animations and interactions
  - API integrations
  - Multi-file feature implementations
- **Agent Action**: After completing any complex task involving multiple files or advanced concepts, ALWAYS create detailed documentation in `notes/` folder that a beginner developer can follow to understand and replicate the implementation.

---

## 📝 Code Quality Standards

### Naming Conventions
- **Variables/Methods**: camelCase (e.g., `userEmailController`, `fetchUserData`).
- **Classes/Widgets**: PascalCase (e.g., `UserCardWidget`).
- **Constants**: UPPER_CASE (e.g., `AppStrings.WELCOME_MESSAGE`).
- **Agent Action**: Use consistent naming conventions in all generated code.

### Commenting
- Use `//` for single-line comments.
- Use `///` for documentation comments on classes/methods:
  ```dart
  /// Fetches user data from API
  /// [id] - User ID
  /// Returns: User object
  Future<User> fetchUser(String id) async { ... }
  ```
- Comment business logic, not obvious code.
- **Agent Action**: Add comments for complex logic or non-obvious functionality.

---

## 🎨 UI Development Standards

### Text and Colors
- **Text**: Use `AppTextStyles` for typography:
  ```dart
  Text(AppStrings.welcome, style: AppTextStyles.heading1.copyWith(color: AppColors.primary))
  ```
- **Colors**: Use `AppColors` constants. Add missing colors to `core/utils/constants/app_colors.dart`:
  ```dart
  class AppColors {
    static const newDesignColor = Color(0xFF123456);
  }
  ```
- **Agent Action**: Use `AppTextStyles` and `AppColors`. Suggest adding new colors to `app_colors.dart` if needed.

### Responsive Sizing
- Use `screen_utils` package for all sizing:
  ```dart
  Container(
    width: 200.w,
    height: 100.h,
    padding: EdgeInsets.all(16.r),
  )
  ```
- **Agent Action**: Always apply `screen_utils` (`w`, `h`, `r`) for dimensions and spacing.

### Reusable Widgets
- Extract repeated UI patterns into reusable widgets:
  ```dart
  class InfoRow extends StatelessWidget {
    const InfoRow({super.key, required this.icon, required this.text});
    final IconData icon;
    final String text;

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Icon(icon, color: AppColors.secondary),
          SizedBox(width: 8.w),
          Text(text, style: AppTextStyles.body),
        ],
      );
    }
  }
  ```
- **Agent Action**: Extract widgets into `lib/features/[feature]/views/widgets/` when patterns repeat.

### Code Reusability & DRY Principle
- **✅ Always use existing reusable components**:
  ```dart
  // Use existing CustomTextField for all text inputs
  CustomTextField(
    label: 'Phone Number',
    placeholder: 'Enter phone number',
    controller: controller.phoneController,
    keyboardType: TextInputType.phone,
  )
  ```
- **❌ Never create custom implementations when reusable components exist**:
  ```dart
  // ❌ Don't create custom TextFormField when CustomTextField exists
  Container(
    decoration: BoxDecoration(...),
    child: TextFormField(...),
  )
  ```
- **Agent Action**: Before writing custom widgets, check if reusable components already exist. Use CustomTextField, CustomButton, etc. instead of creating duplicates.

### Figma Implementation
- **Priorities**:
  1. Use Flutter built-in widgets (e.g., `AppBar`, `ElevatedButton`) over custom `Container`.
  2. Minimize unnecessary code; avoid over-engineering.
  3. Use `padding`/`margin` for spacing, avoid fixed `SizedBox`.
  4. Use `screen_utils` for all sizing (`200.w`, `100.h`, `16.r`).
  5. **MANDATORY**: When user provides Figma URLs, ALWAYS call both `mcp_figma2_get_code` and `mcp_figma2_get_screenshot` for EVERY URL provided
- **Figma MCP Protocol**:
  ```dart
  // REQUIRED workflow for Figma URLs:
  // 1. Extract node-id from URL (e.g., node-id=138-961 becomes "138:961")
  // 2. Call mcp_figma2_get_code with extracted nodeId
  // 3. Call mcp_figma2_get_screenshot with same nodeId
  // 4. Implement pixel-perfect UI based on both code and screenshot
  ```
- **Common Widgets**:
  ```dart
  CustomAppBar(title: AppStrings.home)        // ✅ Translatable title
  CustomButton(text: AppStrings.submit, onPressed: controller.submit)
  CustomTextField(
    label: AppStrings.email,                  // ✅ Translatable label
    placeholder: AppStrings.enterEmail,       // ✅ Translatable placeholder
    controller: controller.emailController, 
    validator: AppValidator.email
  )
  LanguageSelector()                          // ✅ Language picker widget
  ```
- **AppBar Usage Guidelines**:
  - **✅ ALWAYS use `CustomAppBar` for all screens with translatable titles**:
  ```dart
  Scaffold(
    appBar: CustomAppBar(title: AppStrings.screenTitle), // ✅ Translatable
    body: content,
  )
  ```
  - **❌ NEVER use `Container` or custom implementations for app bar**:
  ```dart
  // ❌ Don't create custom app bar containers
  Container(
    height: 54.h,
    child: Row(...), // Custom app bar implementation
  )
  ```
  - **❌ NEVER use hardcoded titles**:
  ```dart
  CustomAppBar(title: 'Settings'), // ❌ Not translatable
  ```
  - **✅ Use `appBar` property in `Scaffold`, NOT in body**:
  ```dart
  // ✅ Correct way
  Scaffold(
    appBar: CustomAppBar(title: AppStrings.settings),
    body: content,
  )
  
  // ❌ Wrong way
  Scaffold(
    body: Column(
      children: [
        CustomAppBar(title: AppStrings.settings), // Don't put in body
        content,
      ],
    ),
  )
  ```
  - **AppBar Theme**: Main theme configured in `core/utils/theme/custom_themes/app_bar_theme.dart`
- **Images/Icons**:
  - Use online image links (to be replaced with assets later).
  - Use Flutter `Icon` for icons (to be replaced with custom assets later).
- **TextField Borders**:
  - Same border for focus/enable states; red for error state.
- **Scaffold Background**:
  - Use theme data, not direct `backgroundColor`:
  ```dart
  Scaffold(body: content) // ✅
  Scaffold(backgroundColor: Colors.blue, body: content) // ❌
  ```
- **CustomButton Properties**:
  - **✅ Only specify non-default properties**:
  ```dart
  CustomButton(text: 'Submit', onPressed: onPressed, height: 56)
  ```
  - **❌ Avoid redundant default properties**:
  ```dart
  CustomButton(text: 'Submit', onPressed: onPressed, showShadow: true, borderRadius: 25) // ❌
  ```
- **Agent Action**: Ensure pixel-perfect UI matching Figma designs. Use built-in widgets, `screen_utils`, and global styles. Never specify default properties in CustomButton calls. Always use CustomAppBar for consistent app bar implementation.

---

## 🌐 API Integration

### Network Layer
- Use `HttpService` with `http` package:
  ```dart
  class UserController extends GetxController {
    final UserRepository _repository = UserRepository();
    final RxList<User> users = <User>[].obs;
    final RxBool isLoading = false.obs;

    Future<void> getUsers() async {
      try {
        isLoading.value = true;
        EasyLoading.show();
        final userList = await _repository.fetchUsers();
        users.assignAll(userList);
        EasyLoading.showSuccess('Users loaded');
      } catch (error) {
        LoggerService.error('GetUsers error: $error', error: error);
        EasyLoading.showError('Failed to load users');
      } finally {
        isLoading.value = false;
        EasyLoading.dismiss();
      }
    }
  }
  ```
- **Agent Action**: Place API logic in repositories, use `HttpService`, and handle errors with `EasyLoading` and `LoggerService`.

### Model Classes
- Always null-safe with proper defaults:
  ```dart
  class User {
    final String id;
    final String name;
    final String email;

    const User({
      required this.id,
      required this.name,
      required this.email,
    });

    factory User.fromJson(Map<String, dynamic> json) {
      return User(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
      );
    }

    Map<String, dynamic> toJson() {
      return {'id': id, 'name': name, 'email': email};
    }
  }
  ```
- **Agent Action**: Generate null-safe models with `fromJson` and `toJson` methods.

---

## 🧪 Error Handling & Loading States

### Loading States
- Use `EasyLoading` for global loading:
  ```dart
  EasyLoading.show(status: 'Loading...');
  EasyLoading.dismiss();
  EasyLoading.showSuccess('Success!');
  EasyLoading.showError('Error occurred');
  ```
- Use `Shimmer` for list loading, matching Figma design:
  ```dart
  if (controller.isLoading.value) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const UserShimmer(),
    );
  }
  ```
- **Agent Action**: Implement `EasyLoading` for all loading states and `Shimmer` for list placeholders.

### Error Handling
- Handle errors in `HttpService`, not controllers:
  ```dart
  try {
    final response = await HttpService.get(ApiConstants.users);
    // Process response
  } catch (error) {
    LoggerService.error('API Error: $error');
    EasyLoading.showError('Something went wrong');
  }
  ```
- **Agent Action**: Ensure errors are logged with `LoggerService` and displayed with `EasyLoading`.

Note: Prefer `EasyLoading` over `Get.snackbar` or `SnackBar` for showing transient success/error/info messages. `EasyLoading` provides a consistent overlay UI and is the project's standard for feedback.

---

## 🚫 Anti-Patterns to Avoid

- **❌ CRITICAL: Hardcoded Text Strings**:
  ```dart
  Text('Login')                              // ❌ Not translatable
  EasyLoading.show(status: 'Loading...');    // ❌ Not translatable
  AppBar(title: Text('Settings'));          // ❌ Not translatable
  ```
  **Use instead:**
  ```dart
  Text(AppStrings.login)                     // ✅ Translatable
  EasyLoading.show(status: AppStrings.loading); // ✅ Translatable
  AppBar(title: Text(AppStrings.settings));  // ✅ Translatable
  ```
- **❌ CRITICAL: Using EasyLoading for Messages**:
  ```dart
  EasyLoading.showSuccess('Success!');       // ❌ Use AppSnackBar
  EasyLoading.showError('Error occurred');   // ❌ Use AppSnackBar
  EasyLoading.showInfo('Information');       // ❌ Use AppSnackBar
  EasyLoading.showToast('Toast message');    // ❌ Use AppSnackBar
  ```
  **Use instead:**
  ```dart
  AppSnackBar.successSnackBar(title: AppStrings.success, message: ...); // ✅
  AppSnackBar.errorSnackBar(title: AppStrings.error, message: ...);     // ✅
  AppSnackBar.showInfoSnackBar(title: AppStrings.info, message: ...);   // ✅
  AppSnackBar.customToast(message: ...);                                 // ✅
  ```
- **❌ CRITICAL: Wrong Controller Access Pattern**:
  ```dart
  final controller = Get.find<MyController>();  // ❌ Don't use Get.find directly
  final controller = Get.put(MyController());   // ❌ Never use Get.put in widgets
  ```
  **Use instead:**
  ```dart
  final controller = MyController.instance;     // ✅ Always use instance pattern
  ```
- **❌ CRITICAL: Using Flutter Default Icons**:
  ```dart
  Icon(Icons.home)                           // ❌ Don't use Material icons
  Icon(Icons.person)                         // ❌ Don't use Material icons
  ```
  **Use instead:**
  ```dart
  Icon(Iconsax.home)                         // ✅ Use Iconsax icons
  Icon(Iconsax.user)                         // ✅ Use Iconsax icons
  // For SVG icons:
  SvgIconHelper.buildIcon(assetPath: 'assets/icons/custom.svg') // ✅
  ```
- **Business Logic in UI**:
  ```dart
  class MyScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      fetchUserData(); // ❌
      return Scaffold(...);
    }
  }
  ```
- **Redundant Default Properties**:
  ```dart
  CustomButton(showShadow: true, borderRadius: 25) // ❌ (these are defaults)
  ```
- **Unnecessary Scaffold backgroundColor**:
  ```dart
  Scaffold(backgroundColor: AppColors.white) // ❌ (use theme)
  ```
- **Unnecessary Container/SizedBox Wrappers**:
  ```dart
  SizedBox(height: 300, child: Column(...)) // ❌ (use direct spacing)
  ```
- **Creating Custom Widgets for Existing Components**:
  ```dart
  // ❌ Don't create when CustomTextField exists
  Widget _buildCustomTextField() { return Container(...); }
  ```
- **Other Hardcoded Values**:
  ```dart
  Colors.blue.withOpacity(0.5) // ❌ Use AppColors and .withValues()
  Container(width: 200)        // ❌ Use 200.w for responsive sizing
  ```
- **Deep Relative Imports**:
  ```dart
  import '../../utils/colors.dart'; // ❌
  ```
- **Complex Nested Widgets**:
  ```dart
  Column(children: [Container(child: Row(...))]) // ❌
  ```
- **Complex Ternaries or One-Liners**:
  ```dart
  widget.x ? doThis() : widget.y ? doThat() : doOther(); // ❌
  ```
- **Using `print()`**:
  ```dart
  print('Debug'); // ❌
  ```
- **Dynamic Types**:
  ```dart
  var data = response.data; // ❌
  ```
- **Agent Action**: Avoid these patterns. Suggest refactoring if detected in existing code.

---

## 🔧 Code Style Guidelines

### Widget Construction
```dart
class CustomButton extends StatelessWidget {
  /// Custom button with rounded corners
  /// [onPressed] - Callback for button press
  /// [text] - Button text
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(text, style: AppTextStyles.button),
    );
  }
}
```
- **Agent Action**: Use `const` constructors, `super.key`, and `AppTextStyles` in widgets.

### Method Structure
- Keep methods short (20-30 lines).
- Use early returns to reduce nesting:
  ```dart
  Future<void> loadUserData() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final userData = await userService.getCurrentUser();
      user.value = userData;
      EasyLoading.showSuccess('User loaded');
    } catch (error) {
      LoggerService.error('LoadUser error: $error');
      EasyLoading.showError('Failed to load user');
    } finally {
      isLoading.value = false;
    }
  }
  ```
- **Agent Action**: Structure methods for clarity with early returns and proper error handling.

---

## 🎯 Agent Success Criteria

1. **🌍 PRIORITY: Multi-Language Compliance**: NO hardcoded text strings. ALL text must use `AppStrings`.
2. **Scan Critical Rules**: Imports, colors, GetX, UI structure.
3. **Extract Reusable Widgets**: Avoid UI duplication.
4. **Keep Logic in Controllers**: UI is presentation only.
5. **Use Constants**: For strings, colors, sizes.
6. **Handle Errors Gracefully**: Use `EasyLoading` and `LoggerService`.
7. **Write Clear Code**: Understandable by junior developers.
8. **Document Complex Tasks**: Create detailed notes in `notes/` folder after completing multi-file features or advanced implementations.

**Agent Action**: Prioritize multi-language compliance above all else. NEVER generate hardcoded strings. Suggest improvements for violations in existing code. ALWAYS create documentation for complex implementations.

**If figma link is provided, then the status bar of the figma design should not be created.**

**When A controller is created. Make Get.put() in initial_binding.dart. If this file not there then create the file and use it in initialBindings in MaterialApp of app.dart. Make a instance of that controller in that particular controller file like for example:   static BottomNavbarController get instance => Get.find(); so that I can call it from anywhere of the app. Example given bellow:**

## Instance of controller in controller file
```dart
import 'package:get/get.dart';
class BottomNavbarController extends GetxController {
  static BottomNavbarController get instance => Get.find();
}
```

## InitialBindings in app.dart if not there then create it
```dart
initialBinding: InitialBinding(),
```

## in initial_binding.dart
```dart
import 'package:get/get.dart';
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BottomNavbarController>(BottomNavbarController());
  }
}
```

**Repository Instance Pattern**: All repositories must implement the instance pattern for consistent access:
```dart
static AuthenticationRepository get instance => Get.find();
```


**When a new page is created then make a route in app_routes.dart and add that page in app_pages.dart. Example given bellow:**

## In app_routes.dart
```dart
class AppRoute {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String demo = '/demo';
  static const String changePassword = '/change-password';
  static const String settings = '/settings';
  static const String themeAndAppearanceScreen = '/theme-and-appearance';
  /// -- Getx Routes --
  static String getHomeScreen() => home;
  static String getWelcomeScreen() => welcome;
  static String getDemoScreen() => demo;
  static String getChangePasswordScreen() => changePassword;
  static String getSettingsScreen() => settings;
  static String getThemeAndAppearanceScreen() => themeAndAppearanceScreen;
}
```## In app_pages.dart
```dart
import 'package:get/get.dart';
import 'package:project_template/features/home/views/screens/home_screen.dart';
import 'package:project_template/features/profile/views/screens/profile_screen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
  ];
}
```

---

## 🎨 Theme & Styling System

### Theme Architecture

The app uses a comprehensive theming system with light and dark mode support.

**Theme Configuration**: `lib/core/utils/theme/theme.dart`
- Light and dark themes defined
- Material 3 design system
- Custom theme components in `lib/core/utils/theme/custom_themes/`

#### Available Custom Themes:
- `appbar_theme.dart` - AppBar styling
- `bottom_sheet_theme.dart` - Bottom sheet styling
- `checkbox_theme.dart` - Checkbox styling
- `chip_theme.dart` - Chip widget styling
- `elevated_button_theme.dart` - Primary button styling
- `outlined_button_theme.dart` - Secondary button styling
- `text_field_theme.dart` - Input field styling
- `text_theme.dart` - Typography system

### Colors: `lib/core/utils/constants/colors.dart`

**✅ ALWAYS use `AppColors` constants:**
```dart
// ✅ Correct
Container(color: AppColors.primary)

// ❌ Wrong - Hardcoded colors
Container(color: Color(0xFF4B68FF))
```

**Available Color Categories:**
- **App Colors**: `primary`, `secondary`, `accent`
- **Text Colors**: `textPrimary`, `textSecondary`, `textWhite`
- **Background Colors**: `light`, `dark`, `primaryBackground`, `lightContainer`, `darkContainer`
- **Button Colors**: `buttonPrimary`, `buttonSecondary`, `buttonDisabled`
- **Border Colors**: `borderPrimary`, `borderSecondary`
- **Status Colors**: `error`, `success`, `warning`, `info`
- **Neutral Colors**: `black`, `darkerGrey`, `darkGrey`, `grey`, `softerGrey`, `softGrey`, `lightGrey`, `white`

**Agent Action**: Never hardcode colors. Always use `AppColors` constants. If a new color is needed, add it to `colors.dart` first.

### Text Styles: `lib/core/common/styles/global_text_style.dart`

**✅ Use helper functions for consistent typography:**

```dart
// Normal text
Text('Content', style: getTextStyle(fontSize: 14, color: AppColors.textPrimary))

// Bold text
Text('Important', style: getBoldTextStyle(fontSize: 16, fontWeight: FontWeight.w700))

// Heading text
Text('Title', style: getHeadingStyle(fontSize: 24, color: AppColors.dark))

// Subheading text
Text('Subtitle', style: getSubHeadingStyle(fontSize: 16, lineHeight: 1.5))

// Label text
Text('Label', style: getLabelTextStyle(fontSize: 14, color: AppColors.textSecondary))
```

**Helper Functions Available:**
- `getTextStyle()` - Normal body text
- `getBoldTextStyle()` - Emphasized text
- `getHeadingStyle()` - Page titles and major headings
- `getSubHeadingStyle()` - Section subtitles
- `getLabelTextStyle()` - Form labels and captions

**Common Parameters:**
- `fontSize` - Size in logical pixels (auto-converted with ScreenUtil)
- `fontWeight` - Font weight (w400, w500, w600, w700)
- `lineHeight` - Line height multiplier
- `color` - Text color from AppColors
- `textAlign` - Text alignment

**Agent Action**: 
- Use text style helpers for all Text widgets
- Never hardcode fontSize or fontWeight directly
- Always apply colors from `AppColors`

---

## 📦 Reusable Widgets Library

All reusable widgets are in `lib/core/common/widgets/`. **ALWAYS use these instead of creating custom implementations.**

### Buttons: `lib/core/common/widgets/buttons/custom_button.dart`

**Usage:**
```dart
// Primary button (filled)
CustomButton(
  text: AppStrings.submit,
  onPressed: controller.handleSubmit,
  type: ButtonType.primary,
)

// Secondary button (outlined)
CustomButton(
  text: AppStrings.cancel,
  onPressed: () => Get.back(),
  type: ButtonType.secondary,
)

// Text button
CustomButton(
  text: AppStrings.skip,
  onPressed: controller.skipStep,
  type: ButtonType.text,
)

// With icon
CustomButton(
  text: AppStrings.addItem,
  icon: Icons.add,
  onPressed: controller.addItem,
)

// Loading state
CustomButton(
  text: AppStrings.loading,
  isLoading: controller.isLoading.value,
  onPressed: controller.submit,
)

// Disabled
CustomButton(
  text: AppStrings.submit,
  isEnabled: false,
  onPressed: null,
)
```

**Properties:**
- `text` (required) - Button text (MUST be from AppStrings)
- `onPressed` - Callback function
- `type` - ButtonType enum (primary, secondary, text)
- `isLoading` - Show loading indicator
- `isEnabled` - Enable/disable button
- `icon` - Optional icon before text
- `width`, `height` - Custom dimensions
- `padding`, `borderRadius` - Custom styling

**Agent Action**: NEVER create custom button widgets. Use CustomButton with appropriate type.

### Text Fields: `lib/core/common/widgets/text_fields/custom_text_field.dart`

**Usage:**
```dart
// Basic text field
CustomTextField(
  labelText: AppStrings.email,
  hintText: AppStrings.enterEmail,
  controller: controller.emailController,
  keyboardType: TextInputType.emailAddress,
  validator: AppValidator.validateEmail,
)

// Password field (auto-shows visibility toggle)
CustomTextField(
  labelText: AppStrings.password,
  hintText: AppStrings.enterPassword,
  controller: controller.passwordController,
  obscureText: true,
  validator: AppValidator.validatePassword,
)

// With prefix icon
CustomTextField(
  labelText: AppStrings.search,
  prefixIcon: Icon(Icons.search),
  controller: controller.searchController,
)

// With suffix icon
CustomTextField(
  labelText: AppStrings.phone,
  suffixIcon: Icon(Icons.phone),
  keyboardType: TextInputType.phone,
)

// Multiline text area
CustomTextField(
  labelText: AppStrings.description,
  maxLines: 5,
  controller: controller.descriptionController,
)

// Read-only
CustomTextField(
  labelText: AppStrings.date,
  controller: controller.dateController,
  readOnly: true,
  onTap: () => controller.pickDate(),
)
```

**Properties:**
- `labelText` - Field label (from AppStrings)
- `hintText` - Placeholder text (from AppStrings)
- `controller` - TextEditingController
- `keyboardType` - Input type (email, phone, number, etc.)
- `obscureText` - Password field (auto-adds visibility toggle)
- `validator` - Validation function (use AppValidator)
- `prefixIcon`, `suffixIcon` - Icons
- `maxLines` - For text areas
- `readOnly` - For non-editable fields
- `enabled` - Disable input
- `onTap` - Tap callback (for pickers)

**Agent Action**: NEVER create custom TextField widgets. Use CustomTextField with proper validation from AppValidator.

### Loaders: `lib/core/common/widgets/loaders/`

**Circular Loader**: `circular_loader.dart`
```dart
// Full-screen loading
const AppCircularLoader(size: 60)

// Small inline loader
const AppCircularLoader(size: 30)
```

**Shimmer Effect**: `lib/core/common/widgets/shimmers/shimmer.dart`
```dart
// List item shimmer
AppShimmerEffect(
  width: double.infinity,
  height: 80.h,
  radius: 12,
)

// Image shimmer
AppShimmerEffect(
  width: 100.w,
  height: 100.h,
  radius: 8,
)

// Custom color shimmer
AppShimmerEffect(
  width: 200.w,
  height: 50.h,
  color: AppColors.grey,
)
```

**Agent Action**: Use shimmers for loading list items. Use AppCircularLoader for full-screen or section loading.

### State Widgets: `lib/core/common/widgets/states/`

**Empty State**: `empty_state_widget.dart`
```dart
// No data available
EmptyStateWidget(
  icon: Icons.inbox,
  title: AppStrings.noDataAvailable,
  subtitle: AppStrings.noDataDescription,
)

// With action button
EmptyStateWidget(
  icon: Icons.shopping_cart,
  title: AppStrings.cartEmpty,
  subtitle: AppStrings.addItemsToCart,
  actionText: AppStrings.startShopping,
  onActionPressed: () => Get.toNamed(AppRoutes.shop),
)
```

**Error Display**: `error_display_widget.dart`
```dart
// Error state
ErrorDisplayWidget(
  icon: Icons.error_outline,
  title: AppStrings.errorOccurred,
  message: AppStrings.errorMessage,
  actionText: AppStrings.retry,
  onActionPressed: controller.retry,
)
```

**Agent Action**: Use state widgets for empty/error states instead of creating custom implementations.

### Images: `lib/core/common/widgets/images/custom_circular_image.dart`

```dart
// User avatar
CustomCircularImage(
  imageUrl: user.avatarUrl,
  size: 50,
  backgroundColor: AppColors.grey,
)

// With border
CustomCircularImage(
  imageUrl: imageUrl,
  size: 80,
  hasBorder: true,
  borderColor: AppColors.primary,
)
```

**Agent Action**: Use CustomCircularImage for all circular images (avatars, thumbnails).

---

## 🛠️ Utility Services & Helpers

### Device Utilities: `lib/core/utils/device/device_utility.dart`

**Usage Examples:**
```dart
// Hide keyboard
AppDeviceUtils.hideKeyboard(context);

// Check device type
if (AppDeviceUtils.isAndroid()) {
  // Android-specific code
}

// Screen dimensions
final screenHeight = AppDeviceUtils.getScreenHeight();
final screenWidth = AppDeviceUtils.getScreenWidth(context);

// Status bar
final statusBarHeight = AppDeviceUtils.getStatusBarHeight();
AppDeviceUtils.hideStatusBar();
AppDeviceUtils.showStatusBar();

// Orientation
final isLandscape = AppDeviceUtils.isLandscapeOrientation(context);

// Keyboard
final keyboardHeight = AppDeviceUtils.getKeyboardHeight();
final isKeyboardVisible = await AppDeviceUtils.isKeyboardVisible();

// Internet connection
final hasInternet = await AppDeviceUtils.hasInternetConnection();

// Launch URL
AppDeviceUtils.launchUrl('https://example.com');

// Haptic feedback
AppDeviceUtils.vibrate(Duration(milliseconds: 100));
```

**Available Methods:**
- `hideKeyboard()`, `setStatusBarColor()`, `setFullScreen()`
- `getScreenHeight()`, `getScreenWidth()`, `getPixelRatio()`
- `getStatusBarHeight()`, `getAppBarHeight()`, `getKeyboardHeight()`
- `isLandscapeOrientation()`, `isPortraitOrientation()`
- `isKeyboardVisible()`, `isPhysicalDevice()`
- `isAndroid()`, `isIOS()`
- `hasInternetConnection()`, `launchUrl()`
- `vibrate()`, `setPreferredOrientations()`

**Agent Action**: Use AppDeviceUtils for all device-specific operations. Never duplicate these utilities.

### App Helpers: `lib/core/utils/helpers/app_helper.dart`

**Usage Examples:**
```dart
// Show brief message
AppHelperFunctions.showSnackBar(AppStrings.operationSuccessful);

// Show dialog
AppHelperFunctions.showAlert(AppStrings.warning, AppStrings.confirmDelete);

// Check dark mode
final isDark = AppHelperFunctions.isDarkMode(context);

// Screen size
final screenSize = AppHelperFunctions.screenSize();
final height = AppHelperFunctions.screenHeight();
final width = AppHelperFunctions.screenWidth();

// Text truncation
final shortText = AppHelperFunctions.truncateText(longText, 50);

// Date formatting
final formattedDate = AppHelperFunctions.getFormattedDate(
  DateTime.now(),
  format: 'dd MMM yyyy',
);

// Remove duplicates
final uniqueItems = AppHelperFunctions.removeDuplicates(itemList);
```

**Agent Action**: Use helper functions instead of writing custom implementations for common operations.

### Network Manager: `lib/core/utils/manager/network_manager.dart`

**Usage in Controllers:**
```dart
class MyController extends GetxController {
  final networkManager = NetworkManager.instance;
  
  Future<void> fetchData() async {
    // Check connection before API call
    if (!await networkManager.isConnected()) {
      AppHelperFunctions.showSnackBar(AppStrings.noInternet);
      return;
    }
    
    // Proceed with API call
    await repository.getData();
  }
}
```

**Features:**
- Automatic connectivity monitoring
- Shows warning when internet disconnects
- Provides `isConnected()` method for manual checks
- Auto-initialized as singleton

**Agent Action**: Always check network status before making API calls in repositories or controllers.

---

## 🎯 Common Development Patterns

### Pattern 1: List Screen with Loading & Empty States

```dart
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.products),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (_, __) => AppShimmerEffect(
              width: double.infinity,
              height: 80.h,
            ),
          );
        }
        
        // Empty state
        if (controller.products.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.inventory_2_outlined,
            title: AppStrings.noProducts,
            subtitle: AppStrings.addProductsMessage,
            actionText: AppStrings.addProduct,
            onActionPressed: controller.navigateToAddProduct,
          );
        }
        
        // Data list
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ProductCard(product: product);
          },
        );
      }),
    );
  }
}
```

### Pattern 2: Form Screen with Validation

```dart
class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = RegisterController.instance;
    
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.register),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              CustomTextField(
                labelText: AppStrings.fullName,
                controller: controller.nameController,
                validator: AppValidator.validateFullName,
              ),
              SizedBox(height: 16.h),
              
              CustomTextField(
                labelText: AppStrings.email,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidator.validateEmail,
              ),
              SizedBox(height: 16.h),
              
              CustomTextField(
                labelText: AppStrings.password,
                controller: controller.passwordController,
                obscureText: true,
                validator: AppValidator.validatePassword,
              ),
              SizedBox(height: 24.h),
              
              Obx(() => CustomButton(
                text: AppStrings.register,
                onPressed: controller.register,
                isLoading: controller.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Pattern 3: API Call in Controller

```dart
class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final ProductRepository _repository = ProductRepository();
  
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
  
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: AppStrings.loading);
      
      final productList = await _repository.getProducts();
      products.assignAll(productList);
      
      EasyLoading.dismiss();
    } catch (error) {
      LoggerService.error('Fetch products failed', error: error);
      AppSnackBar.errorSnackBar(
        title: AppStrings.error,
        message: AppStrings.errorLoadingProducts,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refresh() async {
    await fetchProducts();
  }
}
```

### Pattern 4: Repository Implementation

```dart
class ProductRepository {
  Future<List<Product>> getProducts() async {
    final response = await HttpService.get<List<Product>>(
      ApiEndpoints.products,
      fromJson: (json) => (json as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
    
    if (response.isSuccess) {
      return response.data!;
    } else {
      throw Exception(response.error?.message ?? 'Failed to load products');
    }
  }
  
  Future<Product> createProduct(Product product) async {
    final response = await HttpService.post<Product>(
      ApiEndpoints.products,
      data: product.toJson(),
      fromJson: (json) => Product.fromJson(json),
    );
    
    if (response.isSuccess) {
      return response.data!;
    } else {
      throw Exception(response.error?.message ?? 'Failed to create product');
    }
  }
}
```

---

## 🚀 Quick Reference Checklist

**Before Creating Any Widget:**
- ✅ Check if reusable widget exists in `lib/core/common/widgets/`
- ✅ Use CustomButton instead of creating custom buttons
- ✅ Use CustomTextField instead of custom text inputs
- ✅ Use AppShimmerEffect for loading states
- ✅ Use EmptyStateWidget for empty states

**Before Adding Colors or Styles:**
- ✅ Check `AppColors` constants in `colors.dart`
- ✅ Use text style helpers from `global_text_style.dart`
- ✅ Never hardcode colors or font sizes

**Before Adding Text:**
- ✅ ALWAYS use AppStrings (from localization)
- ✅ Add translation keys to ALL language files
- ✅ Never hardcode user-facing text

**Before Making API Calls:**
- ✅ Place logic in Repository, not Controller
- ✅ Use HttpService methods
- ✅ Check network status with NetworkManager
- ✅ Handle errors with EasyLoading and LoggerService

**For All Sizes:**
- ✅ Use `.w` for widths
- ✅ Use `.h` for heights
- ✅ Use `.r` for radius/padding/margins

---

## 🎓 Agent Learning Summary

**When asked to create UI:**
1. Check `lib/core/common/widgets/` for existing components
2. Use AppColors and text style helpers
3. Apply ScreenUtil extensions (.w, .h, .r)
4. Extract repeated patterns into reusable widgets
5. Use AppStrings for all text
6. Use Iconsax icons, NOT Material Icons
7. Use SvgIconHelper for custom SVG icons

**When asked to add business logic:**
1. Place in Controller (not View)
2. Always add `static ControllerName get instance => Get.find();` to controller
3. Use `ControllerName.instance` to access controllers
4. Use Repository for data operations
5. Handle loading states with Obx/reactive variables
6. Show loading with EasyLoading.show() only
7. Show feedback with AppSnackBar (success/error/warning/info)
8. Log errors with LoggerService

**When asked to format data:**
1. Always use AppFormatter methods
2. Never create custom formatting functions
3. Check existing formatters before adding new ones
4. Add new formatters to `lib/core/utils/formetters/formetters.dart`

**When asked to add a new feature:**
1. Create feature folder in `lib/features/[feature_name]/`
2. Add controller to `initial_binding.dart` with Get.put()
3. Add instance getter to controller
4. Create repository for data operations
5. Use existing reusable widgets
6. Add routes to `app_routes.dart` and `app_pages.dart`

**Always Remember:**
- 🌍 Multi-language: Use AppStrings (CRITICAL)
- 🎨 Theming: Use AppColors and text helpers
- 📱 Responsive: Use ScreenUtil (.w, .h, .r)
- 🔧 Reusable: Use existing core widgets
- 🏗️ Architecture: Controller → Repository → API
- 🎯 Controllers: Use instance pattern everywhere
- ⏳ Loading: EasyLoading.show() only, NOT showSuccess/showError
- 💬 Feedback: AppSnackBar for all user messages
- 🎨 Icons: Iconsax icons, NOT Material Icons
- 📝 Formatting: AppFormatter for all data formatting