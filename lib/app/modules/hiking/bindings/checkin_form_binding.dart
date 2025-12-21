import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/checkin_form_controller.dart';

class CheckInFormBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure service is available
    if (!Get.isRegistered<HikingService>()) {
      Get.put<HikingService>(HikingService(), permanent: true);
    }

    Get.lazyPut<CheckInFormController>(() => CheckInFormController());
  }
}
