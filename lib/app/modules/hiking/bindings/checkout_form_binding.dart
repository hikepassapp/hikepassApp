import 'package:get/get.dart';
import '../../../services/hiking_service.dart';
import '../controllers/checkout_form_controller.dart';

class CheckOutFormBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure service is available
    if (!Get.isRegistered<HikingService>()) {
      Get.lazyPut<HikingService>(() => HikingService(), fenix: true);
    }

    Get.lazyPut<CheckOutFormController>(() => CheckOutFormController());
  }
}
