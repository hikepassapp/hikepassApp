import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/hiking_controller.dart';

class HikingBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize a single persistent service instance
    if (!Get.isRegistered<HikingService>()) {
      Get.put<HikingService>(HikingService(), permanent: true);
    }

    // Then initialize controller
    Get.lazyPut<HikingController>(() => HikingController());
  }
}
