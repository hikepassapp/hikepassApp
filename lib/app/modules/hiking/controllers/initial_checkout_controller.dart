import 'package:get/get.dart';
import '../../../models/hiking_model.dart';
import '../../../services/hiking_service.dart';

class InitialCheckOutController extends GetxController {
  final HikingService _hikingService = Get.find<HikingService>();

  final Rxn<HikingModel> currentHiking = Rxn<HikingModel>();

  @override
  void onInit() {
    super.onInit();
    // Get hiking ID from route arguments
    final String? hikingId = Get.arguments as String?;
    if (hikingId != null) {
      currentHiking.value = _hikingService.getHikingById(hikingId);
    }
  }

  void proceedToCheckOutForm() {
    if (currentHiking.value != null) {
      // Save timestamp as check-out date
      _hikingService.processInitialCheckOut(currentHiking.value!.id);

      // Navigate to check-out form
      Get.toNamed('/hiking/checkout-form', arguments: currentHiking.value!.id);
    }
  }
}
