import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  var userName = 'Nailong'.obs;
  var temperature = 27.obs;
  var weatherCondition = 'Cerah Berawan'.obs;
  var location = 'Pangalengan, Kab. Bandung. Jawa Barat'.obs;

  void navigateToReservation() {
    Get.offAllNamed(Routes.reservasi);
  }

  void navigateToRiwayat() {
    Get.offAllNamed(Routes.riwayat);
  }

  void navigateToInformasi() {
    Get.offAllNamed(Routes.informasi);
  }

  void navigateToLaporan() {
    Get.offAllNamed(Routes.laporan);
  }
}
