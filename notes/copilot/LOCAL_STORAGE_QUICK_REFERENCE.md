# 🗄️ LOCAL STORAGE SERVICE - QUICK REFERENCE

## ⚡ Quick Start

```dart
import 'package:project_template/core/services/local_storage_service.dart';

// Initialize once during app startup
await LocalStorageService.init();

// Use throughout app
```

---

## 🎯 Common Patterns

### Authentication
```dart
// Login - Save tokens
await LocalStorageService.setAccessToken(accessToken);
await LocalStorageService.setRefreshToken(refreshToken);
LocalStorageService.setUserData(userData);

// Logout - Clear data
await LocalStorageService.clearTokens();
LocalStorageService.clearUserData();

// Check login status
final token = await LocalStorageService.getAccessToken();
if (token != null) {
  // User is logged in
}
```

### Theme Management
```dart
// Save theme preference
LocalStorageService.setThemeMode(ThemeMode.dark);

// Restore on app startup
final theme = LocalStorageService.getThemeMode();
```

### Multi-Language
```dart
// Save language
LocalStorageService.setLocale(Locale('bn', 'BD'));

// Restore on app startup
final locale = LocalStorageService.getLocale();
```

### Custom Data
```dart
// Any data type
LocalStorageService.write('key', 'value');
LocalStorageService.write('count', 42);
LocalStorageService.write('data', {'nested': 'map'});

// Retrieve with type safety
final value = LocalStorageService.read<String>('key');
final count = LocalStorageService.read<int>('count');
final data = LocalStorageService.read<Map>('data');

// Check existence
if (LocalStorageService.hasData('key')) {
  print('Key exists!');
}

// Delete
LocalStorageService.remove('key');
```

### Onboarding
```dart
// Check if first time
if (LocalStorageService.isFirstTime()) {
  navigateToOnboarding();
}

// After onboarding complete
LocalStorageService.setNotFirstTime();
```

---

## 📋 All Methods

### Initialization
| Method | Purpose |
|--------|---------|
| `init()` | Initialize service (async) |
| `dispose()` | Cleanup service |

### Theme (2 methods)
| Method | Purpose |
|--------|---------|
| `setThemeMode(ThemeMode)` | Save theme |
| `getThemeMode()` | Get theme |

### Locale (2 methods)
| Method | Purpose |
|--------|---------|
| `setLocale(Locale)` | Save locale |
| `getLocale()` | Get locale |

### First Time (2 methods)
| Method | Purpose |
|--------|---------|
| `isFirstTime()` | Check first launch |
| `setNotFirstTime()` | Mark not first time |

### Tokens (5 methods) - 🔐 SECURE
| Method | Purpose |
|--------|---------|
| `setAccessToken(String)` | Save access token |
| `getAccessToken()` | Get access token |
| `setRefreshToken(String)` | Save refresh token |
| `getRefreshToken()` | Get refresh token |
| `clearTokens()` | Clear all tokens |

### User Data (3 methods)
| Method | Purpose |
|--------|---------|
| `setUserData(Map)` | Save user profile |
| `getUserData()` | Get user profile |
| `clearUserData()` | Clear user data |

### Generic (5 methods)
| Method | Purpose |
|--------|---------|
| `write(key, value)` | Save any data |
| `read<T>(key)` | Get any data |
| `remove(key)` | Delete data |
| `hasData(key)` | Check existence |
| `clearAll()` | Delete everything |

---

## 🔐 Secure vs Regular Storage

### 🔒 Encrypted (FlutterSecureStorage)
- Access tokens
- Refresh tokens

### 📝 Regular (GetStorage)
- Theme mode
- Locale
- User data
- Custom data
- Preferences

---

## ✅ Error Handling

All methods include try-catch with automatic logging:

```dart
// Methods don't throw - they handle errors gracefully
LocalStorageService.write('key', value);  // No need to wrap in try-catch

// Errors are logged automatically with LoggerService
// 💾 Data saved with key: key
// ❌ Failed to save data with key: key
```

---

## 💾 Storage Location

### GetStorage (Regular Data)
- Android: Internal storage
- iOS: Documents directory
- Web: LocalStorage

### FlutterSecureStorage (Tokens)
- Android: EncryptedSharedPreferences
- iOS: Keychain
- Web: LocalStorage (encrypted)

---

## 📌 Key Points

✅ **Single source of truth** - All storage goes through one service
✅ **Type-safe** - Generic <T> methods
✅ **Secure** - Tokens encrypted automatically
✅ **Logged** - All operations logged
✅ **Error-safe** - Graceful error handling
✅ **Async-safe** - Proper async/await
✅ **Easy to use** - Intuitive method names
✅ **Well documented** - 50+ examples

---

## 🚫 DON'Ts

❌ Don't call init() multiple times
❌ Don't store passwords (use tokens)
❌ Don't forget await on async methods
❌ Don't store large objects (use database)
❌ Don't access before init()
❌ Don't use for sensitive data other than tokens

---

## 🎓 Learning Path

1. **Start** → Call `init()` in main.dart
2. **Learn** → Use setThemeMode/getThemeMode
3. **Practice** → Implement login/logout with tokens
4. **Master** → Use generic write/read for custom data

---

## 📞 Quick Help

**Q: How to save tokens?**
A: `await LocalStorageService.setAccessToken(token);`

**Q: How to check if logged in?**
A: `final token = await LocalStorageService.getAccessToken();`

**Q: How to logout?**
A: `await LocalStorageService.clearTokens();`

**Q: How to save custom data?**
A: `LocalStorageService.write('key', value);`

**Q: How to get custom data?**
A: `final value = LocalStorageService.read<Type>('key');`

**Q: Are tokens secure?**
A: Yes! FlutterSecureStorage uses platform-specific encryption.

**Q: Do I need to catch errors?**
A: No! Errors are handled gracefully with logging.

**Q: What if init() fails?**
A: The error is logged but app continues (safe fallbacks).

---

**That's it! You're ready to use LocalStorageService!** 🚀
