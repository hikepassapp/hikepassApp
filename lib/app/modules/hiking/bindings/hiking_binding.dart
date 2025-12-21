import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/hiking_controller.dart';

class HikingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HikingService>()) {
      Get.put<HikingService>(HikingService(), permanent: true);
    }

    Get.lazyPut<HikingController>(() => HikingController());
  }
}
