import 'package:get/get.dart';
import '../controllers/riwayat_controller.dart';
import '../../../services/riwayat_service.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<RiwayatService>()) {
      Get.put(RiwayatService(), permanent: true);
    }
    Get.lazyPut<RiwayatController>(() => RiwayatController());
  }
}
