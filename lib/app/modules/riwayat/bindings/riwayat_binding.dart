import 'package:get/get.dart';
import '../../reservasi/controllers/reservasi_controller.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    // Jangan buat controller baru, cukup ambil yang sudah ada
    if (!Get.isRegistered<ReservasiController>()) {
      Get.put(ReservasiController(), permanent: true);
    }
    Get.lazyPut<RiwayatController>(() => RiwayatController());
  }
}
