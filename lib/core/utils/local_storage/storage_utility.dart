import 'package:get_storage/get_storage.dart';
import 'package:legacyhub/core/services/logger_service.dart';

class AppLocalStorage {
  late final GetStorage _storage;
  bool _isInitialized = false;

  // Singleton instance
  static AppLocalStorage? _instance;

  AppLocalStorage._internal();

  factory AppLocalStorage.instance() {
    _instance ??= AppLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String bucketName) async {
    try {
      LoggerService.info(
        '🔧 Initializing AppLocalStorage with bucket: $bucketName',
      );
      await GetStorage.init(bucketName);
      _instance = AppLocalStorage._internal();
      _instance!._storage = GetStorage(bucketName);
      _instance!._isInitialized = true;
      LoggerService.info('✅ AppLocalStorage initialized successfully');
    } catch (e) {
      LoggerService.error('❌ Failed to initialize AppLocalStorage', e);
      rethrow;
    }
  }

  void _checkInitialization() {
    if (!_isInitialized) {
      LoggerService.error(
        '❌ AppLocalStorage not initialized. Call AppLocalStorage.init() first',
      );
      throw StateError(
        'AppLocalStorage not initialized. Call AppLocalStorage.init() first',
      );
    }
  }

  // Generic method to save data
  Future<void> saveData<T>(String key, T value) async {
    _checkInitialization();
    try {
      LoggerService.debug('💾 Saving data for key: $key');
      await _storage.write(key, value);
      LoggerService.debug('✅ Data saved successfully for key: $key');
    } catch (e) {
      LoggerService.error('❌ Failed to save data for key: $key', e);
      rethrow;
    }
  }

  // Generic method to read data
  T? readData<T>(String key) {
    _checkInitialization();
    try {
      LoggerService.debug('📖 Reading data for key: $key');
      final data = _storage.read<T>(key);
      LoggerService.debug(
        '📋 Data read for key $key: ${data != null ? "Found" : "Not found"}',
      );
      return data;
    } catch (e) {
      LoggerService.error('❌ Failed to read data for key: $key', e);
      return null;
    }
  }

  // Generic method to remove data
  Future<void> removeData(String key) async {
    _checkInitialization();
    try {
      LoggerService.debug('🗑️ Removing data for key: $key');
      await _storage.remove(key);
      LoggerService.debug('✅ Data removed successfully for key: $key');
    } catch (e) {
      LoggerService.error('❌ Failed to remove data for key: $key', e);
      rethrow;
    }
  }

  // Clear all data in storage
  Future<void> clearAll() async {
    _checkInitialization();
    try {
      LoggerService.info('🗑️ Clearing all storage data');
      await _storage.erase();
      LoggerService.info('✅ All storage data cleared successfully');
    } catch (e) {
      LoggerService.error('❌ Failed to clear storage data', e);
      rethrow;
    }
  }
}
