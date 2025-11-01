import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_template/core/services/local_storage_service.dart';
import 'package:project_template/core/services/logger_service.dart';

/// Home Controller - Manages business logic for the home screen
/// Handles theme switching, language changing, data loading, etc.
class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // ==================== Reactive Variables ====================

  /// Current theme mode (dark/light)
  final RxBool isDarkMode = false.obs;

  /// Current locale
  final RxString currentLanguage = 'en'.obs;

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Notification count
  final RxInt notificationCount = 5.obs;

  /// User information
  final RxString userId = 'USER_001'.obs;
  final RxString deviceInfo = 'Unknown Device'.obs;
  final RxString appVersion = '1.0.0'.obs;
  final RxString lastLogin = '2024-01-01 12:00:00'.obs;

  /// Selected image path
  final RxString selectedImagePath = ''.obs;

  /// Sample data list
  final RxList<Map<String, dynamic>> sampleData = <Map<String, dynamic>>[].obs;

  // ==================== Lifecycle Methods ====================

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onReady() {
    super.onReady();
    loadSampleData();
  }

  /// Initialize controller with saved preferences
  void _initializeController() {
    try {
      // Load theme mode
      final themeMode = LocalStorageService.getThemeMode();
      isDarkMode.value = themeMode == ThemeMode.dark;

      // Load locale
      final locale = LocalStorageService.getLocale();
      currentLanguage.value = locale.languageCode;

      // Load device info (mock data for template)
      _loadDeviceInfo();

      LoggerService.info('✅ HomeController initialized successfully');
    } catch (e) {
      LoggerService.error('❌ Error initializing HomeController', e);
    }
  }

  /// Load device information (mock implementation)
  void _loadDeviceInfo() {
    try {
      // In real app, you would use device_info_plus package
      deviceInfo.value = Platform.isAndroid ? 'Android Device' : 'iOS Device';
      lastLogin.value = DateTime.now().toString().substring(0, 19);
    } catch (e) {
      LoggerService.error('❌ Error loading device info', e);
    }
  }

  // ==================== Theme Management ====================

  /// Toggle between light and dark theme
  void toggleTheme() {
    try {
      isDarkMode.value = !isDarkMode.value;
      final themeMode = isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

      // Save to storage
      LocalStorageService.setThemeMode(themeMode);

      // Update GetX theme
      Get.changeThemeMode(themeMode);

      LoggerService.info('🎨 Theme changed to: ${themeMode.name}');

      // Show feedback
      Get.snackbar(
        'theme_changed'.tr,
        isDarkMode.value ? 'dark_theme_enabled'.tr : 'light_theme_enabled'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LoggerService.error('❌ Error toggling theme', e);
    }
  }

  // ==================== Language Management ====================

  /// Toggle between supported languages
  void toggleLanguage() {
    try {
      final newLanguage = currentLanguage.value == 'en' ? 'bn' : 'en';
      final newLocale = Locale(newLanguage, newLanguage == 'en' ? 'US' : 'BD');

      // Update GetX locale
      Get.updateLocale(newLocale);

      // Save to storage
      LocalStorageService.setLocale(newLocale);

      // Update reactive variable
      currentLanguage.value = newLanguage;

      LoggerService.info('🌐 Language changed to: $newLanguage');

      // Show feedback
      EasyLoading.showToast('language_changed'.tr);
    } catch (e) {
      LoggerService.error('❌ Error toggling language', e);
    }
  }

  // ==================== Navigation Methods ====================

  /// Open notifications screen
  void openNotifications() {
    try {
      LoggerService.info('📱 Opening notifications');
      // Navigate to notifications screen
      // Get.toNamed(AppRoutes.NOTIFICATIONS);

      // For template, just show a message
      Get.snackbar(
        'notifications'.tr,
        'notifications_feature_coming_soon'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      LoggerService.error('❌ Error opening notifications', e);
    }
  }

  /// Open profile screen
  void openProfile() {
    try {
      LoggerService.info('👤 Opening profile');
      // Navigate to profile screen
      // Get.toNamed(AppRoutes.PROFILE);

      // For template, just show a message
      Get.snackbar(
        'profile'.tr,
        'profile_feature_coming_soon'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      LoggerService.error('❌ Error opening profile', e);
    }
  }

  /// Open settings screen
  void openSettings() {
    LoggerService.info('⚙️ Opening settings');
    EasyLoading.showInfo('Settings screen coming soon');
  }

  /// Show about dialog
  void showAbout() {
    try {
      LoggerService.info('ℹ️ Showing about dialog');

      Get.dialog(
        AlertDialog(
          title: Text('about_app'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('app_description'.tr),
              const SizedBox(height: 16),
              Text('version'.tr + ': ${appVersion.value}'),
              Text('developer'.tr + ': Your Team Name'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('close'.tr)),
          ],
        ),
      );
    } catch (e) {
      LoggerService.error('❌ Error showing about dialog', e);
    }
  }

  // ==================== Image Picker Methods ====================

  /// Pick image from gallery or camera
  Future<void> pickImage() async {
    try {
      LoggerService.info('📷 Starting image picker');

      // Check permission
      final hasPermission = await _checkImagePermission();
      if (!hasPermission) {
        LoggerService.warning('⚠️ Image permission denied');
        return;
      }

      // Show picker options
      final result = await Get.bottomSheet<ImageSource>(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('select_image_source'.tr, style: Get.textTheme.titleLarge),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('camera'.tr),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('gallery'.tr),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text('cancel'.tr),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );

      if (result != null) {
        await _pickImageFromSource(result);
      }
    } catch (e) {
      LoggerService.error('❌ Error in image picker', e);
      EasyLoading.showError('image_picker_error'.tr);
    }
  }

  /// Check image picker permissions
  Future<bool> _checkImagePermission() async {
    try {
      Permission permission = Platform.isAndroid
          ? Permission.storage
          : Permission.photos;

      final status = await permission.status;
      if (status.isGranted) {
        return true;
      }

      final result = await permission.request();
      return result.isGranted;
    } catch (e) {
      LoggerService.error('❌ Error checking image permission', e);
      return false;
    }
  }

  /// Pick image from specified source
  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImagePath.value = image.path;
        LoggerService.info('✅ Image picked: ${image.path}');
        EasyLoading.showSuccess('image_selected'.tr);
      }
    } catch (e) {
      LoggerService.error('❌ Error picking image', e);
      EasyLoading.showError('image_picker_error'.tr);
    }
  }

  // ==================== Data Management ====================

  /// Load sample data from repository
  Future<void> loadSampleData() async {
    try {
      isLoading.value = true;
      LoggerService.info('📊 Loading sample data');

      // final data = await _homeRepository.getSampleData();
      // sampleData.assignAll(data);
    } catch (e) {
      LoggerService.error('❌ Error loading sample data', e);
      EasyLoading.showError('data_load_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    try {
      LoggerService.info('🔄 Refreshing data');
      await loadSampleData();
      EasyLoading.showSuccess('data_refreshed'.tr);
    } catch (e) {
      LoggerService.error('❌ Error refreshing data', e);
    }
  }

  /// Handle item tap
  void onItemTap(Map<String, dynamic> item) {
    try {
      LoggerService.info('👆 Item tapped: ${item['name']}');

      Get.snackbar(
        'item_selected'.tr,
        'selected_user'.tr + ': ${item['name']}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      LoggerService.error('❌ Error handling item tap', e);
    }
  }

  /// Select an item from the list
  void selectItem(int index) {
    try {
      if (index >= 0 && index < sampleData.length) {
        final item = sampleData[index];
        LoggerService.info('📋 Item selected: ${item['title']}');

        // Show selected item info
        Get.snackbar(
          'Item Selected',
          'You selected: ${item['title']}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      LoggerService.error('❌ Error selecting item: $e');
    }
  }
}
