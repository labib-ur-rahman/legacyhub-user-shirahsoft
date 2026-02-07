# User & Authentication Functions

## 🌏 Region: `asia-south1` (Mumbai, India)

All functions require the region to be specified in Flutter:
```dart
final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
```

---

## Flutter Examples

### `createUser`
**Type:** Callable  
**Auth Required:** No (creates new user)

```dart
/// Create a new user with email/password and invite code
Future<Map<String, dynamic>> createUser({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String phone,
  required String inviteCode,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('createUser').call({
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,         // Format: 01XXXXXXXXX
    'inviteCode': inviteCode, // Format: SA7K9Q2L (8 chars)
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "User created successfully",
  //   "data": {
  //     "uid": "abc123...",
  //     "inviteCode": "SB8M3N4L"  // New user's invite code
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `completeGoogleSignIn`
**Type:** Callable  
**Auth Required:** Yes (user must be signed in with Google first)

```dart
/// Complete Google Sign-in with invite code
/// Called after GoogleSignIn().signIn() is successful
Future<Map<String, dynamic>> completeGoogleSignIn({
  required String inviteCode,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('completeGoogleSignIn').call({
    'inviteCode': inviteCode,
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Google sign-in completed",
  //   "data": {
  //     "uid": "abc123...",
  //     "inviteCode": "SB8M3N4L"
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `getUserProfile`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Get current user's profile
Future<Map<String, dynamic>> getUserProfile() async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getUserProfile').call();
  
  // Response contains full UserDocument:
  // {
  //   "success": true,
  //   "message": "User profile retrieved",
  //   "data": {
  //     "uid": "...",
  //     "role": "user",
  //     "identity": { "firstName": "...", "lastName": "...", ... },
  //     "status": { "verified": false, "subscription": "none", ... },
  //     "wallet": { "balanceBDT": 0, "rewardPoints": 0, "locked": false },
  //     "permissions": { "canPost": false, "canWithdraw": false, ... },
  //     ...
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `updateUserProfile`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Update user profile fields
Future<Map<String, dynamic>> updateUserProfile({
  String? firstName,
  String? lastName,
  String? phone,
  String? photoURL,
  String? coverURL,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final data = <String, dynamic>{};
  if (firstName != null) data['firstName'] = firstName;
  if (lastName != null) data['lastName'] = lastName;
  if (phone != null) data['phone'] = phone;
  if (photoURL != null) data['photoURL'] = photoURL;
  if (coverURL != null) data['coverURL'] = coverURL;
  
  final result = await functions.httpsCallable('updateUserProfile').call(data);
  
  // Response:
  // { "success": true, "message": "Profile updated successfully" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `verifyUserProfile`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Verify user profile after verification payment (৳250)
Future<Map<String, dynamic>> verifyUserProfile({
  required String paymentReference,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('verifyUserProfile').call({
    'paymentReference': paymentReference,
  });
  
  // Effects:
  // - Sets verified: true
  // - Enables canPost and canWithdraw permissions
  // - Distributes verification rewards to 5 upline levels
  // - Increments verified count in network stats
  
  // Response:
  // { "success": true, "message": "Profile verified successfully" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `subscribeUser`
**Type:** Callable  
**Auth Required:** Yes

```dart
/// Subscribe user after subscription payment (৳400)
Future<Map<String, dynamic>> subscribeUser({
  required String paymentReference,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('subscribeUser').call({
    'paymentReference': paymentReference,
  });
  
  // Effects:
  // - Sets subscription: active
  // - Also verifies if not already verified
  // - Distributes subscription rewards to 15 upline levels
  // - Increments subscribed count in network stats
  
  // Response:
  // { "success": true, "message": "Subscription activated successfully" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `checkAuthStatus`
**Type:** Callable  
**Auth Required:** No

```dart
/// Check authentication status
Future<Map<String, dynamic>> checkAuthStatus() async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('checkAuthStatus').call();
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Auth status checked",
  //   "data": {
  //     "authenticated": true,
  //     "uid": "abc123...",
  //     "hasProfile": true,
  //     "profileComplete": true
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

## Auth Triggers (Internal - Not called from Flutter)

### `onUserLogin`
**Type:** beforeSignIn trigger  
**Location:** `asia-south1`  
**Description:** Updates user's `lastLoginAt` and `lastActiveAt` timestamps on every login.

### `onUserDeleted`
**Type:** onDelete trigger  
**Location:** `asia-south1`  
**Description:** Soft-deletes user document when Firebase Auth user is deleted.
- Sets `status.accountState` to `deleted`
- Creates audit log entry
- Does NOT delete user data (soft delete for data integrity)

---

## Error Handling Example

```dart
Future<void> handleCreateUser() async {
  try {
    final result = await createUser(
      email: 'user@example.com',
      password: 'securePassword123',
      firstName: 'John',
      lastName: 'Doe',
      phone: '01712345678',
      inviteCode: 'SA7K9Q2L',
    );
    
    if (result['success'] == true) {
      final uid = result['data']['uid'];
      final newInviteCode = result['data']['inviteCode'];
      // Navigate to home screen
    }
  } on FirebaseFunctionsException catch (e) {
    switch (e.code) {
      case 'not-found':
        // Invalid invite code
        showError('Invalid invite code');
        break;
      case 'already-exists':
        // Email already registered
        showError('Email already exists');
        break;
      case 'invalid-argument':
        // Missing or invalid fields
        showError(e.message ?? 'Invalid data');
        break;
      default:
        showError('Registration failed');
    }
  }
}
```
