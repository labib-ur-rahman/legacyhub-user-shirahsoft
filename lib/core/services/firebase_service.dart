import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/core/utils/constants/firebase_paths.dart';

/// Firebase Service - Centralized Firebase instance management
/// Provides access to Firebase Auth, Firestore, Realtime Database, and Storage
class FirebaseService extends GetxController {
  static FirebaseService get instance => Get.find();

  // ==================== Firebase Instances ====================

  /// Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Cloud Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firebase Realtime Database instance
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ==================== Getters ====================

  /// Get Firebase Auth instance
  FirebaseAuth get auth => _auth;

  /// Get Firestore instance
  FirebaseFirestore get firestore => _firestore;

  /// Get Realtime Database instance
  FirebaseDatabase get database => _database;

  /// Get Storage instance
  FirebaseStorage get storage => _storage;

  // ==================== Current User ====================

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Get current user's UID
  String? get currentUid => _auth.currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Stream of user changes (includes token refresh)
  Stream<User?> get userChanges => _auth.userChanges();

  /// Get current user ID (alias for currentUid)
  String? get currentUserId => currentUid;

  // ==================== Collection References ====================

  /// Users collection reference
  CollectionReference<Map<String, dynamic>> get usersRef =>
      _firestore.collection(FirebasePaths.users);

  /// Users collection reference (alias for usersRef)
  CollectionReference<Map<String, dynamic>> get usersCollection => usersRef;

  /// Invite codes collection reference
  CollectionReference<Map<String, dynamic>> get inviteCodesRef =>
      _firestore.collection(FirebasePaths.inviteCodes);

  /// Wallets collection reference
  CollectionReference<Map<String, dynamic>> get walletsRef =>
      _firestore.collection(FirebasePaths.wallets);

  /// Transactions collection reference
  CollectionReference<Map<String, dynamic>> get transactionsRef =>
      _firestore.collection(FirebasePaths.transactions);

  /// Reward logs collection reference
  CollectionReference<Map<String, dynamic>> get rewardLogsRef =>
      _firestore.collection(FirebasePaths.rewardLogs);

  /// Streaks collection reference
  CollectionReference<Map<String, dynamic>> get streaksRef =>
      _firestore.collection(FirebasePaths.streaks);

  /// Posts collection reference
  CollectionReference<Map<String, dynamic>> get postsRef =>
      _firestore.collection(FirebasePaths.posts);

  /// Marketplace collection reference
  CollectionReference<Map<String, dynamic>> get marketplaceRef =>
      _firestore.collection(FirebasePaths.marketplace);

  /// Micro jobs collection reference
  CollectionReference<Map<String, dynamic>> get microJobsRef =>
      _firestore.collection(FirebasePaths.microJobs);

  /// Products collection reference
  CollectionReference<Map<String, dynamic>> get productsRef =>
      _firestore.collection(FirebasePaths.products);

  /// Notifications collection reference
  CollectionReference<Map<String, dynamic>> get notificationsRef =>
      _firestore.collection(FirebasePaths.notifications);

  // ==================== Document References ====================

  /// Get user document reference
  DocumentReference<Map<String, dynamic>> userDoc(String uid) =>
      usersRef.doc(uid);

  /// Get current user's document reference
  DocumentReference<Map<String, dynamic>>? get currentUserDoc =>
      currentUid != null ? userDoc(currentUid!) : null;

  /// Get wallet document reference
  DocumentReference<Map<String, dynamic>> walletDoc(String uid) =>
      walletsRef.doc(uid);

  /// Get streak document reference
  DocumentReference<Map<String, dynamic>> streakDoc(String uid) =>
      streaksRef.doc(uid);

  // ==================== Storage References ====================

  /// Get user avatar storage reference
  Reference avatarRef(String uid) =>
      _storage.ref().child(FirebasePaths.userAvatar(uid));

  /// Get post image storage reference
  Reference postImageRef(String postId, String imageId) =>
      _storage.ref().child(FirebasePaths.postImage(postId, imageId));

  // ==================== Realtime Database References ====================

  /// Get online status database reference
  DatabaseReference onlineStatusRef(String uid) =>
      _database.ref(FirebasePaths.onlineStatus(uid));

  // ==================== Lifecycle ====================

  @override
  void onInit() {
    super.onInit();
    LoggerService.info('🔥 FirebaseService initialized');
    _setupAuthListener();
  }

  /// Setup authentication state listener
  void _setupAuthListener() {
    authStateChanges.listen((user) {
      if (user != null) {
        LoggerService.info('👤 User signed in: ${user.uid}');
        _updateOnlineStatus(true);
      } else {
        LoggerService.info('👤 User signed out');
      }
    });
  }

  /// Update user's online status in Realtime Database
  Future<void> _updateOnlineStatus(bool isOnline) async {
    if (currentUid == null) return;

    try {
      await onlineStatusRef(
        currentUid!,
      ).set({'online': isOnline, 'lastSeen': ServerValue.timestamp});
    } catch (e) {
      LoggerService.error('Failed to update online status', e);
    }
  }

  // ==================== Utility Methods ====================

  /// Get server timestamp for Firestore
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  /// Batch write helper
  WriteBatch get batch => _firestore.batch();

  /// Run transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) transactionHandler,
  ) {
    return _firestore.runTransaction(transactionHandler);
  }
}
