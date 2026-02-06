import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/utils/constants/api_constants.dart';
import 'package:legacyhub/core/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:legacyhub/core/utils/exceptions/firebase_exceptions.dart';
import 'package:legacyhub/core/utils/exceptions/format_exceptions.dart';
import 'package:legacyhub/core/utils/exceptions/platform_exceptions.dart';

/// Authentication Repository
/// Handles all authentication-related API operations
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Firebase service instance
  final FirebaseService _firebase = FirebaseService.instance;

  /// Firebase Auth instance
  FirebaseAuth get _auth => _firebase.auth;

  /// Called from main.dart on app launch
  @override
  void onReady() {}

  /* ------------------------- Email & Password sign-in ----------------------*/

  /// [EmailAuthentication] - LOGIN
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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

  /// [EmailAuthentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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

  /// [ReAuthenticate] ReAuthenticate User
  Future<void> reAuthenticateWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
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

  /// [EmailVerification] MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailAuthentication] FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /* ------------------- Federated identity & social sign-in -----------------*/

  /// [GoogleAuthentication] GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn with web client ID
      final GoogleSignIn googleSignIn = kIsWeb
          ? GoogleSignIn(
              clientId: ApiConstants.googleClientId,
              scopes: ['email', 'profile'],
            )
          : GoogleSignIn();

      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await googleSignIn.signIn();

      // User cancelled the sign-in
      if (userAccount == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await userAccount.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw SLFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const SLFormatException();
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something went wrong: $e');
      return null;
    }
  }

  /// [FacebookAuthentication] FACEBOOK
  // TODO: Implement Facebook sign-in when needed

  /* --------------- ./end Federated identity & social sign-in ---------------*/

  /// [LogoutUser] Valid for any authentication.
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// DELETE USER Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw SLFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw SLPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
