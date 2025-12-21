import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/bottom_navigation_controller.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure HikingService is a single permanent instance
    if (!Get.isRegistered<HikingService>()) {
      Get.put<HikingService>(HikingService(), permanent: true);
    }

    Get.lazyPut<BottomNavigationController>(
      () => BottomNavigationController(),
    );
  }
}
