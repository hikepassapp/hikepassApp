import 'package:get/get.dart';
import 'package:hikepass_app/app/modules/laporan/controllers/laporan_controller.dart';

class LaporanListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaporanController>(() => LaporanController());
  }
}
