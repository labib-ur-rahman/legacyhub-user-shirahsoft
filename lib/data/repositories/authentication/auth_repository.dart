import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/core/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:legacyhub/core/utils/exceptions/format_exceptions.dart';
import 'package:legacyhub/core/utils/exceptions/platform_exceptions.dart';

/// Authentication Repository
/// Handles all authentication-related Firebase operations.
/// Uses Cloud Functions for user creation (atomic transactions).
class AuthRepository {
  // ===== Firebase Instances (lazy) =====
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFunctions get _functions =>
      FirebaseFunctions.instanceFor(region: 'asia-south1');

  // ===== Getters =====
  // Get current user
  User? get currentUser => _auth.currentUser;
  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // =====================================================================
  // INVITE CODE VALIDATION
  // =====================================================================

  /// Validate invite code by checking invite_codes collection.
  /// Returns true if the invite code document exists.
  Future<bool> validateInviteCode(String inviteCode) async {
    try {
      final doc = await _firestore
          .collection('invite_codes')
          .doc(inviteCode.toUpperCase())
          .get();
      return doc.exists;
    } catch (e) {
      LoggerService.error('Invite code validation error', e);
      return false;
    }
  }

  // =====================================================================
  // EMAIL / PASSWORD AUTH
  // =====================================================================

  /// Sign in with email and password.
  /// Returns map with user credential + profile from Firestore.
  Future<Map<String, dynamic>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Login failed');
      }

      // Fetch user profile from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User profile not found');
      }

      return {
        'success': true,
        'user': credential.user,
        'profile': userDoc.data(),
      };
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const SLFormatException();
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Sign up with email and password
  /// Flow:
  /// 1. Call Cloud Function to create auth user + all Firestore documents
  /// 2. Cloud function handles everything atomically (creates auth user, invite code, user doc, uplines, relations, stats)
  /// 3. If cloud function fails at any point, it cleans up the auth user
  /// 4. On success, Flutter signs in with the credentials
  Future<Map<String, dynamic>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String inviteCode,
  }) async {
    try {
      LoggerService.info('Starting signup for email: $email');

      // Step 1: Call createUser Cloud Function
      LoggerService.info('Calling createUser Cloud Function...');
      final result = await _functions.httpsCallable('createUser').call({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phoneNumber,
        'inviteCode': inviteCode,
      });

      final data = Map<String, dynamic>.from(result.data as Map);

      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to create account');
      }

      LoggerService.info('User account created via Cloud Function');

      // Step 2: Sign in with the new credentials
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed after account creation');
      }

      LoggerService.info(
        '✅ Signed in successfully with UID: ${credential.user!.uid}',
      );

      // Step 3: Fetch user profile
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      return {
        'success': true,
        'user': credential.user,
        'profile': userDoc.exists ? userDoc.data() : data['data'] ?? {},
      };
    } on FirebaseFunctionsException catch (e) {
      LoggerService.error('Cloud Function Exception during signup', e);
      throw Exception(e.message ?? 'Signup failed');
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const SLFormatException();
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // =====================================================================
  // GOOGLE AUTH
  // =====================================================================

  /// Sign in with Google.
  /// Always forces account picker. Checks profile completeness.
  /// Returns: { success, isNewUser, profileComplete, user, profile }
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      LoggerService.info('🔐 Starting Google Sign-in...');

      // Always sign out first to force account picker
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      LoggerService.info('✅ Google Sign-in successful: ${googleUser.email}');

      // Get auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Google sign in failed');
      }

      LoggerService.info(
        'Firebase sign-in successful: ${userCredential.user!.uid}',
      );

      // Check profile completeness
      LoggerService.info(
        '📍 Checking user profile completeness in Firestore...',
      );
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Brand new Google user — needs phone + invite code
        LoggerService.info('New Google user — needs profile completion');
        return {
          'success': true,
          'isNewUser': true,
          'profileComplete': false,
          'user': userCredential.user,
          'profile': null,
        };
      }

      // Document exists — check if parentUid AND phone are present
      final profileData = userDoc.data()!;
      final network = profileData['network'] as Map<String, dynamic>?;
      final identity = profileData['identity'] as Map<String, dynamic>?;
      final parentUid = network?['parentUid'] as String?;
      final phone = identity?['phone'] as String?;

      final bool isProfileComplete =
          parentUid != null &&
          parentUid.isNotEmpty &&
          phone != null &&
          phone.isNotEmpty;

      if (!isProfileComplete) {
        LoggerService.info('Existing user with incomplete profile');
        return {
          'success': true,
          'isNewUser': false,
          'profileComplete': false,
          'user': userCredential.user,
          'profile': profileData,
        };
      }

      // Complete profile — login directly
      LoggerService.info('Existing user with complete profile');
      return {
        'success': true,
        'isNewUser': false,
        'profileComplete': true,
        'user': userCredential.user,
        'profile': profileData,
      };
    } catch (e) {
      LoggerService.error('Google sign in error', e);
      rethrow;
    }
  }

  /// Complete Google signup with phone + invite code.
  /// Calls completeGoogleSignIn Cloud Function.
  Future<Map<String, dynamic>> completeGoogleSignup({
    required String phoneNumber,
    required String inviteCode,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      LoggerService.info('Completing Google signup for: ${user.uid}');

      final result = await _functions
          .httpsCallable('completeGoogleSignIn')
          .call({'phone': phoneNumber, 'inviteCode': inviteCode});

      LoggerService.info('Cloud Function response received');
      final data = Map<String, dynamic>.from(result.data as Map);
      LoggerService.debug('Response data: $data');

      if (data['success'] != true) {
        LoggerService.error(
          'Cloud Function returned error: ${data['message']}',
        );
        throw Exception(data['message'] ?? 'Failed to complete signup');
      }

      LoggerService.info('Google signup completion successful');

      // Step 2: Fetch the complete user profile from Firestore
      LoggerService.info('Fetching user profile from Firestore...');
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        LoggerService.error('User document not found after signup completion');
        throw Exception('User profile not found');
      }

      final profile = userDoc.data()!;
      LoggerService.info('✅ User profile fetched successfully');

      return {
        'success': true,
        'user': user,
        'profile': profile,
        'data': data['data'], // {uid, inviteCode} from cloud function
      };
    } on FirebaseFunctionsException catch (e) {
      LoggerService.error('❌ Cloud Function Exception during Google signup', e);
      throw Exception(e.message ?? 'Failed to complete signup');
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const SLFormatException();
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // =====================================================================
  // SIGN OUT / DELETE
  // =====================================================================

  /// Sign out and delete the current Firebase auth user.
  /// Used when a Google user cancels profile completion.
  Future<void> signOutAndDeleteUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        LoggerService.info('🗑️ Deleting auth user: ${user.uid}');
        await user.delete();
        LoggerService.info('✅ Auth user deleted successfully');
      }
      await _googleSignIn.signOut();
      await _auth.signOut();
      LoggerService.info('✅ Signed out from Google + Firebase');
    } catch (e) {
      // If delete fails (e.g., requires re-auth), still sign out
      LoggerService.error(
        '⚠️ Failed to delete auth user, signing out instead',
        e,
      );
      try {
        await _googleSignIn.signOut();
        await _auth.signOut();
      } catch (signOutError) {
        LoggerService.error('❌ Sign out also failed', signOutError);
      }
    }
  }

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      LoggerService.error('Sign out error', e);
      rethrow;
    }
  }

  // =====================================================================
  // PASSWORD RESET
  // =====================================================================

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const SLFormatException();
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // =====================================================================
  // AUTH STATUS CHECK
  // =====================================================================

  /// Check auth status via Cloud Function
  Future<Map<String, dynamic>> checkAuthStatus() async {
    try {
      final result = await _functions.httpsCallable('checkAuthStatus').call();
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      LoggerService.error('Check auth status error', e);
      return {
        'success': true,
        'data': {
          'authenticated': false,
          'uid': null,
          'hasProfile': false,
          'profileComplete': false,
        },
      };
    }
  }
}
