import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/hiking_controller.dart';

class HikingBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize service first
    Get.lazyPut<HikingService>(() => HikingService(), fenix: true);

    // Then initialize controller
    Get.lazyPut<HikingController>(() => HikingController());
  }
}
