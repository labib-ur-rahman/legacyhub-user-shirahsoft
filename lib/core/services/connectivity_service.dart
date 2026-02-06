import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/logger_service.dart';

/// Connectivity Service - Network connection monitoring
/// Provides real-time network status updates
class ConnectivityService extends GetxController {
  static ConnectivityService get instance => Get.find();

  // ==================== Properties ====================

  /// Connectivity instance
  final Connectivity _connectivity = Connectivity();

  /// Stream subscription for connectivity changes
  StreamSubscription<ConnectivityResult>? _subscription;

  /// Observable connection status
  final RxBool isConnected = true.obs;

  /// Observable connection type
  final Rx<ConnectivityResult> connectionType = ConnectivityResult.none.obs;

  // ==================== Lifecycle ====================

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _startListening();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  // ==================== Private Methods ====================

  /// Initialize connectivity check
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      LoggerService.error('Failed to check connectivity', e);
      isConnected.value = false;
    }
  }

  /// Start listening for connectivity changes
  void _startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (error) {
        LoggerService.error('Connectivity stream error', error);
        isConnected.value = false;
      },
    );
  }

  /// Update connection status based on result
  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      connectionType.value = ConnectivityResult.none;
      LoggerService.warning('📡 No internet connection');
    } else {
      isConnected.value = true;
      connectionType.value = result;
      LoggerService.info('📡 Connected via ${result.name}');
    }
  }

  // ==================== Public Methods ====================

  /// Check current connection status
  Future<bool> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      return isConnected.value;
    } catch (e) {
      LoggerService.error('Failed to check connection', e);
      return false;
    }
  }

  /// Check if connected to WiFi
  bool get isWifi => connectionType.value == ConnectivityResult.wifi;

  /// Check if connected to mobile data
  bool get isMobile => connectionType.value == ConnectivityResult.mobile;

  /// Check if connected to ethernet
  bool get isEthernet => connectionType.value == ConnectivityResult.ethernet;

  /// Get connection type as string
  String get connectionTypeString {
    switch (connectionType.value) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }
}
