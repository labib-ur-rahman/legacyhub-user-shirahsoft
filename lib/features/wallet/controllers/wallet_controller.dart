import 'dart:async';

import 'package:get/get.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/common/widgets/popups/custom_snackbar.dart';
import 'package:legacyhub/data/models/wallet/wallet_model.dart';
import 'package:legacyhub/data/models/wallet/transaction_model.dart';
import 'package:legacyhub/data/repositories/wallet_repository.dart';

/// Wallet Controller
/// Manages wallet state and operations
class WalletController extends GetxController {
  static WalletController get instance => Get.find();

  // ===== Repository =====
  final WalletRepository _walletRepo = WalletRepository();
  final FirebaseService _firebase = FirebaseService.instance;

  // ===== Observable State =====
  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingTransactions = false.obs;
  final RxBool hasMoreTransactions = true.obs;

  // ===== Streams =====
  StreamSubscription<WalletModel?>? _walletSubscription;
  StreamSubscription<List<TransactionModel>>? _transactionSubscription;

  // ===== Getters =====
  double get balance => wallet.value?.balance ?? 0.0;
  int get rewardPoints => wallet.value?.rewardPoints ?? 0;
  double get rewardPointsAsBDT => wallet.value?.rewardPointsAsBDT ?? 0.0;
  double get totalValue => wallet.value?.totalValue ?? 0.0;
  String get formattedBalance => wallet.value?.formattedBalance ?? '৳0.00';
  String get formattedRewardPoints =>
      wallet.value?.formattedRewardPoints ?? '0 pts';

  @override
  void onInit() {
    super.onInit();
    _initWalletStream();
  }

  @override
  void onClose() {
    _walletSubscription?.cancel();
    _transactionSubscription?.cancel();
    super.onClose();
  }

  /// Initialize wallet stream
  void _initWalletStream() {
    final uid = _firebase.currentUserId;
    if (uid == null) return;

    _walletSubscription = _walletRepo
        .streamWallet(uid)
        .listen(
          (walletData) {
            wallet.value = walletData;
          },
          onError: (error) {
            AppSnackBar.errorSnackBar(
              title: 'Wallet Error',
              message: 'Failed to load wallet data',
            );
          },
        );

    _transactionSubscription = _walletRepo
        .streamRecentTransactions(uid)
        .listen(
          (transactionsList) {
            transactions.value = transactionsList;
          },
          onError: (error) {
            // Silently fail for transactions
          },
        );
  }

  /// Refresh wallet data
  Future<void> refreshWallet() async {
    final uid = _firebase.currentUserId;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final walletData = await _walletRepo.getWallet(uid);
      wallet.value = walletData;
    } catch (e) {
      AppSnackBar.errorSnackBar(
        title: 'Error',
        message: 'Failed to refresh wallet',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more transactions (pagination)
  Future<void> loadMoreTransactions() async {
    if (isLoadingTransactions.value || !hasMoreTransactions.value) return;

    final uid = _firebase.currentUserId;
    if (uid == null) return;

    try {
      isLoadingTransactions.value = true;

      // Get last document for pagination
      // This is simplified - in production, store DocumentSnapshot
      final newTransactions = await _walletRepo.getTransactions(uid, limit: 20);

      if (newTransactions.isEmpty || newTransactions.length < 20) {
        hasMoreTransactions.value = false;
      }

      // Add new transactions (avoid duplicates)
      final existingIds = transactions.map((t) => t.id).toSet();
      final uniqueNew = newTransactions.where(
        (t) => !existingIds.contains(t.id),
      );
      transactions.addAll(uniqueNew);
    } catch (e) {
      AppSnackBar.errorSnackBar(
        title: 'Error',
        message: 'Failed to load transactions',
      );
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  // ===== CONVERSION =====

  /// Convert reward points to BDT
  Future<bool> convertPointsToBDT(int points) async {
    final uid = _firebase.currentUserId;
    if (uid == null) return false;

    // Validate
    if (points < 100) {
      AppSnackBar.errorSnackBar(
        title: 'Minimum Points Required',
        message: 'You need at least 100 points to convert',
      );
      return false;
    }

    if (points > rewardPoints) {
      AppSnackBar.errorSnackBar(
        title: 'Insufficient Points',
        message: 'You don\'t have enough points',
      );
      return false;
    }

    try {
      isLoading.value = true;

      await _walletRepo.requestPointsConversion(uid: uid, points: points);

      final bdtAmount = points / 100;
      AppSnackBar.successSnackBar(
        title: 'Conversion Requested',
        message:
            'Converting $points points to ৳${bdtAmount.toStringAsFixed(2)}',
      );

      return true;
    } catch (e) {
      AppSnackBar.errorSnackBar(
        title: 'Conversion Failed',
        message: e.toString(),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== WITHDRAWAL =====

  /// Request withdrawal
  Future<bool> requestWithdrawal({
    required double amount,
    required String method,
    required String accountNumber,
  }) async {
    final uid = _firebase.currentUserId;
    if (uid == null) return false;

    // Validate
    if (amount < 50) {
      AppSnackBar.errorSnackBar(
        title: 'Minimum Amount Required',
        message: 'Minimum withdrawal is ৳50',
      );
      return false;
    }

    if (amount > balance) {
      AppSnackBar.errorSnackBar(
        title: 'Insufficient Balance',
        message: 'You don\'t have enough balance',
      );
      return false;
    }

    try {
      isLoading.value = true;

      await _walletRepo.requestWithdrawal(
        uid: uid,
        amount: amount,
        method: method,
        accountNumber: accountNumber,
      );

      AppSnackBar.successSnackBar(
        title: 'Withdrawal Requested',
        message: 'Your withdrawal of ৳$amount is being processed',
      );

      return true;
    } catch (e) {
      AppSnackBar.errorSnackBar(
        title: 'Withdrawal Failed',
        message: e.toString(),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== HELPERS =====

  /// Check if user can afford an amount
  bool canAfford(double amount) => balance >= amount;

  /// Get filtered transactions
  List<TransactionModel> getTransactionsByType(TransactionType type) {
    return transactions.where((t) => t.type == type).toList();
  }
}
