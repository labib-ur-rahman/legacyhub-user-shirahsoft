# Admin & RBAC Functions

## 🌏 Region: `asia-south1` (Mumbai, India)

All functions require the region to be specified in Flutter:
```dart
final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
```

---

## Permission Functions

### `getMyPermissions`
**Type:** Callable  
**Auth Required:** Yes  
**Role Required:** Any (works for all authenticated users)

```dart
/// Get current user's permissions
Future<Map<String, dynamic>> getMyPermissions() async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getMyPermissions').call();
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Permissions retrieved",
  //   "data": {
  //     "role": "admin",
  //     "permissions": {
  //       "user.suspend": true,
  //       "user.ban": true,
  //       "wallet.credit": true,
  //       ...
  //     },
  //     "isSuperAdmin": false
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `getUserPermissions`
**Type:** Callable  
**Auth Required:** Yes  
**Role Required:** Support+ (support, moderator, admin, superAdmin)

```dart
/// Get another user's permissions (admin view)
Future<Map<String, dynamic>> getUserPermissions({
  required String targetUid,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getUserPermissions').call({
    'targetUid': targetUid,
  });
  
  // Response:
  // {
  //   "success": true,
  //   "message": "Permissions retrieved",
  //   "data": {
  //     "role": "moderator",
  //     "permissions": {
  //       "user.view": true,
  //       "user.suspend": false,
  //       ...
  //     }
  //   }
  // }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `grantUserPermissions`
**Type:** Callable  
**Auth Required:** Yes  
**Role Required:** Admin+ (admin, superAdmin)  
**Permission Required:** `permission.grant` (non-superAdmin)

```dart
/// Grant permissions to a user
Future<Map<String, dynamic>> grantUserPermissions({
  required String targetUid,
  required List<String> permissions,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('grantUserPermissions').call({
    'targetUid': targetUid,
    'permissions': permissions,
    // Example permissions:
    // ['user.view', 'user.suspend', 'withdraw.review', 'withdraw.approve']
  });
  
  // Response:
  // { "success": true, "message": "Granted 4 permissions to user" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `revokeUserPermissions`
**Type:** Callable  
**Auth Required:** Yes  
**Role Required:** Admin+ (admin, superAdmin)  
**Permission Required:** `permission.revoke` (non-superAdmin)

```dart
/// Revoke permissions from a user
Future<Map<String, dynamic>> revokeUserPermissions({
  required String targetUid,
  required List<String> permissions,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('revokeUserPermissions').call({
    'targetUid': targetUid,
    'permissions': permissions,
  });
  
  // Response:
  // { "success": true, "message": "Revoked 2 permissions from user" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `changeUserRole`
**Type:** Callable  
**Auth Required:** Yes  
**Role Required:** Admin+ (admin, superAdmin)  
**Restrictions:** Cannot change own role, cannot promote to equal/higher role

```dart
/// Change a user's role
Future<Map<String, dynamic>> changeUserRole({
  required String targetUid,
  required String newRole, // 'user', 'support', 'moderator', 'admin', 'superAdmin'
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('changeUserRole').call({
    'targetUid': targetUid,
    'newRole': newRole,
  });
  
  // Response:
  // { "success": true, "message": "User role changed from user to moderator" }
  return Map<String, dynamic>.from(result.data);
}
```

---

## Admin User Management Functions

### `suspendUser`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `user.suspend`

```dart
/// Suspend a user account
Future<Map<String, dynamic>> suspendUser({
  required String targetUid,
  required String reason,
  String? suspendUntil, // ISO date string, optional
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final data = {
    'targetUid': targetUid,
    'reason': reason,
  };
  if (suspendUntil != null) data['suspendUntil'] = suspendUntil;
  
  final result = await functions.httpsCallable('suspendUser').call(data);
  
  // Response:
  // { "success": true, "message": "User suspended successfully" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `banUser`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `user.ban`

```dart
/// Permanently ban a user account
Future<Map<String, dynamic>> banUser({
  required String targetUid,
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('banUser').call({
    'targetUid': targetUid,
    'reason': reason,
  });
  
  // Effects: Sets accountState to 'banned', locks wallet
  // Response:
  // { "success": true, "message": "User banned successfully" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `unbanUser`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `user.unban`

```dart
/// Unban a user account
Future<Map<String, dynamic>> unbanUser({
  required String targetUid,
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('unbanUser').call({
    'targetUid': targetUid,
    'reason': reason,
  });
  
  // Effects: Sets accountState to 'active', unlocks wallet
  // Response:
  // { "success": true, "message": "User unbanned successfully" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `setUserRiskLevel`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `user.risk`

```dart
/// Set user risk level for fraud detection
Future<Map<String, dynamic>> setUserRiskLevel({
  required String targetUid,
  required String riskLevel, // 'normal', 'watch', 'high', 'fraud'
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('setUserRiskLevel').call({
    'targetUid': targetUid,
    'riskLevel': riskLevel,
    'reason': reason,
  });
  
  // Response:
  // { "success": true, "message": "User risk level set to high" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `getAdminUserDetails`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `user.view`

```dart
/// Get full user details (admin view)
Future<Map<String, dynamic>> getAdminUserDetails({
  required String targetUid,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getAdminUserDetails').call({
    'targetUid': targetUid,
  });
  
  // Response contains full UserDocument
  // { "success": true, "message": "User details retrieved", "data": {...} }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `searchUsers`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `user.search`

```dart
/// Search users by email, phone, or invite code
Future<List<Map<String, dynamic>>> searchUsers({
  required String query,
  required String field, // 'email', 'phone', 'inviteCode'
  int limit = 20,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('searchUsers').call({
    'query': query,
    'field': field,
    'limit': limit,
  });
  
  // Response:
  // { "success": true, "message": "Found 3 users", "data": [...] }
  final data = Map<String, dynamic>.from(result.data);
  return List<Map<String, dynamic>>.from(
    (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
  );
}
```

---

## Admin Wallet Functions

### `adminCreditWallet`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `wallet.credit`

```dart
/// Credit BDT to user's wallet (admin bonus, refund, etc.)
Future<Map<String, dynamic>> adminCreditWallet({
  required String targetUid,
  required double amount,
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('adminCreditWallet').call({
    'targetUid': targetUid,
    'amount': amount,
    'reason': reason,
  });
  
  // Response:
  // { "success": true, "message": "Credited ৳100 to user wallet" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `adminCreditRewardPoints`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `reward.credit`

```dart
/// Credit reward points to user (admin bonus, compensation, etc.)
Future<Map<String, dynamic>> adminCreditRewardPoints({
  required String targetUid,
  required int points,
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('adminCreditRewardPoints').call({
    'targetUid': targetUid,
    'points': points,
    'reason': reason,
  });
  
  // Response:
  // { "success": true, "message": "Credited 500 reward points to user" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `adminLockWallet`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `wallet.lock`

```dart
/// Lock user's wallet (prevent withdrawals)
Future<Map<String, dynamic>> adminLockWallet({
  required String targetUid,
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('adminLockWallet').call({
    'targetUid': targetUid,
    'reason': reason,
  });
  
  // Response:
  // { "success": true, "message": "User wallet locked" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `adminUnlockWallet`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `wallet.unlock`

```dart
/// Unlock user's wallet
Future<Map<String, dynamic>> adminUnlockWallet({
  required String targetUid,
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('adminUnlockWallet').call({
    'targetUid': targetUid,
    'reason': reason,
  });
  
  // Response:
  // { "success": true, "message": "User wallet unlocked" }
  return Map<String, dynamic>.from(result.data);
}
```

---

## Admin Withdrawal Functions

### `getPendingWithdrawals`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `withdraw.review`

```dart
/// Get list of pending withdrawal requests
Future<List<Map<String, dynamic>>> getPendingWithdrawals({
  int limit = 50,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('getPendingWithdrawals').call({
    'limit': limit,
  });
  
  // Response:
  // { "success": true, "message": "Pending withdrawals retrieved", "data": [...] }
  final data = Map<String, dynamic>.from(result.data);
  return List<Map<String, dynamic>>.from(
    (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
  );
}
```

---

### `approveWithdrawal`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `withdraw.approve`

```dart
/// Approve a withdrawal request
Future<Map<String, dynamic>> approveWithdrawal({
  required String withdrawalId,
  String? adminNote,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final data = {'withdrawalId': withdrawalId};
  if (adminNote != null) data['adminNote'] = adminNote;
  
  final result = await functions.httpsCallable('approveWithdrawal').call(data);
  
  // Response:
  // { "success": true, "message": "Withdrawal approved successfully" }
  return Map<String, dynamic>.from(result.data);
}
```

---

### `rejectWithdrawal`
**Type:** Callable  
**Auth Required:** Yes  
**Permission Required:** `withdraw.reject`

```dart
/// Reject a withdrawal request (refunds amount to wallet)
Future<Map<String, dynamic>> rejectWithdrawal({
  required String withdrawalId,
  required String reason,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
  
  final result = await functions.httpsCallable('rejectWithdrawal').call({
    'withdrawalId': withdrawalId,
    'reason': reason,
  });
  
  // Effects: Refunds withdrawal amount back to user's wallet
  // Response:
  // { "success": true, "message": "Withdrawal rejected and amount refunded" }
  return Map<String, dynamic>.from(result.data);
}
```

---

## Available Permissions List

| Permission | Description |
|------------|-------------|
| `user.view` | View user details |
| `user.search` | Search users |
| `user.suspend` | Suspend user accounts |
| `user.ban` | Ban user accounts |
| `user.unban` | Unban user accounts |
| `user.risk` | Set user risk level |
| `wallet.credit` | Credit BDT to wallets |
| `wallet.lock` | Lock user wallets |
| `wallet.unlock` | Unlock user wallets |
| `reward.credit` | Credit reward points |
| `withdraw.review` | View pending withdrawals |
| `withdraw.approve` | Approve withdrawals |
| `withdraw.reject` | Reject withdrawals |
| `permission.grant` | Grant permissions |
| `permission.revoke` | Revoke permissions |

---

## Complete Admin Repository Example

```dart
// lib/data/repositories/admin/admin_repository.dart
import 'package:cloud_functions/cloud_functions.dart';

class AdminRepository {
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-south1');

  // User Management
  Future<Map<String, dynamic>> suspendUser(String uid, String reason, {String? until}) async {
    final data = {'targetUid': uid, 'reason': reason};
    if (until != null) data['suspendUntil'] = until;
    final result = await _functions.httpsCallable('suspendUser').call(data);
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> banUser(String uid, String reason) async {
    final result = await _functions.httpsCallable('banUser').call({
      'targetUid': uid, 'reason': reason,
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> unbanUser(String uid, String reason) async {
    final result = await _functions.httpsCallable('unbanUser').call({
      'targetUid': uid, 'reason': reason,
    });
    return Map<String, dynamic>.from(result.data);
  }

  // Withdrawal Management
  Future<List<Map<String, dynamic>>> getPendingWithdrawals({int limit = 50}) async {
    final result = await _functions.httpsCallable('getPendingWithdrawals').call({'limit': limit});
    final data = Map<String, dynamic>.from(result.data);
    return List<Map<String, dynamic>>.from(
      (data['data'] as List).map((e) => Map<String, dynamic>.from(e))
    );
  }

  Future<Map<String, dynamic>> approveWithdrawal(String id, {String? note}) async {
    final data = {'withdrawalId': id};
    if (note != null) data['adminNote'] = note;
    final result = await _functions.httpsCallable('approveWithdrawal').call(data);
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> rejectWithdrawal(String id, String reason) async {
    final result = await _functions.httpsCallable('rejectWithdrawal').call({
      'withdrawalId': id, 'reason': reason,
    });
    return Map<String, dynamic>.from(result.data);
  }

  // Wallet Operations
  Future<Map<String, dynamic>> creditWallet(String uid, double amount, String reason) async {
    final result = await _functions.httpsCallable('adminCreditWallet').call({
      'targetUid': uid, 'amount': amount, 'reason': reason,
    });
    return Map<String, dynamic>.from(result.data);
  }

  Future<Map<String, dynamic>> creditRewardPoints(String uid, int points, String reason) async {
    final result = await _functions.httpsCallable('adminCreditRewardPoints').call({
      'targetUid': uid, 'points': points, 'reason': reason,
    });
    return Map<String, dynamic>.from(result.data);
  }
}
```
