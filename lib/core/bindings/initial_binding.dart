import 'package:get/get.dart';
import 'package:project_template/features/home/controllers/home_controller.dart';

/// Initial Binding - Sets up initial dependencies when app starts
/// This binding is called when the app launches and sets up global controllers
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Home Controller - Main app controller
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true, // Keep in memory even when not used
    );
  }
}
