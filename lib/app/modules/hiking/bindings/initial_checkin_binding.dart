import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/initial_checkin_controller.dart';

class InitialCheckInBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure service is available
    if (!Get.isRegistered<HikingService>()) {
      Get.lazyPut<HikingService>(() => HikingService(), fenix: true);
    }

    Get.lazyPut<InitialCheckInController>(() => InitialCheckInController());
  }
}
