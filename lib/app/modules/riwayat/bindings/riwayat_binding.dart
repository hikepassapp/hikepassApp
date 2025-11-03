import 'package:get/get.dart';
import '../../reservasi/controllers/reservasi_controller.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    // Gunakan fenix agar tidak hilang saat pindah halaman
    Get.put<ReservasiController>(ReservasiController(), permanent: true);
    Get.lazyPut<RiwayatController>(() => RiwayatController());
  }
}
