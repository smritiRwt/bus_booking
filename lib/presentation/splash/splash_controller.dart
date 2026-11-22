import 'package:get/get.dart';
import '../../data/database/app_database.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Warm up SQLite database and trigger initial seeding if needed
      await Get.find<AppDatabase>().database;
    } catch (e) {
      // Handle fallback
    }

    // Smooth delay for branding splash animation
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.offAllNamed(AppRoutes.main);
  }
}
