import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import '../../../services/hiking_service.dart';

class ReservasiBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HikingService>()) {
      Get.put<HikingService>(HikingService(), permanent: true);
    }
    Get.put(ReservasiController(), permanent: true);
  }
}
