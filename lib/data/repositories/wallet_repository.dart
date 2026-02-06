import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/utils/constants/firebase_paths.dart';
import 'package:legacyhub/data/models/wallet/wallet_model.dart';
import 'package:legacyhub/data/models/wallet/transaction_model.dart';

/// Wallet Repository
/// Handles all Firebase operations related to wallet and transactions
class WalletRepository {
  final FirebaseService _firebase = FirebaseService.instance;

  // ===== WALLET =====

  /// Get wallet by UID
  Future<WalletModel?> getWallet(String uid) async {
    final doc = await _firebase.firestore
        .collection(FirebasePaths.wallets)
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return WalletModel.fromFirestore(doc);
  }

  /// Stream wallet data
  Stream<WalletModel?> streamWallet(String uid) {
    return _firebase.firestore
        .collection(FirebasePaths.wallets)
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return WalletModel.fromFirestore(doc);
        });
  }

  /// Get current user's wallet
  Future<WalletModel?> getCurrentWallet() async {
    final uid = _firebase.currentUserId;
    if (uid == null) return null;
    return getWallet(uid);
  }

  /// Stream current user's wallet
  Stream<WalletModel?> streamCurrentWallet() {
    final uid = _firebase.currentUserId;
    if (uid == null) return Stream.value(null);
    return streamWallet(uid);
  }

  /// Create wallet for user
  Future<void> createWallet(String uid) async {
    final wallet = WalletModel.empty(uid);
    await _firebase.firestore
        .collection(FirebasePaths.wallets)
        .doc(uid)
        .set(wallet.toFirestore());
  }

  // ===== TRANSACTIONS =====

  /// Get transactions for user
  Future<List<TransactionModel>> getTransactions(
    String uid, {
    int limit = 20,
    DocumentSnapshot? startAfter,
    TransactionType? type,
    TransactionStatus? status,
  }) async {
    Query query = _firebase.firestore
        .collection(FirebasePaths.transactions)
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true);

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    query = query.limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();
  }

  /// Stream recent transactions for user
  Stream<List<TransactionModel>> streamRecentTransactions(
    String uid, {
    int limit = 10,
  }) {
    return _firebase.firestore
        .collection(FirebasePaths.transactions)
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Get transaction by ID
  Future<TransactionModel?> getTransaction(String transactionId) async {
    final doc = await _firebase.firestore
        .collection(FirebasePaths.transactions)
        .doc(transactionId)
        .get();

    if (!doc.exists) return null;
    return TransactionModel.fromFirestore(doc);
  }

  /// Create a pending transaction
  /// Note: Actual balance updates should be done via Cloud Functions
  Future<String> createTransaction(TransactionModel transaction) async {
    final docRef = await _firebase.firestore
        .collection(FirebasePaths.transactions)
        .add(transaction.toFirestore());

    return docRef.id;
  }

  // ===== CONVERSION =====

  /// Request reward points to BDT conversion
  /// Note: Actual conversion is handled by Cloud Functions
  Future<String> requestPointsConversion({
    required String uid,
    required int points,
  }) async {
    // Validate minimum points (100 = 1 BDT)
    if (points < 100) {
      throw Exception('Minimum 100 points required for conversion');
    }

    final amount = points / 100; // 100 points = 1 BDT

    final transaction = TransactionModel(
      id: '',
      uid: uid,
      type: TransactionType.conversion,
      amount: amount,
      rewardPoints: points,
      status: TransactionStatus.pending,
      description:
          'Points conversion: $points pts → ৳${amount.toStringAsFixed(2)}',
      metadata: {
        'sourcePoints': points,
        'conversionRate': 0.01, // 1 point = 0.01 BDT
      },
    );

    return createTransaction(transaction);
  }

  // ===== WITHDRAWAL =====

  /// Request withdrawal
  /// Note: Actual withdrawal is handled by Cloud Functions
  Future<String> requestWithdrawal({
    required String uid,
    required double amount,
    required String method, // bkash, nagad, rocket
    required String accountNumber,
  }) async {
    // Validate minimum withdrawal
    if (amount < 50) {
      throw Exception('Minimum withdrawal amount is ৳50');
    }

    final transaction = TransactionModel(
      id: '',
      uid: uid,
      type: TransactionType.withdraw,
      amount: amount,
      rewardPoints: 0,
      status: TransactionStatus.pending,
      description: 'Withdrawal to $method',
      metadata: {'method': method, 'accountNumber': accountNumber},
    );

    return createTransaction(transaction);
  }

  // ===== STATISTICS =====

  /// Get transaction summary for user
  Future<Map<String, dynamic>> getTransactionSummary(String uid) async {
    final wallet = await getWallet(uid);
    if (wallet == null) return {};

    return {
      'balance': wallet.balance,
      'rewardPoints': wallet.rewardPoints,
      'totalDeposits': wallet.totalDeposits,
      'totalWithdrawals': wallet.totalWithdrawals,
      'totalEarnings': wallet.totalEarnings,
      'totalPointsEarned': wallet.totalRewardPointsEarned,
      'totalPointsConverted': wallet.totalRewardPointsConverted,
    };
  }
}
