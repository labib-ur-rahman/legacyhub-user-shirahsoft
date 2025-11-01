# 🤖 AI Agent Instructions for Flutter Development

**Purpose**: This document provides comprehensive, non-redundant instructions for AI agents working on this Flutter project. Follow these rules strictly to maintain code quality and consistency.

---

## 📑 Table of Contents

1. [Critical Rules (Must Follow)](#-critical-rules-must-follow)
2. [Project Architecture](#-project-architecture)
3. [Core Components Reference](#-core-components-reference)
4. [Development Standards](#-development-standards)
5. [Common Patterns & Anti-Patterns](#-common-patterns--anti-patterns)
6. [Quick Reference Guide](#-quick-reference-guide)

---

## 🚨 Critical Rules (Must Follow)

These rules are **non-negotiable** and must be applied in all generated code.

### 1. Package Imports (Not Relative)
```dart
// ✅ ALWAYS use package imports
import 'package:project_template/core/utils/constants/colors.dart';

// ❌ NEVER use relative imports
import '../../constants/colors.dart';
```

### 2. Controller Access Pattern
```dart
// ✅ ALWAYS use instance pattern
final controller = MyController.instance;

// ❌ NEVER use Get.find directly
final controller = Get.find<MyController>();

// ✅ MANDATORY: Every controller MUST have this
class MyController extends GetxController {
  static MyController get instance => Get.find();
  // ... controller code
}
```

### 3. Multi-Language Support
```dart
// ✅ ALWAYS use AppStrings
Text(AppStrings.welcomeMessage)
EasyLoading.show(status: AppStrings.loading);

// ❌ NEVER hardcode text
Text('Welcome to the app')
EasyLoading.show(status: 'Loading...');
```

### 4. Icons
```dart
// ✅ ALWAYS use Iconsax
import 'package:iconsax/iconsax.dart';
Icon(Iconsax.home)

// ✅ For SVG, use SvgIconHelper
import 'package:project_template/core/utils/helpers/svg_icon_helper.dart';
SvgIconHelper.buildIcon(
  assetPath: 'assets/icons/custom.svg',
  width: 24.w,
  height: 24.h,
)

// ❌ NEVER use Material Icons
Icon(Icons.home)
```

### 5. Loading States (EasyLoading)
```dart
// ✅ ONLY for loading indicators
EasyLoading.show(status: AppStrings.loading);
EasyLoading.showProgress(0.5, status: AppStrings.downloading);
EasyLoading.dismiss();

// ❌ NEVER for user messages
EasyLoading.showSuccess('Done!');  // Use AppSnackBar instead
EasyLoading.showError('Failed');   // Use AppSnackBar instead
```

### 6. User Feedback (AppSnackBar)
```dart
// ✅ ALWAYS use AppSnackBar for messages
import 'package:project_template/core/common/widgets/popups/custom_snackbar.dart';

AppSnackBar.successSnackBar(title: AppStrings.success, message: AppStrings.done);
AppSnackBar.errorSnackBar(title: AppStrings.error, message: AppStrings.failed);
AppSnackBar.warningSnackBar(title: AppStrings.warning, message: AppStrings.warning);
AppSnackBar.showInfoSnackBar(title: AppStrings.info, message: AppStrings.info);
AppSnackBar.customToast(message: AppStrings.quickMessage);

// ❌ NEVER use Get.snackbar or Flutter SnackBar
Get.snackbar('Title', 'Message');
```

### 7. Data Formatting (AppFormatter)
```dart
// ✅ ALWAYS use AppFormatter
import 'package:project_template/core/utils/formatters/formatters.dart';

AppFormatter.formatDate(DateTime.now(), format: 'dd MMM yyyy');
AppFormatter.formatPhoneNumber('1234567890');
AppFormatter.formatCurrency(1234.56, symbol: '\$');
AppFormatter.capitalize('hello world');

// ❌ NEVER create custom formatters
String formatDate(DateTime date) { ... }  // Don't do this
```

### 8. Form Validation (AppValidator)
```dart
// ✅ ALWAYS use AppValidator
import 'package:project_template/core/utils/validators/app_validator.dart';

CustomTextField(
  validator: AppValidator.validateEmail,
  // ...
)

// ❌ NEVER inline validation logic
validator: (value) => value!.contains('@') ? null : 'Invalid';
```

### 9. Logging (LoggerService)
```dart
// ✅ ALWAYS use LoggerService
import 'package:project_template/core/services/logger_service.dart';

LoggerService.info('Operation successful');
LoggerService.error('Failed', error: exception);
LoggerService.debug('Debug info: $data');

// ❌ NEVER use print or debugPrint
print('Debug message');
```

### 10. Color Opacity
```dart
// ✅ Use withValues
Color.withValues(alpha: 0.5)

// ❌ NEVER use deprecated withOpacity
Color.withOpacity(0.5)
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

---

## 🏗 Project Architecture

### MVC + Repository Pattern

```
View       → UI only (Stateless widgets)
Controller → Business logic + State management
Repository → API calls + Data operations
Model      → Data classes
```

### Directory Structure

```
lib/
├── core/                           # Shared utilities & services
│   ├── bindings/                   # GetX dependency injection
│   │   └── initial_binding.dart    # Register ALL controllers here
│   ├── common/
│   │   ├── styles/                 # Global text styles
│   │   └── widgets/                # Reusable UI components
│   │       ├── buttons/            # CustomButton
│   │       ├── text_fields/        # CustomTextField
│   │       ├── loaders/            # AppCircularLoader
│   │       ├── shimmers/           # AppShimmerEffect
│   │       ├── states/             # EmptyStateWidget, ErrorDisplayWidget
│   │       └── popups/             # AppSnackBar
│   ├── localization/               # Multi-language support
│   │   ├── languages.dart
│   │   ├── language_controller.dart
│   │   ├── app_string_localizations.dart
│   │   └── languages/
│   │       ├── en_us.dart
│   │       └── bn_bd.dart
│   ├── services/                   # Singleton services
│   │   ├── local_storage_service.dart
│   │   └── logger_service.dart
│   └── utils/
│       ├── constants/              # AppColors, AppSizes, ApiEndpoints
│       ├── device/                 # AppDeviceUtils
│       ├── formatters/             # AppFormatter
│       ├── helpers/                # AppHelper, SvgIconHelper
│       ├── http/                   # HttpService
│       ├── manager/                # NetworkManager
│       ├── theme/                  # AppTheme (light/dark)
│       └── validators/             # AppValidator
├── data/
│   ├── models/                     # Data models
│   └── repositories/               # Data access layer
├── features/
│   └── [feature_name]/
│       ├── controllers/            # Business logic
│       ├── models/                 # Feature-specific models
│       └── views/
│           ├── screens/            # Full-page widgets
│           └── widgets/            # Feature-specific widgets
└── routes/
    ├── app_routes.dart             # Route constants
    └── app_pages.dart              # Route mappings
```

### Controller Setup Pattern

**1. Create Controller:**
```dart
// lib/features/home/controllers/home_controller.dart
class HomeController extends GetxController {
  static HomeController get instance => Get.find();  // MANDATORY
  
  final HomeRepository _repository = HomeRepository();
  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }
  
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: AppStrings.loading);
      
      final userData = await _repository.fetchUsers();
      users.assignAll(userData);
      
      EasyLoading.dismiss();
    } catch (error) {
      LoggerService.error('Load users failed', error: error);
      AppSnackBar.errorSnackBar(
        title: AppStrings.error,
        message: AppStrings.failedToLoadUsers,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
```

**2. Register in InitialBinding:**
```dart
// lib/core/bindings/initial_binding.dart
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    // Register ALL controllers here
  }
}
```

**3. Use in Widget:**
```dart
// lib/features/home/views/screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;  // Use instance pattern
    
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.home),
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppCircularLoader();
        }
        return ListView.builder(...);
      }),
    );
  }
}
```

### Repository Pattern

```dart
// lib/data/repositories/home/home_repository.dart
class HomeRepository {
  Future<List<User>> fetchUsers() async {
    try {
      final response = await HttpService.get<List<User>>(
        ApiEndpoints.users,
        fromJson: (json) => (json as List)
            .map((item) => User.fromJson(item))
            .toList(),
      );
      
      if (response.isSuccess) {
        return response.data!;
      } else {
        throw Exception(response.error?.message ?? 'Failed to load users');
      }
    } catch (error) {
      LoggerService.error('API call failed', error: error);
      rethrow;
    }
  }
}
```

### Navigation Setup

**1. Define Routes:**
```dart
// lib/routes/app_routes.dart
class AppRoute {
  static const String home = '/home';
  static const String profile = '/profile';
  
  static String getHomeScreen() => home;
  static String getProfileScreen() => profile;
}
```

**2. Map Routes to Pages:**
```dart
// lib/routes/app_pages.dart
class AppPages {
  static final pages = [
    GetPage(name: AppRoute.home, page: () => const HomeScreen()),
    GetPage(name: AppRoute.profile, page: () => const ProfileScreen()),
  ];
}
```

---

## 🔧 Core Components Reference

### Reusable Widgets (lib/core/common/widgets/)

#### CustomButton
```dart
// lib/core/common/widgets/buttons/custom_button.dart
CustomButton(
  text: AppStrings.submit,
  onPressed: controller.submit,
  type: ButtonType.primary,      // primary, secondary, text
  isLoading: controller.isLoading.value,
  icon: Iconsax.add,
)
```

#### CustomTextField
```dart
// lib/core/common/widgets/text_fields/custom_text_field.dart
CustomTextField(
  labelText: AppStrings.email,
  hintText: AppStrings.enterEmail,
  controller: controller.emailController,
  keyboardType: TextInputType.emailAddress,
  validator: AppValidator.validateEmail,
  obscureText: true,  // Auto-adds visibility toggle for passwords
)
```

#### AppCircularLoader
```dart
// lib/core/common/widgets/loaders/circular_loader.dart
AppCircularLoader(size: 60)  // Full-screen loading
AppCircularLoader(size: 30)  // Inline loading
```

#### AppShimmerEffect
```dart
// lib/core/common/widgets/shimmers/shimmer.dart
AppShimmerEffect(
  width: double.infinity,
  height: 80.h,
  radius: 12,
)
```

#### EmptyStateWidget
```dart
// lib/core/common/widgets/states/empty_state_widget.dart
EmptyStateWidget(
  icon: Iconsax.inbox,
  title: AppStrings.noData,
  subtitle: AppStrings.noDataDescription,
  actionText: AppStrings.refresh,
  onActionPressed: controller.refresh,
)
```

#### ErrorDisplayWidget
```dart
// lib/core/common/widgets/states/error_display_widget.dart
ErrorDisplayWidget(
  icon: Iconsax.warning_2,
  title: AppStrings.error,
  message: AppStrings.errorMessage,
  actionText: AppStrings.retry,
  onActionPressed: controller.retry,
)
```

### Services (lib/core/services/)

#### LocalStorageService
```dart
// lib/core/services/local_storage_service.dart
final storage = LocalStorageService();

// Save data
await storage.saveData('key', 'value');
await storage.saveSecure('token', authToken);

// Read data
final value = storage.readData<String>('key');
final token = await storage.readSecure('token');

// Remove data
await storage.removeData('key');
await storage.clearAll();
```

#### LoggerService
```dart
// lib/core/services/logger_service.dart
LoggerService.info('User logged in');
LoggerService.error('API failed', error: exception);
LoggerService.debug('Debug: $data');
LoggerService.warning('Warning message');
```

### Utilities (lib/core/utils/)

#### AppColors (constants/colors.dart)
```dart
AppColors.primary
AppColors.secondary
AppColors.textPrimary
AppColors.textSecondary
AppColors.error
AppColors.success
AppColors.warning
```

#### AppFormatter (formatters/formatters.dart)
```dart
// Date & Time
AppFormatter.formatDate(DateTime.now(), format: 'dd MMM yyyy');
AppFormatter.formatTime(DateTime.now(), format: 'HH:mm');

// Strings
AppFormatter.capitalize('hello');
AppFormatter.capitalizeWords('hello world');
AppFormatter.truncateText(longText, 50);

// Numbers
AppFormatter.formatNumber(1234567);
AppFormatter.formatCurrency(1234.56, symbol: '\$');
AppFormatter.formatPercentage(0.75);
AppFormatter.formatFileSize(1048576);

// Validation
AppFormatter.isValidEmail('test@example.com');
AppFormatter.isValidPhone('+1234567890');
AppFormatter.isValidUrl('https://example.com');
```

#### AppValidator (validators/app_validator.dart)
```dart
AppValidator.validateEmail(value);
AppValidator.validatePassword(value);
AppValidator.validatePhone(value);
AppValidator.validateFullName(value);
AppValidator.validateRequired(value, fieldName: 'Email');
```

#### AppDeviceUtils (device/device_utility.dart)
```dart
AppDeviceUtils.hideKeyboard(context);
AppDeviceUtils.isAndroid();
AppDeviceUtils.isIOS();
AppDeviceUtils.getScreenHeight();
AppDeviceUtils.getScreenWidth(context);
await AppDeviceUtils.hasInternetConnection();
AppDeviceUtils.launchUrl('https://example.com');
AppDeviceUtils.vibrate(Duration(milliseconds: 100));
```

#### AppHelper (helpers/app_helper.dart)
```dart
AppHelperFunctions.showSnackBar(AppStrings.message);
AppHelperFunctions.showAlert(AppStrings.title, AppStrings.message);
final isDark = AppHelperFunctions.isDarkMode(context);
final size = AppHelperFunctions.screenSize();
AppHelperFunctions.truncateText(text, 50);
AppHelperFunctions.getFormattedDate(DateTime.now());
```

#### NetworkManager (manager/network_manager.dart)
```dart
final networkManager = NetworkManager.instance;

if (!await networkManager.isConnected()) {
  AppSnackBar.errorSnackBar(
    title: AppStrings.error,
    message: AppStrings.noInternet,
  );
  return;
}
```

### Theme System (lib/core/utils/theme/)

#### Text Styles (common/styles/global_text_style.dart)
```dart
// Normal text
getTextStyle(fontSize: 14, color: AppColors.textPrimary)

// Bold text
getBoldTextStyle(fontSize: 16, fontWeight: FontWeight.w700)

// Heading
getHeadingStyle(fontSize: 24, color: AppColors.dark)

// Subheading
getSubHeadingStyle(fontSize: 16, lineHeight: 1.5)

// Label
getLabelTextStyle(fontSize: 14, color: AppColors.textSecondary)
```

#### App Theme (theme/theme.dart)
```dart
// Light and dark themes configured
AppTheme.lightTheme
AppTheme.darkTheme

// Custom themes in theme/custom_themes/
- appbar_theme.dart
- elevated_button_theme.dart
- outlined_button_theme.dart
- text_field_theme.dart
- text_theme.dart
```

---

## 📐 Development Standards

### Code Quality

#### Naming Conventions
- **Variables/Methods**: `camelCase` (e.g., `userEmailController`, `fetchUserData`)
- **Classes/Widgets**: `PascalCase` (e.g., `HomeController`, `UserCard`)
- **Constants**: `camelCase` in classes (e.g., `AppColors.primary`, `AppStrings.welcome`)

#### File Naming
- **Screens**: `home_screen.dart`
- **Widgets**: `user_card_widget.dart`
- **Controllers**: `home_controller.dart`
- **Repositories**: `home_repository.dart`
- **Models**: `user_model.dart`

#### Documentation
```dart
/// Fetches user data from API
/// 
/// [userId] - The unique identifier of the user
/// Returns [User] object or throws exception
/// 
/// Example:
/// ```dart
/// final user = await fetchUser('123');
/// ```
Future<User> fetchUser(String userId) async { ... }
```

### Widget Best Practices

#### Extract Reusable Widgets
```dart
// ❌ Don't repeat UI code
Column(
  children: [
    Row(children: [Icon(...), Text(...)]),
    Row(children: [Icon(...), Text(...)]),
    Row(children: [Icon(...), Text(...)]),
  ],
)

// ✅ Extract to reusable widget
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(text, style: getTextStyle(fontSize: 14)),
      ],
    );
  }
}
```

#### Use ListView Over SingleChildScrollView + Column
```dart
// ✅ Preferred
ListView(
  children: [widget1, widget2, widget3],
)

// ❌ Avoid
SingleChildScrollView(
  child: Column(
    children: [widget1, widget2, widget3],
  ),
)
```

#### Keep Methods Short
```dart
// ✅ Good - clear and concise
Future<void> loadUsers() async {
  if (isLoading.value) return;  // Early return
  
  isLoading.value = true;
  try {
    final users = await _repository.fetchUsers();
    this.users.assignAll(users);
  } catch (error) {
    _handleError(error);
  } finally {
    isLoading.value = false;
  }
}

// ❌ Avoid - too long and nested
Future<void> loadUsers() async {
  if (!isLoading.value) {
    isLoading.value = true;
    try {
      // 50 lines of code...
    } catch (error) {
      // Complex error handling...
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Multi-Language Setup

#### Adding New Strings

**1. Add to all language files:**
```dart
// lib/core/localization/languages/en_us.dart
'login_button': 'Login',
'email_validation_error': 'Please enter a valid email',

// lib/core/localization/languages/bn_bd.dart
'login_button': 'লগইন',
'email_validation_error': 'একটি বৈধ ইমেইল লিখুন',
```

**2. Add getter to AppStrings:**
```dart
// lib/core/localization/app_string_localizations.dart
static String get loginButton => 'login_button'.tr;
static String get emailValidationError => 'email_validation_error'.tr;
```

**3. Use in code:**
```dart
CustomButton(text: AppStrings.loginButton, onPressed: login);
```

### API Integration

#### Complete Flow Example
```dart
// 1. Model (data/models/user_model.dart)
class User {
  final String id;
  final String name;
  final String email;
  
  const User({required this.id, required this.name, required this.email});
  
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

// 2. Repository (data/repositories/user/user_repository.dart)
class UserRepository {
  Future<List<User>> getUsers() async {
    final response = await HttpService.get<List<User>>(
      ApiEndpoints.users,
      fromJson: (json) => (json as List)
          .map((item) => User.fromJson(item))
          .toList(),
    );
    
    if (response.isSuccess) {
      return response.data!;
    } else {
      throw Exception(response.error?.message ?? 'Failed to load users');
    }
  }
  
  Future<User> createUser(User user) async {
    final response = await HttpService.post<User>(
      ApiEndpoints.users,
      data: user.toJson(),
      fromJson: (json) => User.fromJson(json),
    );
    
    if (response.isSuccess) {
      return response.data!;
    } else {
      throw Exception(response.error?.message ?? 'Failed to create user');
    }
  }
}

// 3. Controller (features/user/controllers/user_controller.dart)
class UserController extends GetxController {
  static UserController get instance => Get.find();
  
  final UserRepository _repository = UserRepository();
  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }
  
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: AppStrings.loading);
      
      final userList = await _repository.getUsers();
      users.assignAll(userList);
      
      EasyLoading.dismiss();
    } catch (error) {
      LoggerService.error('Load users failed', error: error);
      AppSnackBar.errorSnackBar(
        title: AppStrings.error,
        message: AppStrings.failedToLoadUsers,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> createUser(User user) async {
    try {
      EasyLoading.show(status: AppStrings.saving);
      
      final newUser = await _repository.createUser(user);
      users.add(newUser);
      
      AppSnackBar.successSnackBar(
        title: AppStrings.success,
        message: AppStrings.userCreatedSuccessfully,
      );
      EasyLoading.dismiss();
    } catch (error) {
      LoggerService.error('Create user failed', error: error);
      AppSnackBar.errorSnackBar(
        title: AppStrings.error,
        message: AppStrings.failedToCreateUser,
      );
      EasyLoading.dismiss();
    }
  }
}

// 4. View (features/user/views/screens/user_list_screen.dart)
class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.users),
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
        if (controller.users.isEmpty) {
          return EmptyStateWidget(
            icon: Iconsax.user,
            title: AppStrings.noUsers,
            subtitle: AppStrings.noUsersDescription,
          );
        }
        
        // Data list
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return UserCard(user: user);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoute.createUser),
        child: Icon(Iconsax.add),
      ),
    );
  }
}
```

---

## 🎯 Common Patterns & Anti-Patterns

### ✅ CORRECT Patterns

#### Form Screen
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = AuthController.instance;
    
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.login),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
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
                text: AppStrings.login,
                onPressed: controller.login,
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

#### List with Pull-to-Refresh
```dart
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.products),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return _buildShimmer();
        }
        
        if (controller.products.isEmpty) {
          return EmptyStateWidget(
            icon: Iconsax.box,
            title: AppStrings.noProducts,
            subtitle: AppStrings.noProductsDescription,
          );
        }
        
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: controller.products[index]);
            },
          ),
        );
      }),
    );
  }
  
  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) => AppShimmerEffect(
        width: double.infinity,
        height: 120.h,
      ),
    );
  }
}
```

### ❌ ANTI-PATTERNS (Avoid These)

#### 1. Hardcoded Text
```dart
// ❌ Wrong
Text('Login')
EasyLoading.show(status: 'Loading...');
AppBar(title: Text('Settings'))

// ✅ Correct
Text(AppStrings.login)
EasyLoading.show(status: AppStrings.loading);
CustomAppBar(title: AppStrings.settings)
```

#### 2. Wrong Controller Access
```dart
// ❌ Wrong
final controller = Get.find<MyController>();
final controller = Get.put(MyController());

// ✅ Correct
final controller = MyController.instance;
```

#### 3. Using EasyLoading for Messages
```dart
// ❌ Wrong
EasyLoading.showSuccess('Success!');
EasyLoading.showError('Failed');
EasyLoading.showInfo('Information');

// ✅ Correct
AppSnackBar.successSnackBar(title: AppStrings.success, message: AppStrings.done);
AppSnackBar.errorSnackBar(title: AppStrings.error, message: AppStrings.failed);
AppSnackBar.showInfoSnackBar(title: AppStrings.info, message: AppStrings.info);
```

#### 4. Using Material Icons
```dart
// ❌ Wrong
Icon(Icons.home)
Icon(Icons.person)

// ✅ Correct
Icon(Iconsax.home)
Icon(Iconsax.user)
```

#### 5. Business Logic in UI
```dart
// ❌ Wrong
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    fetchUserData();  // Don't call business logic here
    return Scaffold(...);
  }
}

// ✅ Correct - Logic in controller, called in onInit
class MyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }
}
```

#### 6. Creating Custom Widgets for Existing Components
```dart
// ❌ Wrong
Widget _buildButton() {
  return Container(
    decoration: BoxDecoration(...),
    child: TextButton(...),
  );
}

// ✅ Correct
CustomButton(
  text: AppStrings.submit,
  onPressed: onPressed,
)
```

#### 7. Hardcoded Colors and Sizes
```dart
// ❌ Wrong
Container(
  color: Color(0xFF4B68FF),
  width: 200,
  height: 100,
)

// ✅ Correct
Container(
  color: AppColors.primary,
  width: 200.w,
  height: 100.h,
)
```

#### 8. Deep Nested Widgets
```dart
// ❌ Wrong - Hard to read
Column(
  children: [
    Container(
      child: Row(
        children: [
          Container(
            child: Column(
              children: [
                Text(...),
                Container(...),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
)

// ✅ Correct - Extract to widgets
Column(
  children: [
    HeaderSection(),
    ContentSection(),
    FooterSection(),
  ],
)
```

---

## 🚀 Quick Reference Guide

### Before You Start Coding

**Checklist:**
- [ ] Check if reusable widget exists in `lib/core/common/widgets/`
- [ ] Check if utility function exists (AppFormatter, AppHelper, AppDeviceUtils)
- [ ] Check if validation exists in AppValidator
- [ ] Check AppStrings for text constants
- [ ] Check AppColors for colors

### When Creating a New Feature

1. **Create feature folder**: `lib/features/[feature_name]/`
2. **Create controller**: Add `static instance` getter
3. **Register controller**: In `lib/core/bindings/initial_binding.dart`
4. **Create repository**: For API/data operations
5. **Create models**: With `fromJson` and `toJson`
6. **Create views**: Use existing reusable widgets
7. **Add routes**: In `app_routes.dart` and `app_pages.dart`
8. **Add strings**: To all language files
9. **Test**: Both languages, loading states, error states

### Common Workflows

#### Show Loading → Fetch Data → Show Result
```dart
Future<void> fetchData() async {
  try {
    isLoading.value = true;
    EasyLoading.show(status: AppStrings.loading);
    
    final data = await _repository.getData();
    this.data.assignAll(data);
    
    EasyLoading.dismiss();
  } catch (error) {
    LoggerService.error('Fetch failed', error: error);
    AppSnackBar.errorSnackBar(
      title: AppStrings.error,
      message: AppStrings.failedToLoad,
    );
  } finally {
    isLoading.value = false;
  }
}
```

#### Form Validation → Submit
```dart
Future<void> submit() async {
  if (!formKey.currentState!.validate()) return;
  
  try {
    EasyLoading.show(status: AppStrings.saving);
    
    await _repository.saveData(data);
    
    AppSnackBar.successSnackBar(
      title: AppStrings.success,
      message: AppStrings.savedSuccessfully,
    );
    
    Get.back();
  } catch (error) {
    LoggerService.error('Submit failed', error: error);
    AppSnackBar.errorSnackBar(
      title: AppStrings.error,
      message: AppStrings.failedToSave,
    );
  } finally {
    EasyLoading.dismiss();
  }
}
```

### File Import Quick Reference

```dart
// Controllers (instance pattern)
final controller = MyController.instance;

// Reusable Widgets
import 'package:project_template/core/common/widgets/buttons/custom_button.dart';
import 'package:project_template/core/common/widgets/text_fields/custom_text_field.dart';
import 'package:project_template/core/common/widgets/loaders/circular_loader.dart';
import 'package:project_template/core/common/widgets/shimmers/shimmer.dart';
import 'package:project_template/core/common/widgets/states/empty_state_widget.dart';
import 'package:project_template/core/common/widgets/popups/custom_snackbar.dart';

// Services
import 'package:project_template/core/services/local_storage_service.dart';
import 'package:project_template/core/services/logger_service.dart';

// Utilities
import 'package:project_template/core/utils/constants/colors.dart';
import 'package:project_template/core/utils/constants/sizes.dart';
import 'package:project_template/core/utils/formatters/formatters.dart';
import 'package:project_template/core/utils/validators/app_validator.dart';
import 'package:project_template/core/utils/helpers/app_helper.dart';
import 'package:project_template/core/utils/helpers/svg_icon_helper.dart';
import 'package:project_template/core/utils/device/device_utility.dart';

// Localization
import 'package:project_template/core/localization/app_string_localizations.dart';

// Icons
import 'package:iconsax/iconsax.dart';

// ScreenUtil
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

### Documentation Requirements

**When to Document:**
- Complex multi-file features
- Custom animations or interactions
- New patterns or architectural decisions
- API integrations
- State management implementations

**Create in**: `notes/[feature_name]/NOTE_NAME.md`

**Template:**
```markdown
# [Feature Name]

## Overview
Brief description of what this feature does.

## Architecture
Explain the MVC pattern used.

## Files Created
- `lib/features/[feature]/controllers/[feature]_controller.dart`
- `lib/features/[feature]/views/screens/[feature]_screen.dart`
- etc.

## Implementation Steps
1. Step one
2. Step two
3. Step three

## Code Examples
```dart
// Example code
```

## Common Issues & Solutions
- Issue 1: Solution
- Issue 2: Solution

## Testing
How to test this feature.
```

---

## 🎓 Agent Learning Summary

**When creating UI:**
1. Use existing widgets from `lib/core/common/widgets/`
2. Use AppColors and text style helpers
3. Apply ScreenUtil extensions (.w, .h, .r)
4. Use AppStrings for all text
5. Use Iconsax icons or SvgIconHelper

**When adding logic:**
1. Create controller with `static instance` getter
2. Register in `initial_binding.dart`
3. Use `ControllerName.instance` in views
4. Create repository for data operations
5. Use EasyLoading.show() for loading only
6. Use AppSnackBar for user feedback
7. Log errors with LoggerService

**When formatting data:**
1. Use AppFormatter methods
2. Never create custom formatters
3. Add new formatters to central file

**When validating:**
1. Use AppValidator methods
2. Never inline validation logic

**Always remember:**
- 🌍 Multi-language: AppStrings (CRITICAL)
- 🎨 Theming: AppColors + text helpers
- 📱 Responsive: ScreenUtil (.w, .h, .r)
- 🔧 Reusable: Check core widgets first
- 🏗️ Architecture: View → Controller → Repository
- 🎯 Controllers: Instance pattern everywhere
- ⏳ Loading: EasyLoading.show() only
- 💬 Feedback: AppSnackBar always
- 🎨 Icons: Iconsax or SvgIconHelper
- 📝 Formatting: AppFormatter
- ✅ Validation: AppValidator

---

**End of Instructions** | This document is comprehensive and non-redundant. Follow strictly for consistent, high-quality code.
