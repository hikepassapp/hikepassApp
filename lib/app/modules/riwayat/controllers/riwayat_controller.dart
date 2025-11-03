import 'package:get/get.dart';
import '../../reservasi/controllers/reservasi_controller.dart';

class RiwayatController extends GetxController {
  late ReservasiController reservasiC;

  @override
  void onInit() {
    super.onInit();
    // Ambil instance dari ReservasiController yang sudah aktif
    reservasiC = Get.find<ReservasiController>();
  }

  // Getter untuk ambil riwayat tiket dari ReservasiController
  List<Map<String, dynamic>> get riwayat => reservasiC.riwayat;
}
