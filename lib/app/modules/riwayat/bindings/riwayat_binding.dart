import 'package:get/get.dart';
import '../../reservasi/controllers/reservasi_controller.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReservasiController>()) {
      Get.put(ReservasiController(), permanent: true);
    }
  }
}
