import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/bottom_navigation_controller.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure HikingService is available for HikingController used in bottom navigation
    Get.lazyPut<HikingService>(() => HikingService(), fenix: true);

    Get.lazyPut<BottomNavigationController>(
      () => BottomNavigationController(),
    );
  }
}
