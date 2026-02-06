import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:legacyhub/app.dart';
import 'package:legacyhub/firebase_options.dart';

import 'core/services/local_storage_service.dart';
import 'core/services/logger_service.dart';
import 'core/utils/http/http_client.dart';

/// Main entry point of the application
/// Initializes all core services and runs the app
void main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize GetStorage for local data persistence
  await GetStorage.init();

  // Initialize core services
  await _initializeServices();

  // Configure system UI overlay (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred device orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure EasyLoading
  _configureEasyLoading();

  // Run the application
  runApp(const MyApp());
}

/// Initialize all core services before app starts
Future<void> _initializeServices() async {
  // Initialize logger service
  LoggerService.init();
  LoggerService.info('🚀 Application starting...');

  // Initialize local storage service
  await LocalStorageService.init();
  LoggerService.info('💾 Local storage initialized');

  // Initialize HTTP service
  HttpService.init();
  LoggerService.info('🌐 HTTP service initialized');

  LoggerService.info('✅ All services initialized successfully');
}

/// Configure EasyLoading global settings
void _configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
