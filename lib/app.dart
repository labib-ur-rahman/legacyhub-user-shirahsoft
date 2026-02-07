import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/bindings/initial_binding.dart';
import 'package:legacyhub/core/localization/languages.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/utils/theme/theme.dart';
import 'package:legacyhub/routes/app_pages.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size from your Figma/design (adjust according to your design)
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          // App basic configuration
          title: 'LegacyHub - Business & Community Super App',
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,

          // Localization configuration
          translations: Languages(),
          locale: LocalStorageService.getLocale(),
          fallbackLocale: Languages.fallbackLocale,
          supportedLocales: Languages.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Theme configuration
          themeMode: LocalStorageService.getThemeMode(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          // Routing configuration
          initialRoute: AppRoutes.SPLASH,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),

          // EasyLoading builder
          builder: EasyLoading.init(),

          // Default transition
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
